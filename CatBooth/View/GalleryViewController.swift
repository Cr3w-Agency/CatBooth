//
//  GalleryViewController.swift
//  CatBooth
//
//  Created by cr3w on 21.05.2020.
//  Copyright © 2020 Dmitriy Holovnia. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {
    
    private var viewModel: GalleryViewModelProtocol!
    private var collectionView: UICollectionView!
    private var cats: [Cat] = []
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        viewModel = GalleryViewModel()
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
    }
    
    private func setupNavigationBar() {
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .done, target: self, action: #selector(buttonPressed))
        //MARK: TO DO
        title = viewModel.title
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupUI() {
        setupCollectionView()
        updateView()
        activityIndicator.startAnimating()
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
    }
    
    private func setupCollectionView() {
        collectionView = viewModel.setupCollectionView()
        collectionView.frame = view.bounds
        collectionView.dataSource = self
        collectionView.delegate = self
        let customLayout = GalleryLayout()
        customLayout.delegate = self
        collectionView.collectionViewLayout = customLayout
        view.addSubview(collectionView)
    }
    
    private func updateView() {
        viewModel.updateViewData = { stage in
            switch stage {
            case .initial:
                print("init")
            case .loading:
                DispatchQueue.main.async { [weak self] in
                    self?.activityIndicator.startAnimating()
                }
            case .success:
                DispatchQueue.main.async { [weak self] in
                    self?.collectionView.reloadData()
                    self?.activityIndicator.stopAnimating()
                }
                print("loaded")
            case .failure(_):
                print("init")
            }
        }
    }
}
//MARK: UICollectionViewDataSource
extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.reuseId, for: indexPath) as! GalleryCollectionViewCell
        let cellViewModel = viewModel.cellViewModel(indexPath: indexPath)
        cell.viewModel = cellViewModel
        return cell
    }
    
}
//MARK: UICollectionViewDelegate
extension GalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let id = viewModel.idForCell(at: indexPath) else { return }
        let image = viewModel.imageForCell(at: indexPath)
        let dvc = ImageReviewViewController(image: image, id: id, addImage: true)
        present(dvc, animated: true, completion: nil)
    }
}

//MARK: GalleryLayoutDelegate
extension GalleryViewController: GalleryLayoutDelegate {
    func sizeForItem(in collectionView: UICollectionView, of indexPath: IndexPath) -> CGSize {
        guard let imageSize = viewModel.catsData[indexPath.row].image?.size else {
            return CGSize.zero
        }
        return imageSize
    }
}



