//
//  DetailViewModel.swift
//  CinemaniaApp
//
//  Created by Toygun Çil on 10.12.2023.
//

import Foundation


protocol DetailViewModelInterface {
    func fetchDetailMoviesUseId(id: String?)
    var data: TitleQueryResponse? { get set }
}

final class DetailViewModel {
    
    private weak var view: DetailViewInterface?
    private var networkManager: (IdQueryMakeable)?
    
    var data: TitleQueryResponse?
    
    init(view: DetailViewInterface, networkManager: IdQueryMakeable) {
        self.networkManager = networkManager
        self.view = view
    }
}

extension DetailViewModel: DetailViewModelInterface {
    
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
