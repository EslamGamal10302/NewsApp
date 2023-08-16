//
//  MocNetworkService.swift
//  NewsApp
//
//  Created by Eslam gamal on 01/08/2023.
//

import Foundation
@testable import NewsApp

class MockNetworkService {
    var shouldReturnError:Bool
    init(shouldReturnError: Bool) {
        self.shouldReturnError = shouldReturnError
    }
    enum ResponseWithError : Error {
        case responseError
    }
}

extension MockNetworkService:NetworkManagerProtocol {
    func getApiData<T>(url: String, completionHandler: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        if shouldReturnError {
            completionHandler(.failure(ResponseWithError.responseError))
        }else{
            do{
                let result = try JSONDecoder().decode(T.self, from: ApiJsonResponse.NewsResponse.data(using: .utf8)!)
                completionHandler(.success(result))
            }catch {
                completionHandler(.failure(ResponseWithError.responseError))
            }
        }
    }
}
