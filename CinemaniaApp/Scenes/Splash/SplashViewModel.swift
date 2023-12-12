//
//  FeedViewModel.swift
//  CinemaniaApp
//
//  Created by Toygun Çil on 12.12.2023.
//

import Foundation
import FirebaseRemoteConfig

protocol SplashViewModelInterface {
    func fetchValue()
}

final class SplashViewModel {
    private weak var view: SplashViewInterface?
    private let remoteConfig = RemoteConfig.remoteConfig()
    
    init(view: SplashViewInterface) {
        self.view = view
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
                    guard error == nil else { return }
                    if isChanged {
                        if let value = self.remoteConfig.configValue(forKey: "splashLabelString").stringValue {
                            print("Benim config değerim \(value)")
                            self.view?.updateUI(str: value)
                        } else {
                            print("just error if let")
                        }
                    } else {
                        if let defaultValue = self.remoteConfig.configValue(forKey: "splashLabelString").stringValue {
                            self.view?.updateUI(str: defaultValue)
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
}
