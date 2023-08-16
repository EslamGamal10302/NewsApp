//
//  NewsViewCell.swift
//  NewsApp
//
//  Created by Eslam gamal on 30/07/2023.
//

import UIKit
import SDWebImage

class NewsViewCell: UITableViewCell {
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsDescription: UILabel!
    @IBOutlet weak var newsSource: UILabel!
    @IBOutlet weak var newsDate: UILabel!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var FavoriteButton: UIButton!
    var viewModel:HomeViewModel?
    var favoriteViewModel:FavoriteViewModel?
    var view:UIView?
    var viewController:UIViewController?
    var articleTitle:String?
    var cellStatus:NewsCellStatus?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func layoutSublayers(of layer: CALayer) {
        self.container.layer.cornerRadius = self.bounds.height*0.10
        self.container.layer.masksToBounds = true
        self.newsImage.layer.cornerRadius = self.bounds.height*0.05
        self.newsImage.clipsToBounds = true
    }
    
    func configureCell(data:Article,viewModel:HomeViewModel,index:Int,viewController:UIViewController){
        self.cellStatus = .home
        self.newsImage.sd_setImage(with: URL(string: data.urlToImage ?? ""), placeholderImage:UIImage(named: K.EMPTY_IMAGE))
        self.newsTitle.text = data.title
        self.articleTitle = data.title
        self.newsDescription.text = data.description
        self.newsSource.text = data.source?.name
        self.newsDate.text = data.publishedAt?.formattedDateString()
        self.viewModel = viewModel
        self.viewController = viewController
        self.view = viewController.view
        self.FavoriteButton.tag = index
        checkIsFavoriteStatus(title: data.title ?? "")
    }
    func checkIsFavoriteStatus(title:String){
        let favoriteStatus = viewModel?.isFavorite(title: title)
        guard let favoriteStatus = favoriteStatus else {return}
        if favoriteStatus {
            self.FavoriteButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }else {
            self.FavoriteButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        
    }
    
    func configureFavoriteCell(data:Article,viewModel:FavoriteViewModel,index:Int,viewController:UIViewController){
        self.cellStatus = .favorite
        self.newsImage.sd_setImage(with: URL(string: data.urlToImage ?? ""), placeholderImage:UIImage(named: K.EMPTY_IMAGE))
        self.newsTitle.text = data.title
        self.articleTitle = data.title
        self.newsDescription.text = data.description
        self.newsSource.text = data.source?.name
        self.newsDate.text = data.publishedAt?.formattedDateString()
        self.favoriteViewModel = viewModel
        self.viewController = viewController
        self.view = viewController.view
        self.FavoriteButton.tag = index
        self.FavoriteButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func addToFavorite(_ sender: UIButton) {
        if self.cellStatus == .home {
            if sender.imageView?.image == UIImage(systemName: "bookmark") {
                let data = self.viewModel?.getArticleData(index: sender.tag)
                self.viewModel?.addToFavorite(article: data?.generateFavoriteObject() ?? FavoriteArticle())
                sender.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                print("will add to favorite")
                self.view?.makeToast("Article added successfully to your favorite list", duration: 3 ,title: "Added successfully" ,image: UIImage(named: K.SUCESS_ICON))
            }else {
                print("already added")
                self.viewController?.confirmAlert {
                    self.viewModel?.deleteArticleFromFAvorite(title: self.articleTitle ?? "")
                    sender.setImage(UIImage(systemName: "bookmark"), for: .normal)
                    self.view?.makeToast("Article deleted successfully from your favorite list", duration: 3 ,title: "Removed successfully" ,image: UIImage(named: K.SUCESS_ICON))
                }
            }
        }else {
            print("already added")
            self.viewController?.confirmAlert {
                self.favoriteViewModel?.removeFromFavorites(title: self.articleTitle ?? "")
                self.view?.makeToast("Article deleted successfully from your favorite list", duration: 3 ,title: "Removed successfully" ,image: UIImage(named: K.SUCESS_ICON))
            }
        }
        
        
    }
    
}
