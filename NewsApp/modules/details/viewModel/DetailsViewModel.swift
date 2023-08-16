//
//  DetailsViewModel.swift
//  NewsApp
//
//  Created by Eslam gamal on 31/07/2023.
//

import Foundation
class DetailsViewModel {
    var articleData:Article?
    var databaseManager:RealmServiceProtocol?
    var favoritesArticlesArray = [FavoriteArticle]()
    init(articleData: Article,databaseManager:RealmServiceProtocol) {
        self.articleData = articleData
        self.databaseManager = databaseManager
        getAllFAvoritesArticles()
    }
    func getArticleData()-> Article{
        return articleData ?? Article()
    }
    func getAllFAvoritesArticles(){
        databaseManager?.getAllArticles(ofType: FavoriteArticle.self) { error, results in
            if let error = error {
                print("Error : \(error)")
            } else {
                if let results = results {
                    if results.count > 0{
                        self.favoritesArticlesArray = Array(results)
                        
                    }
                    
                }
            }
        }
    }
    func isFavorite(title:String)->Bool{
        return  favoritesArticlesArray.contains(where: { $0.title == title })
    }
    func addToFavorite(article:FavoriteArticle){
        databaseManager?.addArticle(article: article, completionHandler: { error in
            if error == nil {
                print("Product added successfully in view")
            }
            
        })
    }
    func deleteArticleFromFAvorite(title:String){
        databaseManager?.deleteSingleArticle(ofType: FavoriteArticle.self, title: title, completionHandler: { error in
            if error == nil {
                print("Product deleted successfully in view")
            }
        })
    }
}
