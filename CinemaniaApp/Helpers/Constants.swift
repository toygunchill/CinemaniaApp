//
//  Constants.swift
//  CinemaniaApp
//
//  Created by Toygun Çil on 9.12.2023.
//

import UIKit

struct Constants {
    struct Margin {
        static let large: CGFloat = 24
        static let regular: CGFloat = 12
        static let medium: CGFloat = 6
        static let small: CGFloat = 4
    }
    
    struct Font {
        static let extraLarge: CGFloat = 30
        static let large: CGFloat = 22
        static let medium: CGFloat = 16
        static let medium2: CGFloat = 14
        static let regular: CGFloat = 12
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
