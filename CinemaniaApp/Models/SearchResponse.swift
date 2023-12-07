//
//  SearchResponse.swift
//  CinemaniaApp
//
//  Created by Toygun Çil on 7.12.2023.
//

import Foundation

struct SearchResponse: Codable {
    let search: [Search]?
    let totalResults, response: String?

    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
    }
}

// MARK: - Search
struct Search: Codable {
    let title, year, imdbID : String?
    let poster: String?
    let type: TypeEnum?

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
    
    enum TypeEnum: String, Codable {
        case game = "game"
        case movie = "movie"
        case series = "series"
    }
}
