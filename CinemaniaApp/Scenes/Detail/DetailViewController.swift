//
//  DetailViewController.swift
//  CinemaniaApp
//
//  Created by Toygun Çil on 10.12.2023.
//

import UIKit
import FirebaseAnalytics

protocol DetailViewInterface: AnyObject {
    var id: String? {get set}
    func startLoadingAnimation()
    func stopLoadingAnimation()
    func updateData(data: TitleQueryResponse)
}

final class DetailViewController: UIViewController, UIScrollViewDelegate {
    
    private lazy var viewModel = DetailViewModel(view: self, networkManager: NetworkManager.shared)
    var id: String?
    
    private var totalContentHeight: CGFloat = .zero
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView = UIView()
    
    private let moviePosterImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constants.CornerRadius.regular
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let movieNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: Constants.Font.extraLarge)
        label.textAlignment = .left
        label.textColor = .black
        label.text = Constants.PlaceholderText.notFound
        label.numberOfLines = .zero
        return label
    }()
    
    private let movieRatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.Font.medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.text = Constants.PlaceholderText.notFound
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var imdbLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Constants.Images.imdbLogo
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.Font.medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.text = Constants.PlaceholderText.genre
        label.numberOfLines = .zero
        return label
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = Constants.Margin.medium
        return stackView
    }()
    
    private let movieInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = Constants.Margin.regular
        return stackView
    }()
    
    
    private let topDivider: UIView = {
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = .secondaryLabel
        return divider
    }()
    
    private lazy var runtimeInfo = setupStackView(withImage: Constants.SymbolNames.clock, withTitle: Constants.PlaceholderText.runtime)
    private lazy var releasedInfo = setupStackView(withImage: Constants.SymbolNames.calendar, withTitle: Constants.PlaceholderText.released)
    private lazy var languageInfo = setupStackView(withImage: Constants.SymbolNames.globe, withTitle: Constants.PlaceholderText.language)
    
    private let bottomDivider: UIView = {
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = .secondaryLabel
        return divider
    }()
    
    private let desLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.Font.large)
        label.textAlignment = .left
        label.text = Constants.PlaceholderText.description
        label.numberOfLines = 0
        return label
    }()
    
    private let desValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.Font.medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.text = Constants.PlaceholderText.notFound
        label.numberOfLines = .zero
        return label
    }()
    
    private let countryLabel = CustomLabel(frame: .zero)
    private let actorsLabel = CustomLabel(frame: .zero)
    private let ratedLabel = CustomLabel(frame: .zero)
    private let writerLabel = CustomLabel(frame: .zero)
    private let directorLabel = CustomLabel(frame: .zero)
    private let awardsLabel = CustomLabel(frame: .zero)
    private let metaScoreLabel = CustomLabel(frame: .zero)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        self.viewModel.fetchDetailMoviesUseId(id: id)
        self.startLoadingAnimation()
        setupUI()
        setupNavigation()
        adjustScrollViewHeight()
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.adjustScrollViewHeight()
        }, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustScrollViewHeight()
    }
    
    func setupNavigation(){
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func stopLoading() {
        self.stopLoadingAnimation()
        loadingIndicator.isHidden = true
        showContent()
    }
    
    func showContent() {
        contentView.isHidden = false
    }
    
    func movieInfoView(country: String, actors: String, rated: String, writer: String, director: String, awards: String, metaScore: String) {
        countryLabel.setAttributedText(title: Constants.PlaceholderText.country, value: country)
        actorsLabel.setAttributedText(title: Constants.PlaceholderText.actors, value: actors)
        ratedLabel.setAttributedText(title: Constants.PlaceholderText.rated, value: rated)
        writerLabel.setAttributedText(title: Constants.PlaceholderText.writer, value: writer)
        directorLabel.setAttributedText(title: Constants.PlaceholderText.director, value: director)
        awardsLabel.setAttributedText(title: Constants.PlaceholderText.awards, value: awards)
        metaScoreLabel.setAttributedText(title: Constants.PlaceholderText.metaScore, value: metaScore)
    }
    
    func movieInfoStackAddSubview() {
        self.movieInfoStackView.addArrangedSubview(self.countryLabel)
        self.movieInfoStackView.addArrangedSubview(self.actorsLabel)
        self.movieInfoStackView.addArrangedSubview(self.ratedLabel)
        self.movieInfoStackView.addArrangedSubview(self.writerLabel)
        self.movieInfoStackView.addArrangedSubview(self.directorLabel)
        self.movieInfoStackView.addArrangedSubview(self.awardsLabel)
        self.movieInfoStackView.addArrangedSubview(self.metaScoreLabel)
    }
    
    func adjustScrollViewHeight() {
        totalContentHeight = .zero
        totalContentHeight += moviePosterImageView.frame.size.height + Constants.Margin.medium
        totalContentHeight += topDivider.frame.size.height + Constants.Margin.regular
        totalContentHeight += infoStackView.frame.height + Constants.Margin.small
        totalContentHeight += bottomDivider.frame.height + Constants.Margin.regular
        totalContentHeight += desLabel.frame.size.height + Constants.Margin.xLarge
        totalContentHeight += desValueLabel.frame.size.height + Constants.Margin.medium
        totalContentHeight += movieInfoStackView.frame.size.height + Constants.Margin.xLarge
        totalContentHeight += Constants.Margin.xLarge
        scrollView.contentSize = CGSize(width: contentView.frame.size.width, height: totalContentHeight)
    }
    
    private func setupStackView(withImage image: String, withTitle title: String) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        var config = UIButton.Configuration.plain()
        config.buttonSize = .medium
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: image), for: .normal)
        button.tintColor = .label
        button.tintColor = .label
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        label.font = UIFont.systemFont(ofSize: Constants.Font.regular)
        label.textColor = .secondaryLabel
        
        stackView.addArrangedSubview(button)
        stackView.addArrangedSubview(label)
        
        return stackView
    }
    
    func setupUI() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.view.backgroundColor = .systemBackground
        contentView.isHidden = true
        self.view.addSubview(scrollView)
        self.view.addSubview(loadingIndicator)
        
        scrollView.addSubview(contentView)
        scrollView.addSubview(contentView)
        contentView.addSubview(moviePosterImageView)
        
        contentView.addSubview(genreLabel)
        contentView.addSubview(movieNameLabel)
        contentView.addSubview(movieRatingLabel)
        contentView.addSubview(imdbLogo)
        contentView.addSubview(topDivider)
        
        contentView.addSubview(bottomDivider)
        contentView.addSubview(infoStackView)
        
        infoStackView.addArrangedSubview(runtimeInfo)
        infoStackView.addArrangedSubview(releasedInfo)
        infoStackView.addArrangedSubview(languageInfo)
        
        contentView.addSubview(movieInfoStackView)
        contentView.addSubview(movieInfoStackView)
        contentView.addSubview(desLabel)
        contentView.addSubview(desValueLabel)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            moviePosterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.Margin.medium),
            moviePosterImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: Constants.Margin.posterImageMultiplier),
            moviePosterImageView.heightAnchor.constraint(equalTo: moviePosterImageView.widthAnchor, multiplier: Constants.Margin.posterImageAspectRatio),
            moviePosterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Margin.xLarge),
            movieNameLabel.topAnchor.constraint(equalTo: moviePosterImageView.topAnchor, constant: Constants.Margin.small),
            movieNameLabel.leadingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor, constant: Constants.Margin.large),
            movieNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Margin.xLarge),
            
            
            imdbLogo.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: Constants.Margin.xLarge),
            imdbLogo.leadingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor, constant: Constants.Margin.large),
            imdbLogo.heightAnchor.constraint(equalToConstant: Constants.Margin.xLarge),
            imdbLogo.widthAnchor.constraint(equalToConstant: Constants.Margin.ExtraLarge),
            
            movieRatingLabel.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: Constants.Margin.xLarge),
            movieRatingLabel.leadingAnchor.constraint(equalTo: imdbLogo.trailingAnchor, constant: Constants.Margin.small),
            movieRatingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Margin.xLarge),
            
            genreLabel.topAnchor.constraint(equalTo: imdbLogo.bottomAnchor, constant: Constants.Margin.xLarge),
            genreLabel.leadingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor, constant: Constants.Margin.large),
            genreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Margin.xLarge),
            
            topDivider.topAnchor.constraint(equalTo: moviePosterImageView.bottomAnchor, constant: Constants.Margin.regular),
            topDivider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Margin.regular),
            topDivider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Margin.regular),
            topDivider.heightAnchor.constraint(equalToConstant: Constants.Margin.regularHeight),
            
            infoStackView.topAnchor.constraint(equalTo: topDivider.bottomAnchor, constant: Constants.Margin.small),
            infoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            bottomDivider.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: Constants.Margin.regular),
            bottomDivider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Margin.regular),
            bottomDivider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Margin.regular),
            bottomDivider.heightAnchor.constraint(equalToConstant: Constants.Margin.regularHeight),
            
            desLabel.topAnchor.constraint(equalTo: bottomDivider.bottomAnchor, constant: Constants.Margin.xLarge),
            desLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Margin.xLarge),
            desLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Margin.xLarge),
            
            desValueLabel.topAnchor.constraint(equalTo: desLabel.bottomAnchor, constant: Constants.Margin.medium),
            desValueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Margin.xLarge),
            desValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Margin.xLarge),
            
            movieInfoStackView.topAnchor.constraint(equalTo: desValueLabel.bottomAnchor, constant: Constants.Margin.xLarge),
            movieInfoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Margin.xLarge),
            movieInfoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Margin.xLarge),
        ])
    }
}


extension DetailViewController: DetailViewInterface {
    func startLoadingAnimation() {
        DispatchQueue.main.async {
            self.loadingIndicator.startAnimating()
        }
    }
    
    func stopLoadingAnimation() {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
        }
    }
    func updateData(data: TitleQueryResponse) {
        DispatchQueue.main.async {
            if let movieDetail = self.viewModel.data {
                self.title = movieDetail.title
                if let poster = movieDetail.poster {
                    self.moviePosterImageView.setImage(poster)
                }
                self.movieNameLabel.text = movieDetail.title
                
                self.movieRatingLabel.text = movieDetail.imdbRating
                self.genreLabel.text = movieDetail.genre
                
                if let country = movieDetail.country,
                   let actors = movieDetail.actors,
                   let rated = movieDetail.rated,
                   let writer = movieDetail.writer,
                   let director = movieDetail.director,
                   let awards = movieDetail.awards,
                   let metascore = movieDetail.metascore {
                    self.movieInfoView(country: country,
                                       actors: actors,
                                       rated: rated,
                                       writer: writer,
                                       director: director,
                                       awards: awards,
                                       metaScore: metascore)
                }
                
                self.desValueLabel.text = movieDetail.plot

                AnalyticsManager.shared.log(.movieSelected(movieDetail))
                
                if let runtime = movieDetail.runtime,
                   let released = movieDetail.released,
                   let language = movieDetail.language {
                    self.runtimeInfo = self.setupStackView(withImage: Constants.SymbolNames.clock, withTitle: runtime)
                    self.releasedInfo = self.setupStackView(withImage: Constants.SymbolNames.calendar, withTitle: released)
                    self.languageInfo = self.setupStackView(withImage: Constants.SymbolNames.globe, withTitle: language)
                }
            }
            
            self.movieInfoStackAddSubview()
            self.stopLoadingAnimation()
            self.loadingIndicator.isHidden = true
            self.showContent()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.AnimationDuration.transition) {
                self.adjustScrollViewHeight()
            }
        }
        
    }
}
