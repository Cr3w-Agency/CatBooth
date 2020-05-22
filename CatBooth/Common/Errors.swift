//
//  Errors.swift
//  CatBooth
//
//  Created by cr3w on 21.05.2020.
//  Copyright © 2020 Dmitriy Holovnia. All rights reserved.
//

import Foundation

enum ServiceError: Error {
    case apiError
    case invalidURL
    case invalidResponse
    case dataError
    case decodeError
}
