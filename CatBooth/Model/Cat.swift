//
//  Cat.swift
//  CatBooth
//
//  Created by cr3w on 21.05.2020.
//  Copyright © 2020 Dmitriy Holovnia. All rights reserved.
//

import UIKit

class Cat: CustomStringConvertible, Comparable {

    var id: String?
    var image: UIImage?
    var imageUrl: String?
    var breed: Breed?
    var description: String { return breed!.name }
    
    init(id: String, image: UIImage) {
        self.id = id
        self.image = image
        self.breed = nil
    }
    
    init?(breed: Breed) {
        self.breed = breed
        
        self.id = nil
        self.image = nil
    }
    
    init?(catdata: CatData) {
        self.id = catdata.id
        self.breed = catdata.breeds?[0]
        self.imageUrl = catdata.url
    }
    
    static func == (lhs: Cat, rhs: Cat) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Cat, rhs: Cat) -> Bool {
        return lhs.breed!.name < rhs.breed!.name
    }
}
