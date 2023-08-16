//
//  RealmServiceProtocol.swift
//  NewsApp
//
//  Created by Eslam gamal on 31/07/2023.
//

import Foundation
import RealmSwift
protocol RealmServiceProtocol{
    func initRealmFile(complitionHandler : @escaping(_ errorMessage:String?) -> ())
    func addArticle<T: Object>(article: T, completionHandler: @escaping (_ errorMessage: String?) -> ())
    func getAllArticles<T: Object>(ofType type: T.Type,completionHandler: @escaping (_ errorMessage: String?, _ articles: Results<T>?) -> ())
    func deleteAllArticles<T: Object>(ofType type: T.Type, completionHandler: @escaping (_ errorMessage: String?) -> ())
    func deleteSingleArticle<T: Object>(ofType type: T.Type, title: String, completionHandler: @escaping (_ errorMessage: String?) -> ())
}
