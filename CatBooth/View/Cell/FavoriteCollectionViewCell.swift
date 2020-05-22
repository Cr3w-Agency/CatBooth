//
//  FavoriteCollectionViewCell.swift
//  CatBooth
//
//  Created by cr3w on 22.05.2020.
//  Copyright © 2020 Dmitriy Holovnia. All rights reserved.
//

import UIKit

class FavoriteCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "FavoriteCollectionViewCell"
    
    private var id: Int?
    private let imageView = UIImageView()
    
    weak var viewModel: FavoriteCellViewModelProtocol? {
        willSet(viewModel) {
            imageView.image = viewModel?.imageItem.image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    private func configureCell() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
