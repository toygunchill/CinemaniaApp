//
//  ViewController.swift
//  CinemaniaApp
//
//  Created by Toygun Çil on 7.12.2023.
//

import UIKit

class ViewController: UIViewController {
    
    private let splashLabel: UILabel = {
        let lbl = UILabel()
        return lbl
    }()

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
    }
    
    func setupUI() {
        self.view.addSubview(splashLabel)
        NSLayoutConstraint.activate([
            splashLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            splashLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }


}
