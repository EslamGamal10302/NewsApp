//
//  HomeViewModel.swift
//  NewsApp
//
//  Created by Eslam gamal on 30/07/2023.
//

import Foundation
import UIKit
class HomeViewModel{

    var articles:Observable<Bool>=Observable(false)
    var failureRequestStatus:Observable<Bool>=Observable(false)
    var categoryArticlesArray  = [Article]()
    var favoritesArticlesArray = [FavoriteArticle]()
    let url = URLs.shared
    var selectedCayegory = "general"
    var categoryItems:[Category]=[Category(title: "general", image: UIImage(named: K.ALL_IMAGE)!, isSelected: true),Category(title: "business", image: UIImage(named: K.BUSINESS_IMAGE)!, isSelected: false),Category(title: "health", image: UIImage(named: K.HEALTH_IMAGE)!, isSelected: false),Category(title: "science", image: UIImage(named: K.SCIENCE_IMAGE)!, isSelected: false),Category(title: "sports", image: UIImage(named: K.SPORTS_IMAGE)!, isSelected: false),Category(title: "technology", image: UIImage(named: K.TECHNOLOGY_IMAGE)!, isSelected: false)]
    let networkManager:NetworkManagerProtocol?
    let databaseManager:RealmServiceProtocol?
    var backupStatus = false
    init( networkManager: NetworkManagerProtocol?,databaseManager:RealmServiceProtocol?) {
        self.networkManager = networkManager
        self.databaseManager = databaseManager
    }
    
    func getArticlesData(category:String = "general"){
        networkManager?.getApiData(url: url.dataURL(category: category)) { [weak self] (result: Result<NewsResponse, Error>) in
                    switch result {
                    case .success(let articlesData):
                        self?.categoryArticlesArray = articlesData.articles ?? [Article]()
                        self?.articles.value = true
                        self?.storeArticlesForBackup()
                    case .failure(_):
                        self?.failureRequestStatus.value = true
                    }
                }
    }
    
    func searchForArticles(searchText:String){
        networkManager?.getApiData(url: url.searchURL(searchText: searchText)) { [weak self] (result: Result<NewsResponse, Error>) in
                    switch result {
                    case .success(let articlesData):
                        self?.categoryArticlesArray = articlesData.articles ?? [Article]()
                        self?.articles.value = true
                    case .failure(_):
                        self?.failureRequestStatus.value = true
                    }
                }
    }
    
    func prepareBackupData(){
        if !backupStatus{
            databaseManager?.deleteAllArticles(ofType: BackupArticle.self, completionHandler:  { error in
                if error == nil {
                    self.storeArticlesForBackup()
                    self.backupStatus = true
                }
                
            })
       
        }
    }
    
    func storeArticlesForBackup(){
        if !backupStatus{
            self.backupStatus = true
            categoryArticlesArray.forEach { article in
                let data = article.generateBackupObject()
                databaseManager?.addArticle(article: data, completionHandler: { error in
                    if error == nil {
                        print("Product added successfully in view")
                    }
                    
                })
            }
        }
    }
    
    func getAllFAvoritesArticles(){
        databaseManager?.getAllArticles(ofType: FavoriteArticle.self) { error, results in
            if let error = error {
                print("Error : \(error)")
            } else {
                if let results = results {
                    if results.count >= 0{
                        self.favoritesArticlesArray = Array(results)
                        
                    }
                    
                }
            }
        }
    }
    
    func addToFavorite(article:FavoriteArticle){
        databaseManager?.addArticle(article: article, completionHandler: { error in
            if error == nil {
                self.getAllFAvoritesArticles()
            }
            
        })
    }
    
    func deleteArticleFromFAvorite(title:String){
        databaseManager?.deleteSingleArticle(ofType: FavoriteArticle.self, title: title, completionHandler: { error in
            if error == nil {
                self.getAllFAvoritesArticles()
            }
        })
    }
    
    func getBackupData(){
        databaseManager?.getAllArticles(ofType: BackupArticle.self) { error, results in
               if let error = error {
                   print("Error : \(error)")
               } else {
                   if let results = results {
                       if results.count >= 0{
                           self.prepareBackupDataToDisplay(data: Array(results))
                       }
                       
                   }
               }
              
           }
    }
    func prepareBackupDataToDisplay(data:[BackupArticle]){
        var articles = [Article]()
        data.forEach { backupArticle in
            let articleData = backupArticle.generateArticleModelObject()
            articles.append(articleData)
        }
        self.categoryArticlesArray = articles
        self.articles.value = true
    }
    
    
    
    
    func isFavorite(title:String)->Bool{
        return  favoritesArticlesArray.contains(where: { $0.title == title }) 
    }
    
    func getArticlesCount()->Int{
        return categoryArticlesArray.count
    }
    func getArticleData(index:Int)->Article{
        return categoryArticlesArray[index]
    }
    
    func getCategoriesCount()->Int{
        return categoryItems.count
    }
    func getCategoryData(index:Int)->Category{
        return categoryItems[index]
    }
    func changeCategoriesIsSelectedStatus(index:Int){
        self.categoryItems.forEach({ item in
            item.isSelected = false
        })
        self.categoryItems[index].isSelected = true
        self.getArticlesData(category: categoryItems[index].title)
        self.selectedCayegory = categoryItems[index].title
    }
    
    func backupLastCategoryArticles(){
        self.getArticlesData(category:  self.selectedCayegory)
    }
    func endSearching(){
        self.getArticlesData(category:  self.selectedCayegory)
    }
    
    func navigationConfigure(for rowIndex:Int)->DetailsViewModel{
        return DetailsViewModel(articleData: categoryArticlesArray[rowIndex], databaseManager: RealmDatabaseService.instance)
    }
}


