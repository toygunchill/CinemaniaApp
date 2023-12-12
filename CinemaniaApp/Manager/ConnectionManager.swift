//
//  NetworkManager.swift
//  CinemaniaApp
//
//  Created by Toygun Çil on 7.12.2023.
//

import Foundation
import Network

protocol ConnectionManagerInterface : AnyObject {
    func isConnectedNetwork(completion: @escaping (Bool) -> Void)
}

final class ConnectionManager: ConnectionManagerInterface {
    
    func isConnectedNetwork(completion: @escaping (Bool) -> Void) {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            switch path.status {
            case .satisfied:
                completion(true)
                monitor.cancel()
            default:
                completion(false)
                monitor.cancel()
            }
        }
        let queue = DispatchQueue(label: Constants.CmKeys.key)
        monitor.start(queue: queue)
    }
}
