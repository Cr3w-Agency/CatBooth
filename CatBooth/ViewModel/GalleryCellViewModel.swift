//
//  GalleryCellViewModell.swift
//  CatBooth
//
//  Created by cr3w on 21.05.2020.
//  Copyright © 2020 Dmitriy Holovnia. All rights reserved.
//

import UIKit

protocol GalleryCellViewModellProtocol: class {
    var image: UIImage { get }
    var imageId: String? { get }

}

class GalleryCellViewModell: GalleryCellViewModellProtocol {
    
    var image: UIImage
    var imageId: String?
    
    init(image: UIImage, imageId: String) {
        self.image = image
        self.imageId = imageId
    }
}
