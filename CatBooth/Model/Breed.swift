//
//  Breed.swift
//  CatBooth
//
//  Created by cr3w on 21.05.2020.
//  Copyright © 2020 Dmitriy Holovnia. All rights reserved.
//

import Foundation

struct Breed: Decodable {
    let id: String
    let name: String
    let weight: Weight
    let temperament: String
    let origin: String
    let description: String
    let life_span: String
    let wikipedia_url: String?
}


