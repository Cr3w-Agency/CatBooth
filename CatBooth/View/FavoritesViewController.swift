//
//  FavoritesViewController.swift
//  CatBooth
//
//  Created by cr3w on 22.05.2020.
//  Copyright © 2020 Dmitriy Holovnia. All rights reserved.
//

import UIKit

class FavoritesViewController: UICollectionViewController {
    
    var viewModel: FavoritesViewModelProtocol!
    
    private let infoLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = FavoritesViewModel()
        updateView()
        setupUI()
    }
    
    private func updateView() {
        viewModel.updateViewData = { [weak self] stage in
            guard let self = self else { return }
            switch stage {
            case .initial:
                print("init FCC")
            case .loading:
                print("loading")
            case .success:
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupUI() {
        view.addSubview(infoLabel)
        
        infoLabel.text = "There are not images :("
        infoLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        infoLabel.center = view.center
        
        title = "Favorite images"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        collectionView.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteCollectionViewCell.reuseId)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        infoLabel.isHidden = viewModel.numberOfItems() == 0 ? false : true
        return viewModel.numberOfItems()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.reuseId, for: indexPath) as! FavoriteCollectionViewCell
        let cellViewModel = viewModel.viewModelForCell(indexPath: indexPath)
        cell.viewModel = cellViewModel
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.imageItem(indexPath: indexPath)
        let dvc = ImageReviewViewController(image: item.image, id: String(item.id), addImage: false)
        present(dvc, animated: true)
    }
}

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.sizeForItem(collectionView: collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.minimumLineSpacing()
    }
}
