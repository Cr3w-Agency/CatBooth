//
//  QuizViewModel.swift
//  CatBooth
//
//  Created by cr3w on 22.05.2020.
//  Copyright © 2020 Dmitriy Holovnia. All rights reserved.
//

import UIKit

protocol QuizViewModelProtocol: class {
    var updateViewData: ((Process) ->())? { get set }
    
    func fetchAsnwers()
    func getCats() -> [Cat]
    func playerRecord() -> Int
    func numberOfLifes() -> Int
}

class QuizViewModel: QuizViewModelProtocol {
    var updateViewData: ((Process) -> ())?
    var cats: [Cat] = []
    
    init() {
        updateViewData?(.initial)
        fetchAsnwers()
    }
        
    func fetchAsnwers() {
        cats = []
        updateViewData?(.loading)
        let parameters: [String: String] = ["limit": "4", "has_breeds": "1"]
        NetworkManager.shared.fetchWithParam(url: ApiConstants.search, apiKey: nil, parameters: parameters) {  [weak self] (result: Result<[CatData], ServiceError>) in
            guard let self = self else { return }
            switch result {
            case .success(let cats):
                if cats.count == 4 {
                    for cat in cats {
                        if cat.breeds?.isEmpty ?? false{
                            self.updateViewData?(.failure("Downloading error"))
                            return
                        }
                        guard let newCat = Cat(catdata: cat) else { return }
                        
                        self.cats.append(newCat)
                    }
                    self.downloadImage(url: self.cats[0].imageUrl)
                }
            case .failure(let error):
                self.updateViewData?(.failure(error.localizedDescription))
            }
        }
    }
    
    private func downloadImage(url: String?) {
        guard let imageUrl = url else {
            updateViewData?(.failure("Image url error"))
            return
        }
        NetworkManager.shared.downloadImage(url: imageUrl) { [weak self] (result: Result<UIImage, ServiceError>) in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                if self.cats.isEmpty {
                    self.updateViewData?(.failure("Array is empty"))
                    return
                }
                self.cats[0].image = image
                self.updateViewData?(.success)
            case .failure(let error):
                self.updateViewData?(.failure(error.localizedDescription))
            }
        }
    }
    
    func playerRecord() -> Int {
        let record = UserDefaults.standard.integer(forKey: "record")
        return record
    }
 
    
    func getCats() -> [Cat] {
        return cats
    }
    
    func numberOfLifes() -> Int {
        return 5
    }

}
