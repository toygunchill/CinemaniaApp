//
//  AnalyticsManager.swift
//  CinemaniaApp
//
//  Created by Toygun Çil on 11.12.2023.
//

import Foundation
import FirebaseAnalytics

final class AnalyticsManager {
    private init() {}
    
    static let shared = AnalyticsManager()
    
    public func log(_ event: AnalyticsEvent) {
        var parameters: [String: Any] = [:]
        switch event {
        case .movieSelected(let movieSelectedEvent):
            do {
                let data = try JSONEncoder().encode(movieSelectedEvent)
                let dict = try JSONSerialization.jsonObject(with: data) as? [String : Any] ?? [:]
                parameters = dict
            } catch {
                
            }
        }
        
        print("\n Event: \(event.eventName) | Params: \(parameters)")
        Analytics.logEvent(event.eventName,
                           parameters: parameters)
    }
}

enum AnalyticsEvent {
    case movieSelected(TitleQueryResponse) // moviesekectedevent olacaktı böyle denedik
    var eventName: String {
        switch self {
        case .movieSelected: return "movie_selected"
        }
    }
}

//struct MovieSelectedEvent: Codable {
//    let title, rated, released: String?
//    let runtime, genre, director, writer: String?
//    let actors, plot, language, country: String?
//    let awards, poster, metascore, imdbRating, imdbID: String?
//}
