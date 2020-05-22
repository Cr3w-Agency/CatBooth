//
//  FavoriteItem.swift
//  CatBooth
//
//  Created by cr3w on 22.05.2020.
//  Copyright © 2020 Dmitriy Holovnia. All rights reserved.
//

import Foundation

struct FavoriteItem: Decodable {
    let id: Int
    let image: ItemImage
}

struct ItemImage: Decodable {
    let id: String
    let url: String
}
