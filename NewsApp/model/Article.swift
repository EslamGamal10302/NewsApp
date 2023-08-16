//
//  Article.swift
//  NewsApp
//
//  Created by Eslam gamal on 31/07/2023.
//

import Foundation
class NewsResponse: Codable {
    var status: String?
    var totalResults: Int?
    var articles: [Article]?
    init(status: String? = nil, totalResults: Int? = nil, articles: [Article]? = nil) {
        self.status = status
        self.totalResults = totalResults
        self.articles = articles
    }
}
class Article: Codable {
    var source: Source?
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
    
    init(source: Source? = nil, author: String? = nil, title: String? = nil, description: String? = nil, url: String? = nil, urlToImage: String? = nil, publishedAt: String? = nil, content: String? = nil) {
        self.source = source
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
    }
    
    func generateBackupObject()->BackupArticle{
        return BackupArticle(sourceName: source?.name ?? "", author: author ?? "", title: title ?? "" , description: description ?? "" , url: url ?? "" , urlToImage: urlToImage ?? "", publishedAt: publishedAt ?? "", content: content ?? "")
    }
    
    func generateFavoriteObject()->FavoriteArticle{
        return FavoriteArticle(sourceName: source?.name ?? "" , author: author ?? "" , title: title ?? "", description: description ?? "", url: url ?? "", urlToImage: urlToImage ?? "" , publishedAt: publishedAt ?? "" , content: content ?? "")
    }
  
}
class Source: Codable {
    var id: String?
    var name: String?
    
    init(id: String? = nil, name: String? = nil) {
        self.id = id
        self.name = name
    }
}

