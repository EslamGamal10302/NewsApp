//
//  FavoriteViewModel.swift
//  NewsApp
//
//  Created by Eslam gamal on 01/08/2023.
//

import Foundation
class FavoriteViewModel{
    let databaseManager:RealmServiceProtocol?
    var articles:Observable<Bool>=Observable(false)
    var favoritesArticlesArray = [FavoriteArticle]()
    init(databaseManager: RealmServiceProtocol?) {
        self.databaseManager = databaseManager
    }
    func getAllFavorites(){
        databaseManager?.getAllArticles(ofType: FavoriteArticle.self) { error, results in
            if let error = error {
                print("Error : \(error)")
            } else {
                if let results = results {
                    if results.count >= 0{
                        self.favoritesArticlesArray = Array(results)
                        self.articles.value = true
                        print(self.favoritesArticlesArray.count)
                    }
                    
                }
            }
        }
    }
    func removeFromFavorites(title:String){
        databaseManager?.deleteSingleArticle(ofType: FavoriteArticle.self, title: title, completionHandler: { error in
            if error == nil {
                self.getAllFavorites()
            }
        })
    }
    func getArticlesCount()->Int{
        return favoritesArticlesArray.count
    }
    func getArticleData(index:Int)->Article{
        return favoritesArticlesArray[index].generateArticleModelObject()
    }
    func navigationConfigure(for rowIndex:Int)->DetailsViewModel{
        return DetailsViewModel(articleData: favoritesArticlesArray[rowIndex].generateArticleModelObject(), databaseManager: RealmDatabaseService.instance)
    }
}
