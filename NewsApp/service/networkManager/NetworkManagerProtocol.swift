//
//  NetworkManagerProtocol.swift
//  NewsApp
//
//  Created by Eslam gamal on 31/07/2023.
//

import Foundation
protocol NetworkManagerProtocol{
    func getApiData<T: Decodable>(url: String, completionHandler: @escaping (Result<T, Error>) -> Void)
}
