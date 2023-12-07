//
//  TitleQueryResponse.swift
//  CinemaniaApp
//
//  Created by Toygun Çil on 7.12.2023.
//

import Foundation

struct TitleQueryResponse: Codable {
    let title, year, rated, released: String?
    let runtime, genre, director, writer: String?
    let actors, plot, language, country: String?
    let awards, poster, metascore, imdbRating, imdbVotes, imdbID, type, response: String?
    let ratings: [Rating]?

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case actors = "Actors"
        case awards = "Awards"
        case country = "Country"
        case director = "Director"
        case genre = "Genre"
        case language = "Language"
        case metascore = "Metascore"
        case plot = "Plot"
        case poster = "Poster"
        case rated = "Rated"
        case ratings = "Ratings"
        case released = "Released"
        case response = "Response"
        case runtime = "Runtime"
        case type = "Type"
        case writer = "Writer"
        case year = "Year"
        case  imdbRating, imdbVotes, imdbID
    }
}

struct Rating: Codable {
    let source, value: String?

    enum CodingKeys: String, CodingKey {
        case source, value
    }
}
