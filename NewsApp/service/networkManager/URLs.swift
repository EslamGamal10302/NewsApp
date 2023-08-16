//
//  URLs.swift
//  NewsApp
//
//  Created by Eslam gamal on 30/07/2023.
//

import Foundation

struct URLs{
    static let shared = URLs()
    private init(){}
    let baseURL = "https://newsapi.org/v2/top-headlines?country=us&category="
    func dataURL(category:String) -> String{
        return baseURL + "\(category)&apiKey=\(K.API_KEY)"
    }
    func searchURL(searchText:String)-> String {
        return K.SEARCH_URL + "\(searchText)&sortBy=popularity&apiKey=\(K.API_KEY)"
    }
  
}
