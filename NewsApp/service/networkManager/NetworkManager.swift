//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Eslam gamal on 31/07/2023.
//

import Foundation
import Alamofire
class NetworkManager:NetworkManagerProtocol{
    static let shared = NetworkManager()
    private init() {}
    func getApiData<T: Decodable>(url: String, completionHandler: @escaping (Result<T, Error>) -> Void) {
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response { response in
            switch response.result {
            case .success(let data):
                do {
                    let jsonData = try JSONDecoder().decode(T.self, from: data!)
                    completionHandler(.success(jsonData))
                } catch {
                    completionHandler(.failure(error))
                   
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
}
