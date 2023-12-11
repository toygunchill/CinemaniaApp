//
//  DetailViewController.swift
//  CinemaniaApp
//
//  Created by Toygun Çil on 10.12.2023.
//

import UIKit

protocol DetailViewInterface: AnyObject {
    var id: String? {get set}
    func updateData(data: TitleQueryResponse)
}

class DetailViewController: UIViewController {
    
    private lazy var viewModel = DetailViewModel(view: self, networkManager: NetworkManager.shared)
    var id: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.fetchDetailMoviesUseId(id: id)
    }

}

extension DetailViewController: DetailViewInterface {
    func updateData(data: TitleQueryResponse) {
        //data burada yerleştirilecek
    }
}
