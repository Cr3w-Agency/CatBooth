//
//  GalleryViewModel.swift
//  CatBooth
//
//  Created by cr3w on 21.05.2020.
//  Copyright © 2020 Dmitriy Holovnia. All rights reserved.
//

import UIKit

protocol GalleryViewModelProtocol: class {
    var title: String { get }
    var catsData: [Cat] { get set }
    var updateViewData: ((Process) ->())? { get set }
    
    func startFetch()
    func setupCollectionView() -> UICollectionView
    func numberOfRows() -> Int
    func cellViewModel(indexPath: IndexPath) -> GalleryCellViewModellProtocol
    func imageForCell(at indexPath: IndexPath) -> UIImage
    func idForCell(at indexPath: IndexPath) -> String? 
}

class GalleryViewModel: GalleryViewModelProtocol {
    
    var title: String = "Gallery"
    var catsData: [Cat] = []
    var updateViewData: ((Process) -> ())?
    
    
    init() {
        updateViewData?(.initial)
        startFetch()
    }
    
    func startFetch() {
        updateViewData?(.loading)
        let parameters: [String: String] = ["limit": "20", "category_ids": "5"]
        NetworkManager.shared.fetchWithParam(url: ApiConstants.search, apiKey: nil,
                                             parameters: parameters) {
            [weak self] (result: Result<[CatData], ServiceError>) in
            guard let self = self else { return }
                                                
            switch result {
            case .success(let cats):
                self.downloadCatData(cats)
            case .failure(let error):
                self.updateViewData?(.failure(error.localizedDescription))
            }
        }
    }
    
    private func downloadCatData(_ cats: [CatData]) {
        updateViewData?(.loading)

        let queue = DispatchQueue(label: "Download data", attributes: .concurrent)
        let group = DispatchGroup()
        
        for cat in cats {
            group.enter()
            queue.async(group: group) { [weak self] in
                NetworkManager.shared.downloadImage(url: cat.url) {
                    (result: Result<UIImage, ServiceError>) in
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let image):
                        let cat = Cat(id: cat.id, image: image)
                        self.catsData.append(cat)
                        group.leave()
                        
                    case .failure(let error):
                        self.updateViewData?(.failure(error.localizedDescription))
                        group.leave()
                    }
                }
            }
        }
        
        group.notify(queue: .global()) { [weak self] in
            self?.updateViewData?(.success)
        }
    }
    
    func setupCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .white
        collectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.reuseId)
        return collectionView
    }
    
    func numberOfRows() -> Int {
        return catsData.count
    }
    
    func cellViewModel(indexPath: IndexPath) -> GalleryCellViewModellProtocol {
        let catImage = catsData[indexPath.row].image ?? #imageLiteral(resourceName: "pet")
        return GalleryCellViewModell(image: catImage, imageId: "test")
    }
    
    func imageForCell(at indexPath: IndexPath) -> UIImage {
        let catImage = catsData[indexPath.row].image ?? #imageLiteral(resourceName: "pet")
        return catImage
    }
    
    func idForCell(at indexPath: IndexPath) -> String? {
        return catsData[indexPath.row].id
    }

}




