//
//  BreedCellViewModel.swift
//  CatBooth
//
//  Created by cr3w on 21.05.2020.
//  Copyright © 2020 Dmitriy Holovnia. All rights reserved.
//

import UIKit

protocol BreedCellViewModelProtocol: class {
    var cat: Cat { get }
}

class BreedCellViewModel: BreedCellViewModelProtocol {
    var cat: Cat
        
    init(cat: Cat) {
        self.cat = cat
    }
}
