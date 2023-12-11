//
//  DetailViewController.swift
//  CinemaniaApp
//
//  Created by Toygun Çil on 10.12.2023.
//

import UIKit
import FirebaseAnalytics
import FirebaseAnalyticsSwift//

protocol DetailViewInterface: AnyObject {
    var id: String? {get set}
    func updateData(data: TitleQueryResponse)
}

class DetailViewController: UIViewController, UIScrollViewDelegate {
    
    private lazy var viewModel = DetailViewModel(view: self, networkManager: NetworkManager.shared)
    var id: String?
    
    private var totalContentHeight: CGFloat = 0
    
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
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let movieNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: Constants.Font.extraLarge)
        label.textAlignment = .left
        label.textColor = .black
        label.text = "Not Found"
        label.numberOfLines = 0
        return label
    }()
    
    private let movieRatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.Font.medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.text = "Not Found"
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var imdbLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.imdbLogo
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.Font.medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.text = "Genre"
        label.numberOfLines = 0
        return label
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    private let movieInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        return stackView
    }()
    
    
    private lazy var divider1: UIView = {
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = .secondaryLabel
        return divider
    }()
    
    private lazy var runtimeInfo = makeAction(withImage: "clock", withTitle: "Runtime")
    private lazy var releasedInfo = makeAction(withImage: "calendar", withTitle: "Released")
    private lazy var languageInfo = makeAction(withImage: "globe", withTitle: "Language")
    
    private lazy var divider2: UIView = {
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
        label.text = "Description"
        label.numberOfLines = 0
        return label
    }()
    
    private let desValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.Font.medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.text = "Not Found"
        label.numberOfLines = 0
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

        viewModel.fetchDetailMoviesUseId(id: id)
        
        loadingIndicator.startAnimating()
        contentView.isHidden = true
        view.backgroundColor = .systemBackground
        contentView.translatesAutoresizingMaskIntoConstraints = false
        configureAddSubview()
        setUpConstrains()
        setUpNavigation()
        self.adjustScrollViewHeight()
        scrollView.delegate = self
        
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
        print("scrollView frame: \(scrollView.frame)")
        print("scrollView contentSize: \(scrollView.contentSize)")

    }
    
    func setUpNavigation(){
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = true
    }

    func stopLoading() {
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
        showContent()
    }
    
    func showContent() {
        contentView.isHidden = false
    }
    
    func movieInfoView(country: String, actors: String, rated: String, writer: String, director: String, awards: String, metaScore: String) {
        countryLabel.setAttributedText(title: "Country", value: country)
        actorsLabel.setAttributedText(title: "Actors", value: actors)
        ratedLabel.setAttributedText(title: "Rated", value: rated)
        writerLabel.setAttributedText(title: "Writer", value: writer)
        directorLabel.setAttributedText(title: "Director", value: director)
        awardsLabel.setAttributedText(title: "Awards", value: awards)
        metaScoreLabel.setAttributedText(title: "Meta Score", value: metaScore)
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
    
    func configureAddSubview() {
        view.addSubview(scrollView)
        view.addSubview(loadingIndicator)
        scrollView.addSubview(contentView)
        scrollView.addSubview(contentView)
        contentView.addSubview(moviePosterImageView)
      
        contentView.addSubview(genreLabel)
        contentView.addSubview(movieNameLabel)
        contentView.addSubview(movieRatingLabel)
        contentView.addSubview(imdbLogo)
        contentView.addSubview(divider1)
        
        contentView.addSubview(divider2)
        contentView.addSubview(infoStackView)
        
        infoStackView.addArrangedSubview(runtimeInfo)
        infoStackView.addArrangedSubview(releasedInfo)
        infoStackView.addArrangedSubview(languageInfo)
        
        contentView.addSubview(movieInfoStackView)
        contentView.addSubview(movieInfoStackView)
        contentView.addSubview(desLabel)
        contentView.addSubview(desValueLabel)
    }
    
    func adjustScrollViewHeight() {
        totalContentHeight = 0
        totalContentHeight += moviePosterImageView.frame.size.height + 10
        totalContentHeight += divider1.frame.size.height + 10
        totalContentHeight += infoStackView.frame.height + 10
        totalContentHeight += divider2.frame.height + 10
        totalContentHeight += desLabel.frame.size.height + 20
        totalContentHeight += desValueLabel.frame.size.height + 20
        totalContentHeight += actorsLabel.frame.size.height + 8
        totalContentHeight += movieInfoStackView.frame.size.height + 8
        scrollView.contentSize = CGSize(width: contentView.frame.size.width, height: totalContentHeight)
    }
    
    private func makeAction(withImage image: String, withTitle title: String) -> UIStackView {
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
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        
        stackView.addArrangedSubview(button)
        stackView.addArrangedSubview(label)
        
        return stackView
    }
    
    func setUpConstrains() {
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
        
            moviePosterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            moviePosterImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.38),
            moviePosterImageView.heightAnchor.constraint(equalTo: moviePosterImageView.widthAnchor, multiplier: 1.67),
            moviePosterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            movieNameLabel.topAnchor.constraint(equalTo: moviePosterImageView.topAnchor, constant: 5),
            movieNameLabel.leadingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor, constant: 15),
            movieNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            
            imdbLogo.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 20),
            imdbLogo.leadingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor, constant: 15),
            imdbLogo.heightAnchor.constraint(equalToConstant: 20),
            imdbLogo.widthAnchor.constraint(equalToConstant: 40),
            
            movieRatingLabel.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 20),
            movieRatingLabel.leadingAnchor.constraint(equalTo: imdbLogo.trailingAnchor, constant: 4),
            movieRatingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            genreLabel.topAnchor.constraint(equalTo: imdbLogo.bottomAnchor, constant: 20),
            genreLabel.leadingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor, constant: 15),
            genreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            divider1.topAnchor.constraint(equalTo: moviePosterImageView.bottomAnchor, constant: 12),
            divider1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            divider1.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            divider1.heightAnchor.constraint(equalToConstant: 1),
            
            infoStackView.topAnchor.constraint(equalTo: divider1.bottomAnchor, constant: 6),
            infoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                    
            divider2.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 12),
            divider2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            divider2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            divider2.heightAnchor.constraint(equalToConstant: 1),
            
            desLabel.topAnchor.constraint(equalTo: divider2.bottomAnchor, constant: 20),
            desLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            desLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            desValueLabel.topAnchor.constraint(equalTo: desLabel.bottomAnchor, constant: 10),
            desValueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            desValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            movieInfoStackView.topAnchor.constraint(equalTo: desValueLabel.bottomAnchor, constant: 20),
            movieInfoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            movieInfoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }
}


extension DetailViewController: DetailViewInterface {
    func updateData(data: TitleQueryResponse) {
        DispatchQueue.main.async {
            let movieDetail = self.viewModel.data
            self.title = movieDetail?.title
            if let url = URL(string: movieDetail?.poster ?? "") {
//                blurImageView.kf.setImage(with: url)
                self.moviePosterImageView.kf.setImage(with: url)
            } else {
                self.moviePosterImageView.image =  UIImage(named: "no_poster")
            }
            
            self.movieNameLabel.text = movieDetail?.title
            
            self.movieRatingLabel.text = movieDetail?.imdbRating
            self.genreLabel.text = movieDetail?.genre
            
            self.runtimeInfo = self.makeAction(withImage: "clock", withTitle: self.viewModel.data?.runtime ?? "")
            self.releasedInfo = self.makeAction(withImage: "calendar", withTitle: self.viewModel.data?.released ?? "")
            self.languageInfo = self.makeAction(withImage: "globe", withTitle: self.viewModel.data?.language ?? "")
            
            self.desValueLabel.text = movieDetail?.plot
            
            self.movieInfoView(country: movieDetail?.country ?? "", actors: movieDetail?.actors ?? "", rated: movieDetail?.rated ?? "", writer: movieDetail?.writer ?? "", director: movieDetail?.director ?? "", awards: movieDetail?.awards ?? "", metaScore: movieDetail?.metascore ?? "")
            
            self.movieInfoStackAddSubview()
            self.stopLoading()
            self.showContent()
            
            if let movieDetail {
                AnalyticsManager.shared.log(.movieSelected(movieDetail))
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.adjustScrollViewHeight()
            }
        }
        
    }
}
