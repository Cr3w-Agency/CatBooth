//
//  ImageView + Extension.swift
//  CatBooth
//
//  Created by cr3w on 21.05.2020.
//  Copyright © 2020 Dmitriy Holovnia. All rights reserved.
//

import UIKit

fileprivate let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func setImage(urlSting: String) {
        guard let url = URL(string: urlSting) else { return }
        image = nil
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            self.image = cachedImage
            return
        }
        URLSession.shared.dataTask(with: url) { (result) in
            switch result {
            case .success(let response, let data):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                    200..<299 ~= statusCode, let image = UIImage(data: data) else {
                    return
                }
                imageCache.setObject(image, forKey: url.absoluteString as NSString)
                DispatchQueue.main.async { [weak self] in
                    self?.image = image
                }
                
            case .failure(_):
                print("ErOrR")
            }
        } .resume()
    }
}
