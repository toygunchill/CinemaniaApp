//
//  UIImageView+Extensions.swift
//  CinemaniaApp
//
//  Created by Toygun Çil on 12.12.2023.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(_ url:String?) {
        guard let urlStr = url else {
            self.image = UIImage.notFound
            return
        }
        
        if url == Constants.PlaceholderText.naPlaceholder {
            self.image =  UIImage.notFound
        } else {
            let wrappedUrl = URL(string: urlStr)
            self.kf.setImage(with: wrappedUrl)
        }
    }
}
