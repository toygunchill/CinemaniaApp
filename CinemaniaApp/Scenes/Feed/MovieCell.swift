//
//  FeedCell.swift
//  CinemaniaApp
//
//  Created by Toygun Çil on 9.12.2023.
//

import UIKit
import Kingfisher

class MovieCell: UICollectionViewCell {
    static let identifier = "MovieCell"
    
    private lazy var posterImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 12
        image.layer.masksToBounds = true
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: Constants.Font.large)
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var yearIcon: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = UIImage(systemName: "calendar")
        icon.tintColor = .secondaryLabel
        return icon
    }()
    
    private lazy var typeIcon: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = UIImage(systemName: "movieclapper")
        icon.tintColor = .secondaryLabel
        return icon
    }()
    
    private lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.Font.medium)
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.Font.medium)
        label.textAlignment = .left
        label.textColor = .secondaryLabel
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
            posterImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.Margin.medium),
            posterImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Margin.medium),
            posterImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.Margin.medium),
            posterImage.widthAnchor.constraint(equalToConstant: 90),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.Margin.medium),
            titleLabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: Constants.Margin.regular),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Margin.medium),
            
            yearIcon.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.Margin.medium),
            yearIcon.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: Constants.Margin.regular),
            
            yearLabel.centerYAnchor.constraint(equalTo: yearIcon.centerYAnchor),
            yearLabel.leadingAnchor.constraint(equalTo: yearIcon.trailingAnchor, constant: Constants.Margin.medium),
            
            typeIcon.topAnchor.constraint(equalTo: yearIcon.bottomAnchor, constant: Constants.Margin.regular),
            typeIcon.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: Constants.Margin.regular),
            
            typeLabel.centerYAnchor.constraint(equalTo: typeIcon.centerYAnchor),
            typeLabel.leadingAnchor.constraint(equalTo: typeIcon.trailingAnchor, constant: Constants.Margin.medium),
        ])
    }
    
    func setupBlurView() {
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.contentView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.layer.cornerRadius = 16
        blurView.clipsToBounds = true
        self.contentView.addSubview(blurView)
        self.contentView.sendSubviewToBack(blurView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8))
    }
    
    func configureCell(posterImage: String,titleLabel: String, yearLabel: String, typeLabel: String) {
        if let url = URL(string: posterImage){
            self.posterImage.kf.setImage(with: url)
        }
        self.titleLabel.text = titleLabel
        self.yearLabel.text = "(\(yearLabel))"
        self.typeLabel.text = typeLabel.capitalized
    }
}
