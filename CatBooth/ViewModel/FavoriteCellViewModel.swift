//
//  FavoriteCellViewModel.swift
//  CatBooth
//
//  Created by cr3w on 22.05.2020.
//  Copyright © 2020 Dmitriy Holovnia. All rights reserved.
//

import UIKit

protocol FavoriteCellViewModelProtocol: class {
        var imageItem: FavoriteImage { get }
}

class FavoriteCellViewModel: FavoriteCellViewModelProtocol {
    var imageItem: FavoriteImage
    
    init(imageItem: FavoriteImage) {
        self.imageItem = imageItem
    }
    
}
