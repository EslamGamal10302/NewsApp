//
//  DetailsViewController.swift
//  NewsApp
//
//  Created by Eslam gamal on 31/07/2023.
//

import UIKit
import SafariServices
class DetailsViewController: UIViewController {
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsDate: UILabel!
    @IBOutlet weak var newsSource: UILabel!
    @IBOutlet weak var newsAuthor: UILabel!
    @IBOutlet weak var newsDescription: UILabel!
    @IBOutlet weak var newsContent: UILabel!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var favoriteStatus: UIButton!
    var articleTitle:String?
    var viewModel:DetailsViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.container.layer.cornerRadius = self.view.bounds.width * 0.08
        self.container.layer.masksToBounds = true
        displayArticleData()
        configureFavoriteStatus()
      
    }
    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func navigateToWebView(_ sender: UIButton) {
            if !(InternetConnectionObservation.getInstance.internetConnection.value ?? true){
                DispatchQueue.main.async {
                    self.internetErrorAlert()
                }
            }else {
                guard let url = URL(string: viewModel?.getArticleData().url ?? "") else {
                       return
                   }
                   let safariViewController = SFSafariViewController(url: url)
                   present(safariViewController, animated: true, completion: nil)
            }
    }
    
    @IBAction func addToFavorite(_ sender: UIButton) {
        if sender.imageView?.image == UIImage(systemName: "bookmark") {
            let data = self.viewModel?.getArticleData()
            self.viewModel?.addToFavorite(article: data?.generateFavoriteObject() ?? FavoriteArticle())
            sender.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            print("will add to favorite")
            self.view?.makeToast("Article added successfully to your favorite list", duration: 3 ,title: "Added successfully" ,image: UIImage(named: K.SUCESS_ICON))
        }else {
            print("already added")
            self.confirmAlert {
                self.viewModel?.deleteArticleFromFAvorite(title: self.articleTitle ?? "")
                sender.setImage(UIImage(systemName: "bookmark"), for: .normal)
                self.view?.makeToast("Article deleted successfully from your favorite list", duration: 3 ,title: "Removed successfully" ,image: UIImage(named: K.SUCESS_ICON))
            }
        }
    }
    func displayArticleData(){
        let data = viewModel?.getArticleData()
        newsImage.sd_setImage(with: URL(string: data?.urlToImage ?? ""), placeholderImage: UIImage(named: K.EMPTY_IMAGE))
        newsTitle.text = data?.title
        articleTitle = data?.title
        newsDate.text = data?.publishedAt?.formattedDateString()
        newsSource.text = data?.source?.name
        newsAuthor.text = data?.author
        newsDescription.text = data?.description
        newsContent.text = data?.content
    }
    func  configureFavoriteStatus(){
        let favoriteStatus = viewModel?.isFavorite(title: articleTitle ?? "")
        guard let favoriteStatus = favoriteStatus else {return}
        if favoriteStatus {
            self.favoriteStatus.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }else {
            self.favoriteStatus.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
    }
    
}
