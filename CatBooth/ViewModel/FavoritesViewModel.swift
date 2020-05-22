//
//  FavoritesViewModel.swift
//  CatBooth
//
//  Created by cr3w on 22.05.2020.
//  Copyright © 2020 Dmitriy Holovnia. All rights reserved.
//

import UIKit

protocol FavoritesViewModelProtocol: class {
    var updateViewData: ((Process) ->())? { get set }
    var images: [FavoriteImage] { get }
    
    func startFetch()
    func numberOfItems() -> Int
    func viewModelForCell(indexPath: IndexPath) -> FavoriteCellViewModelProtocol
    func sizeForItem(collectionView: UICollectionView, indexPath: IndexPath) -> CGSize
    func imageItem(indexPath: IndexPath) -> FavoriteImage
    func minimumLineSpacing() -> CGFloat
}

class FavoritesViewModel: FavoritesViewModelProtocol {
    var updateViewData: ((Process) -> ())?
    var images: [FavoriteImage] = []
    
    init() {
        updateViewData?(.initial)
        startFetch()
    }
    
    func startFetch() {
        updateViewData?(.loading)
        NetworkManager.shared.fetchWithParam(url: ApiConstants.favorites, apiKey: ApiConstants.api, parameters: nil) { (result: Result<[FavoriteItem], ServiceError>) in
            switch result {
            case .success(let items):
                self.downloadItems(items)
            case .failure(let error):
                self.updateViewData?(.failure(error.localizedDescription))
            }
        }
    }
    
    private func downloadItems(_ items: [FavoriteItem]) {
        let queue = DispatchQueue(label: "Download data", attributes: .concurrent)
        let group = DispatchGroup()
        
        for item in items {
            group.enter()
            queue.async(group: group) { [weak self] in
                guard let self = self else { return }
                NetworkManager.shared.downloadImage(url: item.image.url) { [weak self] (result: Result<UIImage, ServiceError>) in
                    guard let self = self else { return }
                    switch result {
                    case .success(let image):
                        let newItem = FavoriteImage(id: item.id, image: image)
                        self.images.append(newItem)
                        group.leave()
                    case .failure(let error):
                        self.updateViewData?(.failure(error.localizedDescription))
                        group.leave()
                    }
                }
            }
        }
        group.notify(queue: .main) { [weak self] in
            self?.updateViewData?(.success)
        }
    }
    
    func numberOfItems() -> Int {
        return images.count
    }

    func viewModelForCell(indexPath: IndexPath) -> FavoriteCellViewModelProtocol {
        let favoriteImage = images[indexPath.row]
        let cellViewModel = FavoriteCellViewModel(imageItem: favoriteImage)
        return cellViewModel
    }

    func sizeForItem(collectionView: UICollectionView, indexPath: IndexPath) -> CGSize {
        let imageSize = images[indexPath.row].image.size
        let viewWidth = collectionView.frame.width - 20
        let itemHeight = imageSize.height * viewWidth / imageSize.width
        let itemSize = CGSize(width: viewWidth, height: itemHeight)
        return itemSize
    }
    
    func imageItem(indexPath: IndexPath) -> FavoriteImage {
        let item = images[indexPath.row]
        return item
    }
    
    func minimumLineSpacing() -> CGFloat {
        return 10
    }

}
