//
//  DetailViewModel.swift
//  CinemaniaApp
//
//  Created by Toygun Çil on 10.12.2023.
//

import Foundation


protocol DetailViewModelMakeable {
    func fetchDetailMoviesUseTitle(title: String?)
    func fetchDetailMoviesUseId(id: String?)
}

final class DetailViewModel {
    
    var networkManager: (IdAndTitleQueryMakeable)?
    
    init(networkManager: IdAndTitleQueryMakeable) {
        self.networkManager = networkManager
    }
}

extension DetailViewModel: DetailViewModelMakeable {
    func fetchDetailMoviesUseTitle(title: String?) {
        if let title {
            networkManager?.makeQueryWithTitle(title: title, completion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let success):
                    print(success)
                case .failure(let failure):
                    print(failure)
                }
            })
        }
    }
    
    func fetchDetailMoviesUseId(id: String?) {
        if let id {
            networkManager?.makeQueryWithID(id: id, completion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let success):
                    print(success)
                case .failure(let failure):
                    print(failure)
                }
            })
        }
    }
    

}
