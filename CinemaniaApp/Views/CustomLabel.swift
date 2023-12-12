//
//  CustomLabel.swift
//  CinemaniaApp
//
//  Created by Toygun Çil on 11.12.2023.
//

import UIKit

final class CustomLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        textAlignment = .left
        text = Constants.PlaceholderText.notFound
        numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAttributedText(title: String, value: String) {
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: Constants.Font.large) as Any,
            ]
            
            let valueAttributes: [NSAttributedString.Key: Any] = [
                .font:UIFont.systemFont(ofSize: Constants.Font.medium) as Any,
                .foregroundColor: UIColor.secondaryLabel
            ]
            
            let attributedText = NSMutableAttributedString()
            
            let titleString = NSAttributedString(string: title, attributes: titleAttributes)
            let valueString = NSAttributedString(string: value, attributes: valueAttributes)
            
            attributedText.append(titleString)
            attributedText.append(NSAttributedString(string: " : "))
            attributedText.append(valueString)
            
            self.attributedText = attributedText
    }
}
