//
//  DetailViewModel.swift
//  CinemaniaApp
//
//  Created by Toygun Çil on 10.12.2023.
//

import Foundation


protocol DetailViewModelInterface {
    func fetchDetailMoviesUseTitle(title: String?)
    func fetchDetailMoviesUseId(id: String?)
    var data: TitleQueryResponse? { get set }
}

final class DetailViewModel {
    
    private weak var view: DetailViewInterface?
    private var networkManager: (IdAndTitleQueryMakeable)?
    
    var data: TitleQueryResponse?
    
    init(view: DetailViewInterface, networkManager: IdAndTitleQueryMakeable) {
        self.networkManager = networkManager
        self.view = view
    }
}

extension DetailViewModel: DetailViewModelInterface {
    
    func fetchDetailMoviesUseTitle(title: String?) {
        if let title {
            networkManager?.makeQueryWithTitle(title: title, completion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let success):
                    self.data = success
                    self.view?.updateData(data: success)
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
                    self.data = success
                    self.view?.updateData(data: success)
                    print(success)
                case .failure(let failure):
                    print(failure)
                }
            })
        }
    }
    

}
