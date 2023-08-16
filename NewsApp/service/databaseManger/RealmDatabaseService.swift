//
//  RealmDatabaseService.swift
//  NewsApp
//
//  Created by Eslam gamal on 31/07/2023.
//

import Foundation
import RealmSwift
class RealmDatabaseService:RealmServiceProtocol{
    static var instance = RealmDatabaseService()
    private var realmFileReference:Realm?
    private init() {}
    func initRealmFile(complitionHandler : @escaping(_ errorMessage:String?) -> ()){
        do{
            realmFileReference = try Realm()
            complitionHandler(nil)
        }catch {
            complitionHandler(error.localizedDescription)
        }
    }
    
    func addArticle<T: Object>(article: T, completionHandler: @escaping (_ errorMessage: String?) -> ()) {
        initRealmFile { errorMessage in
            if let errorMessage = errorMessage {
                completionHandler(errorMessage)
            } else {
                do {
                        try self.realmFileReference?.write {
                            self.realmFileReference?.add(article)
                            completionHandler(nil)
                        }
                    
                } catch {
                    completionHandler(error.localizedDescription)
                }
            }
        }
    }
    
    
    func getAllArticles<T: Object>(ofType type: T.Type,completionHandler: @escaping (_ errorMessage: String?, _ articles: Results<T>?) -> ()) {
        initRealmFile { errorMessage in
            if let errorMessage = errorMessage {
                completionHandler(errorMessage, nil)
            } else {
                let results = self.realmFileReference?.objects(type)
                if let results = results {
                    completionHandler(nil, results)
                }
                
            }
        }
    }
    
    func deleteAllArticles<T: Object>(ofType type: T.Type, completionHandler: @escaping (_ errorMessage: String?) -> ()) {
        initRealmFile { errorMessage in
            if let errorMessage = errorMessage {
                completionHandler(errorMessage)
            } else {
                let results = self.realmFileReference?.objects(type)
                if let results = results {
                    do {
                        try self.realmFileReference?.write {
                            self.realmFileReference?.delete(results)
                            completionHandler(nil)
                        }
                    } catch {
                        completionHandler(error.localizedDescription)
                    }
                }
                completionHandler(nil)
            }
        }
    }
    func deleteSingleArticle<T: Object>(ofType type: T.Type, title: String, completionHandler: @escaping (_ errorMessage: String?) -> ()) {
        initRealmFile { errorMessage in
            if let errorMessage = errorMessage {
                completionHandler(errorMessage)
            } else {
                let results = self.realmFileReference?.objects(type)
                if let results = results {
                    do {
                        let item = results.filter("title = %@", title)
                        try self.realmFileReference?.write {
                            self.realmFileReference?.delete(item)
                        }
                        completionHandler(nil)
                    } catch {
                        completionHandler(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    
}
