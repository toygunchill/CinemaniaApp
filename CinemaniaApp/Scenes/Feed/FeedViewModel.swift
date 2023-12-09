//
//  FeedViewModel.swift
//  CinemaniaApp
//
//  Created by Toygun Çil on 10.12.2023.
//

import Foundation

protocol FeedViewModelMakeable {
    func fetchSearchMovies(page: String?, word: String, year: String?, type: String?)
}

final class FeedViewModel {
    
    var networkManager: (SearchQueryMakeable)?
    
    init(networkManager: SearchQueryMakeable) {
        self.networkManager = networkManager
    }
}

extension FeedViewModel: FeedViewModelMakeable {
    func fetchSearchMovies(page: String?, word: String, year: String?, type: String?) {
        networkManager?.makeSearchQuery(word: word, year: year, type: type, completion: { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(failure)
            }
        })
    }
}
