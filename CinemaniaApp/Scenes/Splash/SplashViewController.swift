//
//  ViewController.swift
//  CinemaniaApp
//
//  Created by Toygun Çil on 7.12.2023.
//

import UIKit

protocol SplashViewInterface: AnyObject {
    func showAlert()
    func updateUI(str: String)
    func setupUI()
    func toFeedVC()
    var isConnect: Bool {get set}
}

final class SplashViewController: UIViewController {
    
    private let splashLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        return lbl
    }()
    
    private lazy var viewModel = SplashViewModel(view: self)
    
    var connectionManager: ConnectionManagerInterface?
    var isConnect: Bool = false
    
    init(connectionManager: ConnectionManagerInterface) {
        self.connectionManager = connectionManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.connectionManager?.isConnectedNetwork { [weak self] isConnect in
            guard let self = self else {return}
            self.isConnect = isConnect
            if isConnect {
                self.viewModel.fetchValue()
            } else {
                showAlert()
            }
        }
    }
    
    private func retryConnection() {
        self.connectionManager?.isConnectedNetwork { [weak self] isConnect in
            guard let self = self else { return }
            self.isConnect = isConnect
            if isConnect {
                self.viewModel.fetchValue()
            } else {
                showAlert()
                print("Retry failed")
            }
        }
    }
}

extension SplashViewController: SplashViewInterface {
    func showAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: "No Internet Connection!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Try again", style: UIAlertAction.Style.default) { _ in
                self.retryConnection()
            })
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func toFeedVC() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            let feedVC = FeedViewController()
            self.navigationController?.pushViewController(feedVC, animated: true)
        }
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
    
    func updateUI(str: String) {
        DispatchQueue.main.async {
            if self.isConnect {
                self.splashLabel.text = str
                self.toFeedVC()
            }
        }
    }
}
