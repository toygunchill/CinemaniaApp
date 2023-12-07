//
//  NetworkHelpers.swift
//  CinemaniaApp
//
//  Created by Toygun Çil on 7.12.2023.
//

import Foundation

protocol EndpointProtocol {
    var apiToken: String {get}
    var baseURL: String {get}
    var path: String {get}
    var method: HTTPMethod {get}
    var header: [String: String]? {get}
    var parameters: [String: Any]? {get}
    func request() -> URLRequest
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case patch = "PATCH"
}

enum Endpoint {
    case search(searchWord: String, year: String?, type: String?)
    case titleSearch(title: String)
    case idSearch(id: String)
}

extension Endpoint: EndpointProtocol {
    var apiToken: String {
        return "f46c0017"
    }
    

    var baseURL: String {
            return "https://www.omdbapi.com"
        }

    var path: String {
        switch self {
        case .search, .titleSearch, .idSearch: return "/"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var header: [String : String]? {
        let header: [String: String] = ["Content-type": "application/json; charset=UTF-8"]
        return header
    }
    
    var parameters: [String : Any]? {
        return nil
    }
    
    func request() -> URLRequest {
        guard var components = URLComponents(string: baseURL) else {
            fatalError("URL ERROR")
        }
        
        //Add QueryItem
        let urlqueryItemOfApiKey = URLQueryItem(name: "apikey", value: apiToken)
        
        if case .titleSearch(let title) = self {
            components.queryItems = [urlqueryItemOfApiKey,
                                     URLQueryItem(name: "t", value: title)
            ]
        }
        
        if case .idSearch(let id) = self {
            components.queryItems = [urlqueryItemOfApiKey,
                                     URLQueryItem(name: "i", value: id)
            ]
        }
        
        if case .search(let searchWord, let year, let type) = self {
            var queryItems: [URLQueryItem] = [urlqueryItemOfApiKey, URLQueryItem(name: "s", value: searchWord)]
            
            if let year = year {
                let yearQueryItem = URLQueryItem(name: "y", value: String(describing: year))
                queryItems.append(yearQueryItem)
            }
            
            if let type = type {
                let typeQueryItem = URLQueryItem(name: "type", value: String(describing: type))
                queryItems.append(typeQueryItem)
            }
            
            components.queryItems = queryItems
        }
        components.path = path
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = method.rawValue
        
        //Add Paramters
        if let parameters {
            do {
                let data = try JSONSerialization.data(withJSONObject: parameters)
                request.httpBody = data
            }catch {
                print(error.localizedDescription)
            }
        }
        
        if let header = header {
            for (key, value) in header {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        return request
    }
}
