//
//  FavoriteArticle.swift
//  NewsApp
//
//  Created by Eslam gamal on 31/07/2023.
//

import Foundation
import RealmSwift
class FavoriteArticle: Object{
    @objc dynamic  var sourceName: String?
    @objc dynamic  var author: String?
    @objc dynamic var title: String?
    @objc dynamic var descrip: String?
    @objc dynamic var url: String?
    @objc dynamic var urlToImage: String?
    @objc dynamic var publishedAt: String?
    @objc dynamic var content: String?
    required convenience init(sourceName:String,author:String,title:String,description:String, url:String, urlToImage: String,publishedAt:String,content:String){
        self.init()
        self.sourceName = sourceName
        self.author = author
        self.title = title
        self.descrip = description
        self.url=url
        self.urlToImage=urlToImage
        self.publishedAt=publishedAt
        self.content=content
    }
    func generateArticleModelObject()->Article{
        let source = Source(id: "",name: self.sourceName)
       let article = Article(source: source,author: author,title: title,description:descrip ,url: url,urlToImage: urlToImage,publishedAt: publishedAt,content: content)
        return article
    }
}
