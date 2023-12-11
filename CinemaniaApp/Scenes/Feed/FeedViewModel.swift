//
//  FeedViewModel.swift
//  CinemaniaApp
//
//  Created by Toygun Çil on 10.12.2023.
//

import Foundation

protocol FeedViewModelInterface {
    func fetchSearchMovies(isScrolled: Bool, word: String)
    func cleanMovies()
    var movies: [Search] { get set }
}

final class FeedViewModel {
    private weak var view: FeedViewInterface?
    private var networkManager: (SearchQueryMakeable)?
    
    var movies: [Search] = []
    var page: Int = 1
    var isFetched: Bool = false
    
    init(view: FeedViewInterface,networkManager: SearchQueryMakeable) {
        self.networkManager = networkManager
        self.view = view
    }
}

extension FeedViewModel: FeedViewModelInterface {
    
    func cleanMovies() {
        self.page = 1
        self.movies = []
        self.isFetched = false
        self.view?.updateData(data: movies)
    }
    
    func fetchSearchMovies(isScrolled: Bool, word: String) {
        
        if self.page > 1 {
            if !isScrolled {
                self.page = 1
                self.isFetched = false
            } else {
                self.isFetched = true
            }
        }
        
        if !isFetched,
           self.page == 1 {
            self.movies = []
        }
        
        if word.count >= 2 {
            networkManager?.makeSearchQuery(page: page, word: word, completion: { [weak self] result in
                guard let self = self else {return}
                switch result {
                case .success(let success):
                    if let result = success.search {
                        self.movies.append(contentsOf: result)
                        self.page += 1
                        self.view?.updateData(data: movies)
//                        self.view?.reloadCollectionView()
                    }
                    print("************ aldığı \(word) ****************")
                    print("\(word) için denememm ->>>>>>>>> \(success)")
                case .failure(let failure):
                    print(failure)
                }
            })
        } else {
            self.movies = []
            self.view?.updateData(data: movies)
            self.view?.reloadCollectionView()
        }
    }
}
