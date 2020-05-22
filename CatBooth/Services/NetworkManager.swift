//
//  NetworkManager.swift
//  CatBooth
//
//  Created by cr3w on 21.05.2020.
//  Copyright © 2020 Dmitriy Holovnia. All rights reserved.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let imageCache = NSCache<NSString, UIImage>()
    private let session = URLSession.shared
    private let jsonDecoder = JSONDecoder()
    
    //MARK:  - Detch data
    func fetchRequest<T: Decodable>(url: String, completion: @escaping (Result<[T], ServiceError>) -> ()) {
        guard let url = URLComponents(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        guard let requestUrl = url.url else {
            completion(.failure(.invalidURL))
            return
        }
        session.dataTask(with: requestUrl) { (result) in
            switch result {
            case .success(let response, let data):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                    200..<299 ~= statusCode else {
                        completion(.failure(.invalidResponse))
                        return
                }
                do {
                    let values = try self.jsonDecoder.decode([T].self, from: data)
                    completion(.success(values))
                } catch {
                    completion(.failure(.decodeError))
                }
            case .failure(_):
                completion(.failure(.apiError))
            }
        }.resume()
    }
    //MARK: Download image
    func downloadImage(url: String, completion: @escaping (Result<UIImage, ServiceError>) -> ()) {
        guard let url = URL(string: url) else { return }
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(.success(cachedImage))
            print("cached")
            return
        }
        session.dataTask(with: url) { (result) in
            switch result {
            case .success(let response, let data):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                    200..<299 ~= statusCode else {
                        completion(.failure(.invalidResponse))
                        return
                }
                guard let image = UIImage(data: data) else {
                    completion(.failure(.dataError))
                    return
                }
                self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                completion(.success(image))
                
            case .failure(_):
                (completion(.failure(.apiError)))
            }
        } .resume()
        
    }
    //MARK: Download data
    func downloadData(url: String, completion: @escaping (Result<Data, ServiceError>) -> ()) {
        guard let url = URL(string: url) else { return }
        
        session.dataTask(with: url) { (result) in
            switch result {
            case .success(let response, let data):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                    200..<299 ~= statusCode else {
                        completion(.failure(.invalidResponse))
                        return
                }
                completion(.success(data))
                
            case .failure(_):
                (completion(.failure(.apiError)))
            }
        } .resume()
    }
    //MARK:  - Fetch with api or parameters
    func fetchWithParam<T: Decodable>(url: String,
                                      apiKey: String?,
                                      parameters: [String: String]?,
                                      completion: @escaping (Result<[T], ServiceError>) -> ()) {
        guard var URL = URLComponents(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var queryItems: [URLQueryItem] = []
        
        if parameters != nil {
            for parameter in parameters! {
                let queryItem = URLQueryItem(name: parameter.key, value: parameter.value)
                queryItems.append(queryItem)
            }
        }
        
        URL.queryItems = queryItems
        
        guard let urlRequest = URL.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: urlRequest)
        
        if apiKey != nil {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(apiKey!, forHTTPHeaderField: "x-api-key")
        }
        session.dataTaskRequest(with: request) { (result) in
            switch result {
            case .success(let response, let data):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                    200..<299 ~= statusCode else {
                        completion(.failure(.invalidResponse))
                        print(123)
                        return
                }
                do {
                    let values = try self.jsonDecoder.decode([T].self, from: data)
                    completion(.success(values))
                } catch {
                    completion(.failure(.decodeError))
                }
            case .failure(_):
                completion(.failure(.apiError))
            }
        }.resume()
    }
    //MARK:  - Delete request
    func deleteImage(imageId: String) {
        
        guard let url = URL(string: ApiConstants.favorites + imageId) else { return }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "DELETE"
        request.addValue(ApiConstants.api, forHTTPHeaderField: "x-api-key")
        
        session.dataTask(with: request) { (_, response, error) in
            if let statusCode = (response as? HTTPURLResponse)?.statusCode,
                200..<299 ~= statusCode  {
                    print("Deleted")
                    return
            }
            
            if let error = error {
                print(error.localizedDescription)
            }
        }.resume()
    }
    //MARK:  Add to favorite request
    func addToFavorite(id: String) {
        guard let url = URL(string: ApiConstants.favorites) else { return }
        
        var request = URLRequest(url: url)

        request.httpMethod = "POST"

        request.addValue(ApiConstants.api, forHTTPHeaderField: "x-api-key")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let bodyObject: [String : String] = ["image_id": id]
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: bodyObject, options: [])
        
        session.dataTask(with: request) { (_, response, error) in
            if let statusCode = (response as? HTTPURLResponse)?.statusCode,
                200..<299 ~= statusCode  {
                    print("Added")
                    print(statusCode)
                    return
            }
            print("Ok")
            if let error = error {
                print(error.localizedDescription)
            }
        }.resume()

    }

}
