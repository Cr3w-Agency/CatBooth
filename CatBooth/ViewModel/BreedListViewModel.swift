//
//  BreedListViewModel.swift
//  CatBooth
//
//  Created by cr3w on 21.05.2020.
//  Copyright © 2020 Dmitriy Holovnia. All rights reserved.
//

import UIKit

protocol BreedListViewModelProtocol: class {
    var updateViewData: ((Process) ->())? { get set }
//    var cats: [Cat] { get }
    
    func startFetch()
    func numberOfRows() -> Int
    func cellViewModel(at indexPath: IndexPath) -> BreedCellViewModelProtocol
}

class BreedListViewModel: BreedListViewModelProtocol {
    
    var updateViewData: ((Process) -> ())?

    var cats: [Cat] = []
    private var unfilteredArray: [Cat] = []
    
    init() {
        updateViewData?(.initial)
        startFetch()
    }
    
    func startFetch() {
        NetworkManager.shared.fetchWithParam(url: ApiConstants.breeds, apiKey: nil, parameters: nil) { [weak self] (result: Result<[Breed], ServiceError>) in
            guard let self = self else { return }
            switch result {
            case .success(let breeds):
                self.downloadCatData(breeds: breeds)
            case .failure(let error):
                self.updateViewData?(.failure(error.localizedDescription))
            }
        }
    }
    
    func downloadCatData(breeds: [Breed]) {
        let queue = DispatchQueue(label: "Download data", attributes: .concurrent)
        let group = DispatchGroup()
        
        for breed in breeds {
            group.enter()
            queue.async(group: group) {
                
                let parameters = ["breed_id": breed.id]
                NetworkManager.shared.fetchWithParam(url: ApiConstants.search, apiKey: nil, parameters: parameters) {
                    [weak self] (result: Result<[CatData], ServiceError>) in
                    guard let self = self else { return }
                    switch result {
                    case .success(let cats):
                        for cat in cats {
                            guard let newCat = Cat(catdata: cat) else { return }
                            self.unfilteredArray.append(newCat)
                            group.leave()
                        }
                    case .failure(let error):
                        self.updateViewData?(.failure(error.localizedDescription))
                    }
                }
            }
            
            group.notify(queue: .main) { [weak self] in
                self?.cats = (self?.unfilteredArray.sorted(by: { $0.breed!.name < $1.breed!.name }))!
                self?.updateViewData?(.success)
            }
        }
    }
    
    func numberOfRows() -> Int {
        return cats.count
    }
    
    func cellViewModel(at indexPath: IndexPath) -> BreedCellViewModelProtocol {
        let cat = cats[indexPath.row]
        return BreedCellViewModel(cat: cat)
    }

}



