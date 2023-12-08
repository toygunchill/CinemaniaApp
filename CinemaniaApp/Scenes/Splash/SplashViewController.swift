//
//  ViewController.swift
//  CinemaniaApp
//
//  Created by Toygun Çil on 7.12.2023.
//

import UIKit
import FirebaseRemoteConfig

class SplashViewController: UIViewController {
    
    private let splashLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        return lbl
    }()

    private let remoteConfig = RemoteConfig.remoteConfig()
    
    var networkManager: (IdAndTitleQueryMakeable & SearchQueryMakeable)?
    var connectionManager: ConnectionManagerInterface?
    
    init(networkManager: IdAndTitleQueryMakeable & SearchQueryMakeable, connectionManager: ConnectionManagerInterface) {
        self.networkManager = networkManager
        self.connectionManager = connectionManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        connectionManager?.isConnectedNetwork { [weak self] isConnect in
            guard let self = self else {return}
            print(isConnect)
        }
        networkManager?.makeQueryWithTitle(title: "batman") { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(failure)
            }
        }
        
        fetchValue()
    }
    
    func setupUI() {
        self.view.backgroundColor = .white
        splashLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(splashLabel)
        NSLayoutConstraint.activate([
            splashLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            splashLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }

    func fetchValue() {
        let defaults : [String:NSObject] = [
            "splashLabelString": "Loodos" as NSObject
        ]
        
        remoteConfig.setDefaults(defaults)
        
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        
        self.remoteConfig.fetch(withExpirationDuration: 0) { status, error in
            if status == .success, error == nil {
                self.remoteConfig.activate { isChanged, error in
                    guard error == nil else {
                        return
                    }
                    if isChanged {
                        if let value = self.remoteConfig.configValue(forKey: "splashLabelString").stringValue {
                            print("Benim config değerim \(value)")
                            self.updateUI(str: value)
                        } else {
                            print("just error if let")
                        }
                    } else {
                        if let defaultValue = self.remoteConfig.configValue(forKey: "splashLabelString").stringValue {
                            self.updateUI(str: defaultValue)
                        } else {
                            print("Varsayılan değeri bulunamadı")
                        }
                    }
                }
            } else {
                print("just error")
            }
            
        }
        
    }
    
    func updateUI(str: String) {
        DispatchQueue.main.async {
            self.splashLabel.text = str
        }
    }

}
