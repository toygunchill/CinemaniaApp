//
//  NetworkManager.swift
//  CinemaniaApp
//
//  Created by Toygun Çil on 7.12.2023.
//

import Foundation

protocol IdAndTitleQueryMakeable: AnyObject {
    func makeQueryWithID(id: String, completion: @escaping (Result<TitleQueryResponse, ErrosTypes>) -> Void)
    func makeQueryWithTitle(title: String, completion: @escaping (Result< TitleQueryResponse, ErrosTypes>) -> Void)
}

protocol SearchQueryMakeable: AnyObject {
    func makeSearchQuery(page: Int, word: String, completion: @escaping (Result< SearchResponse, ErrosTypes>) -> Void)
}

final class NetworkManager {
    static let shared = NetworkManager()
    init() {}
    var coreManager = CoreNetworkManager()
}

extension NetworkManager: IdAndTitleQueryMakeable {
    func makeQueryWithID(id: String, completion: @escaping (Result<TitleQueryResponse, ErrosTypes>) -> Void) {
        let endPoint = Endpoint.idSearch(id: id)
        coreManager.request(endPoint, completion: completion)
    }

    func makeQueryWithTitle(title: String, completion: @escaping (Result< TitleQueryResponse, ErrosTypes>) -> Void) {
        let endPoint = Endpoint.titleSearch(title: title)
        coreManager.request(endPoint, completion: completion)
    }
}

extension NetworkManager: SearchQueryMakeable {

    func makeSearchQuery(page: Int, word: String, completion: @escaping (Result<SearchResponse, ErrosTypes>) -> Void) {
        let endPoint = Endpoint.search(searchWord: word, page: page)
        coreManager.request(endPoint, completion: completion)
    }
}
