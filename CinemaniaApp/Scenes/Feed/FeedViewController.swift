//
//  SecondViewController.swift
//  CinemaniaApp
//
//  Created by Toygun Çil on 7.12.2023.
//

import UIKit

protocol FeedViewInterface: AnyObject {
    func reloadCollectionView()
    func updateData(data: [Search])
    func errorView(error: String)
    func startLoadingAnimation()
    func stopLoadingAnimation()
    func toDetailVC(item: Int)
    var data: [Search]? { get set }
}

final class FeedViewController: UIViewController {

    private lazy var viewModel = FeedViewModel(view: self, networkManager: NetworkManager.shared)
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private let navigationView : UIView = {
        let navigationView = UIView()
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        navigationView.backgroundColor = .white
        return navigationView
    }()
    
    private let moviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = Constants.Insets.sectionInset
        layout.minimumInteritemSpacing = Constants.Margin.medium
        layout.minimumLineSpacing = Constants.Margin.medium
        let width = UIScreen.main.bounds.width
        let itemWidth = (width - Constants.Margin.DoubleExtraLarge)
        layout.itemSize = CGSize(width: itemWidth, height: Constants.Margin.UltraLarge)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)
        return collectionView
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.isHidden = true
        return indicator
    }()

    var data: [Search]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSearchController()
        setupNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigation()
    }
    
    private func setupNavigation(){
        title = Constants.Title.appTitle
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.hidesBackButton = true
    }
    
    private func setupUI() {
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        moviesCollectionView.isScrollEnabled = true
        moviesCollectionView.showsVerticalScrollIndicator = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        self.view.backgroundColor = .white
        self.view.addSubview(moviesCollectionView)
        self.view.addSubview(navigationView)
        self.view.addSubview(errorLabel)
        self.view.addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            navigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationView.topAnchor.constraint(equalTo: view.topAnchor, constant: -(Constants.Window.getTopPadding + Constants.Margin.TripleExtraLarge)),
            navigationView.heightAnchor.constraint(equalToConstant: Constants.Window.getTopPadding + Constants.Margin.TripleExtraLarge),
            moviesCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.Margin.small),
            moviesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Margin.xLarge),
            moviesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Margin.xLarge),
            moviesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.Margin.xLarge),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setupSearchController() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.PlaceholderText.search
        searchController.searchBar.tintColor = .black
        searchController.searchBar.searchTextField.backgroundColor = .white
        searchController.searchBar.clipsToBounds = true
        searchController.searchBar.frame = Constants.Insets.frameInset
        searchController.searchBar.searchTextField.leftView?.tintColor = .black
        searchController.searchBar.searchTextField.backgroundColor = .white
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
}

extension FeedViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == (viewModel.movies.count) - Constants.Count.one {
            guard let text = searchController.searchBar.text else { return }
            self.viewModel.fetchMovies(isScrolled: true, word: text)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else {
            return UICollectionViewCell()
        }
        if let movie = data?[indexPath.item] {
            if let poster = movie.poster,
               let title = movie.title,
               let year = movie.year,
               let type = movie.type?.rawValue {
                cell.configureCell(posterImage: poster, titleLabel: title, yearLabel: year, typeLabel: type)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.toDetailVC(item: indexPath.item)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.navigationItem.hidesSearchBarWhenScrolling = true
    }
}
extension FeedViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.Margin.xLarge
    }
}

extension FeedViewController: UISearchBarDelegate, UISearchControllerDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.startLoadingAnimation()
        self.viewModel.fetchMovies(isScrolled: false, word: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.cleanMovies()
    }
}

extension FeedViewController: FeedViewInterface {
    func toDetailVC(item: Int) {
        let detailViewController = DetailViewController()
        detailViewController.id = viewModel.movies[item].imdbID
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func errorView(error: String) {
        DispatchQueue.main.async {
            self.reloadCollectionView()
            self.errorLabel.text = error
        }
    }
    
    func startLoadingAnimation() {
        DispatchQueue.main.async {
            self.loadingIndicator.isHidden = false
            self.loadingIndicator.startAnimating()
        }
    }
    
    func stopLoadingAnimation() {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
        }
    }
    func updateData(data: [Search]) {
        DispatchQueue.main.async {
            self.errorLabel.text = ""
            self.data = data
            self.reloadCollectionView()
        }
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.moviesCollectionView.reloadData()
        }
    }
}
