//
//  FavoritesViewController.swift
//  NewsApp
//
//  Created by Eslam gamal on 30/07/2023.
//

import UIKit

class FavoritesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var favoritesTable: UITableView!
    var viewModel = FavoriteViewModel(databaseManager: RealmDatabaseService.instance)
    @IBOutlet weak var emptyStatusView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.favoritesTable.register(UINib(nibName: K.NEWS_CELL, bundle: nil), forCellReuseIdentifier: K.NEWS_CELL)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureArticlesTableObservation()
        viewModel.getAllFavorites()
    }
    
    func configureArticlesTableObservation(){
        viewModel.articles.bind({ status in
            guard let status = status else {return}
            if status {
                DispatchQueue.main.async {
                    self.favoritesTable.reloadData()
                }
            }
        })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        checkDataStatus()
        return viewModel.getArticlesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.NEWS_CELL, for: indexPath)
        as!NewsViewCell
        let articleData = viewModel.getArticleData(index: indexPath.row)
        cell.configureFavoriteCell(data: articleData,viewModel: viewModel,index: indexPath.row,viewController: self)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailScreen = self.storyboard?.instantiateViewController(withIdentifier: K.DETAILS_SCREEN) as! DetailsViewController
        detailScreen.viewModel = self.viewModel.navigationConfigure(for: indexPath.row)
        detailScreen.modalPresentationStyle = .fullScreen
        detailScreen.modalTransitionStyle = .crossDissolve
        self.present(detailScreen, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.height*0.25
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animate(withDuration: 0.35) {
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }
    }
    func checkDataStatus(){
        if viewModel.getArticlesCount() == 0 {
            self.emptyStatusView.isHidden = false
        }else {
            self.emptyStatusView.isHidden = true
        }
    }

}
