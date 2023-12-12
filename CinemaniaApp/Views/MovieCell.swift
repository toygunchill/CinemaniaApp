//
//  FeedCell.swift
//  CinemaniaApp
//
//  Created by Toygun Çil on 9.12.2023.
//

import UIKit

final class MovieCell: UICollectionViewCell {
    static let identifier = Constants.Identifier.cellIdentifier
    
    private let posterImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = Constants.CornerRadius.medium
        image.layer.masksToBounds = true
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: Constants.Font.large)
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.text = Constants.PlaceholderText.notFound
        return label
    }()
    
    private let yearIcon: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = Constants.Images.yearIcon
        icon.tintColor = .secondaryLabel
        return icon
    }()
    
    private let typeIcon: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = Constants.Images.typeIcon
        icon.tintColor = .secondaryLabel
        return icon
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.Font.medium)
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        label.text = Constants.PlaceholderText.notFound
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.Font.medium)
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        label.text = Constants.PlaceholderText.notFound
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBlurView()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(posterImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(yearLabel)
        contentView.addSubview(yearIcon)
        contentView.addSubview(typeLabel)
        contentView.addSubview(typeIcon)
        
        NSLayoutConstraint.activate([
            posterImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.Margin.small),
            posterImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Margin.small),
            posterImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.Margin.small),
            posterImage.widthAnchor.constraint(equalToConstant: Constants.Margin.TripleExtraLarge),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.Margin.small),
            titleLabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: Constants.Margin.regular),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Margin.small),
            
            yearIcon.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.Margin.small),
            yearIcon.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: Constants.Margin.regular),
            
            yearLabel.centerYAnchor.constraint(equalTo: yearIcon.centerYAnchor),
            yearLabel.leadingAnchor.constraint(equalTo: yearIcon.trailingAnchor, constant: Constants.Margin.small),
            
            typeIcon.topAnchor.constraint(equalTo: yearIcon.bottomAnchor, constant: Constants.Margin.regular),
            typeIcon.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: Constants.Margin.regular),
            
            typeLabel.centerYAnchor.constraint(equalTo: typeIcon.centerYAnchor),
            typeLabel.leadingAnchor.constraint(equalTo: typeIcon.trailingAnchor, constant: Constants.Margin.small),
        ])
    }
    
    private func setupBlurView() {
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.contentView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.layer.cornerRadius = Constants.CornerRadius.large
        blurView.clipsToBounds = true
        self.contentView.addSubview(blurView)
        self.contentView.sendSubviewToBack(blurView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: Constants.Insets.contentView)
    }
    
    func configureCell(posterImage: String,titleLabel: String, yearLabel: String, typeLabel: String) {
        self.posterImage.setImage(posterImage)
        self.titleLabel.text = titleLabel
        self.yearLabel.text = yearLabel
        self.typeLabel.text = typeLabel.capitalized
    }
}
