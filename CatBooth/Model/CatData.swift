//
//  CatData.swift
//  CatBooth
//
//  Created by cr3w on 21.05.2020.
//  Copyright © 2020 Dmitriy Holovnia. All rights reserved.
//

import UIKit

struct CatData: Decodable {
    let id: String
    let url: String
    let breeds: [Breed]?
}
