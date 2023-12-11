//
//  FeedViewModel.swift
//  CinemaniaApp
//
//  Created by Toygun Çil on 10.12.2023.
//

import Foundation

protocol FeedViewModelInterface {
    func fetchSearchMovies(isScrolled: Bool, word: String, year: String?, type: String?)
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
    
    func fetchSearchMovies(isScrolled: Bool, word: String, year: String?, type: String?) {
        
        if !isFetched,
           self.page == 1 {
            self.movies.removeAll()
        }
        
        if word.count >= 2 {
            networkManager?.makeSearchQuery(page: page, word: word, year: year, type: type, completion: { [weak self] result in
                guard let self = self else {return}
                switch result {
                case .success(let success):
                    if let result = success.search {
                        self.movies.append(contentsOf: result)
                        if isScrolled {
                            self.page += 1
                            self.isFetched = true
                        }
                        self.view?.reloadCollectionView()
                    }
                    print(success)
                case .failure(let failure):
                    print(failure)
                }
            })
        }
    }
}
