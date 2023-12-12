//
//  Constants.swift
//  CinemaniaApp
//
//  Created by Toygun Çil on 9.12.2023.
//

import UIKit

struct Constants {
    struct Margin {
        static let UltraLarge: CGFloat = 140
        static let TripleExtraLarge: CGFloat = 91
        static let DoubleExtraLarge: CGFloat = 44
        static let ExtraLarge: CGFloat = 40
        static let xLarge: CGFloat = 20
        static let large: CGFloat = 15
        static let regular: CGFloat = 12
        static let medium: CGFloat = 10
        static let small: CGFloat = 6
        
        static let regularHeight: CGFloat = 1
        static let posterImageMultiplier: CGFloat = 0.38
        static let posterImageAspectRatio: CGFloat = 1.67
    }
    
    struct Font {
        static let extraLarge: CGFloat = 30
        static let large: CGFloat = 22
        static let medium: CGFloat = 16
        static let regular: CGFloat = 12
    }
    
    struct SymbolNames {
        static let clock = "clock"
        static let calendar = "calendar"
        static let globe = "globe"
    }
    
    struct AnimationDuration {
        static let transition: TimeInterval = 0.1
    }
    
    struct Title {
        static let appTitle = "Cinemania🍿"
    }
    

    struct PlaceholderText {
        static let notFound = "Not Found"
        static let movieTitle = "Movie Title"
        static let rating = "Rating"
        static let genre = "Genre"
        static let description = "Description"
        static let country = "Country"
        static let actors = "Actors"
        static let rated = "Rated"
        static let writer = "Writer"
        static let director = "Director"
        static let awards = "Awards"
        static let metaScore = "Meta Score"
        static let runtime = "Runtime"
        static let released = "Released"
        static let language = "Language"
        static let naPlaceholder = "N/A"
        static let search = "Search"
    }
    
    struct Images {
        static let imdbLogo = UIImage(named: "imdblogo")
        static let notFound = UIImage(named: "notFound")
        static let yearIcon = UIImage(systemName: "calendar")
        static let typeIcon = UIImage(systemName: "movieclapper")
    }
    
    struct AnalyticsEvents {
        static let movieSelected = "movie_selected"
    }

    struct CornerRadius {
        static let large: CGFloat = 16
        static let medium: CGFloat = 12
        static let regular: CGFloat = 10
    }
    
    struct Insets {
        static let contentView = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        static let sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        static let frameInset = CGRect(x: 0, y: 0, width: 100, height: 44)
    }
    
    struct Count {
        static let one = 1
    }
    
    struct CmKeys {
        static let key = "NetworkMonitor"
    }
    
    struct Identifier {
        static let cellIdentifier = "MovieCell"
    }

    struct Window {
        private static let window = UIApplication.shared.connectedScenes.first as? UIWindowScene
        static var getTopPadding: CGFloat {
            return window?.windows.first?.safeAreaInsets.top ?? 0
        }
        static var getBottomPadding: CGFloat {
            return window?.windows.first?.safeAreaInsets.bottom ?? 0
        }
    }
}
