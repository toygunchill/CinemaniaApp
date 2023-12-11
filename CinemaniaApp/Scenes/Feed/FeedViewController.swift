//
//  SecondViewController.swift
//  CinemaniaApp
//
//  Created by Toygun Çil on 7.12.2023.
//

import UIKit

protocol FeedViewInterface: AnyObject {
    func reloadCollectionView()
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
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let width = UIScreen.main.bounds.width
        let itemWidth = (width - 44)
        layout.itemSize = CGSize(width: itemWidth, height: 140)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
        return collectionView
    }()
    
    private var page: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesSearchBarWhenScrolling = false
        view.backgroundColor = .white
        view.addSubview(moviesCollectionView)
        view.addSubview(navigationView)
        view.addSubview(errorLabel)
        setupSearchController()
        setUpConstrains()
        setUpNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNavigation()
    }
    
    func setUpNavigation(){
        title = "Cinemania🍿"
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.hidesBackButton = true
    }
    
    func setUpConstrains() {
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        moviesCollectionView.isScrollEnabled = true
        moviesCollectionView.showsVerticalScrollIndicator = false
        NSLayoutConstraint.activate([
            navigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationView.topAnchor.constraint(equalTo: view.topAnchor, constant: -(Constants.Window.getTopPadding + 91)),
            navigationView.heightAnchor.constraint(equalToConstant: Constants.Window.getTopPadding + 91),
            moviesCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            moviesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            moviesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            moviesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setupSearchController() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.tintColor = .black
        searchController.searchBar.searchTextField.backgroundColor = .white
        searchController.searchBar.clipsToBounds = true
        searchController.searchBar.frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        searchController.searchBar.searchTextField.leftView?.tintColor = .black
        searchController.searchBar.searchTextField.backgroundColor = .white
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            //textfield.font = AppFonts.infoRegularFont
        }
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
}

extension FeedViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == (viewModel.movies.count) - 3 {
            self.viewModel.fetchSearchMovies(isScrolled: true, word: "batman", year: "", type: "")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCell else {
            return UICollectionViewCell()
        }
        let data = viewModel.movies[indexPath.item]
        cell.configureCell(posterImage: data.poster ?? "", titleLabel: data.title ?? "", yearLabel: data.year ?? "", typeLabel: data.type?.rawValue ?? "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.id = viewModel.movies[indexPath.item].imdbID
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.navigationItem.hidesSearchBarWhenScrolling = true
    }
}
extension FeedViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

extension FeedViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //
    }
}

extension FeedViewController: UISearchBarDelegate, UISearchControllerDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.fetchSearchMovies(isScrolled: false, word: searchText, year: "", type: "")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //
    }
}

extension FeedViewController: FeedViewInterface {
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.moviesCollectionView.reloadData()
        }
    }
}
