//
//  BreedTableViewCell.swift
//  CatBooth
//
//  Created by cr3w on 21.05.2020.
//  Copyright © 2020 Dmitriy Holovnia. All rights reserved.
//

import UIKit

class BreedTableViewCell: UITableViewCell {
    
    static let reuseId = "BreedTableViewCell"
    
    private let titleLable = UILabel()
    private let catImageView = UIImageView()
    
    private var neWimageUrl: String? {
        didSet {
            downloadImage(url: neWimageUrl)
        }
    }
    
    weak var viewModel: BreedCellViewModelProtocol! {
        willSet(viewModel) {
            titleLable.text = viewModel?.cat.breed?.name
            guard let imageUrl = viewModel?.cat.imageUrl else {
                return
            }
            neWimageUrl = imageUrl
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    func setupUI() {
        
        accessoryType = .disclosureIndicator
        catImageView.contentMode = .scaleAspectFit
        
        addSubview(catImageView)
        addSubview(titleLable)
        
        catImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            catImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            catImageView.topAnchor.constraint(equalTo: self.topAnchor),
            catImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            catImageView.widthAnchor.constraint(equalToConstant: 80),
            
            titleLable.leadingAnchor.constraint(equalTo: catImageView.trailingAnchor, constant: 10),
            titleLable.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    private func downloadImage(url: String?) {
        if catImageView.image == nil {
            guard let imageUrl = url else { return }
            catImageView.setImage(urlSting: imageUrl)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
