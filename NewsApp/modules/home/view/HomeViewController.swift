//
//  HomeViewController.swift
//  NewsApp
//
//  Created by Eslam gamal on 30/07/2023.
//

import UIKit
import Lottie

class HomeViewController: UIViewController {
    @IBOutlet weak var categoryCollection: UICollectionView!
    @IBOutlet weak var newsTable: UITableView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loadingAnimation: LottieAnimationView!
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var emptyStatusView: UIView!
    let viewModel = HomeViewModel(networkManager: NetworkManager.shared,databaseManager: RealmDatabaseService.instance)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.container.layer.cornerRadius = self.view.bounds.width * 0.045
        self.container.layer.masksToBounds = true
        self.categoryCollection.register(UINib(nibName: K.CATEGORY_CELL, bundle: nil), forCellWithReuseIdentifier: K.CATEGORY_CELL)
        self.newsTable.register(UINib(nibName: K.NEWS_CELL, bundle: nil), forCellReuseIdentifier: K.NEWS_CELL)
        refreshControl.tintColor = UIColor(named: K.REFRESH_COLOUR)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        newsTable.addSubview(refreshControl)
        configureArticlesTableObservation()
        configureFailureStatusObservation()
        viewModel.getArticlesData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureInternetConnectionObservation()
        self.viewModel.getAllFAvoritesArticles()
        viewModel.backupLastCategoryArticles()
    }
    
    
    func configureInternetConnectionObservation(){
        InternetConnectionObservation.getInstance.internetConnection.bind { status in
            guard let status = status else {return}
            if !status{
                DispatchQueue.main.async {
                    self.viewModel.getBackupData()
                    self.internetErrorAlert()
                    self.emptyStatusView.isHidden = true
                }
            }
        }
    }

}

// MARK: - News Categories section
extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getCategoriesCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CATEGORY_CELL, for: indexPath)
            as! CategoryViewCell
            let categoryData = viewModel.getCategoryData(index: indexPath.row)
            cell.configureCell(title: categoryData.title, image: categoryData.image)
            if categoryData.isSelected{
                cell.container.backgroundColor=UIColor(named: K.SELECTED_CATEGORY_COLOR)
            } else {
                cell.container.backgroundColor = .clear
            }
            return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width*0.17), height: (collectionView.bounds.height*1.0))
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return  20
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return  0.1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 5)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if  InternetConnectionObservation.getInstance.internetConnection.value ?? false {
            updateDisplayStatus()
            closeKeyBoard()
            viewModel.changeCategoriesIsSelectedStatus(index: indexPath.row)
            categoryCollection.reloadData()
      
       }else{
            self.viewModel.getBackupData()
            self.internetErrorAlert()
            self.emptyStatusView.isHidden = true
       }
   
    }
    
}


// MARK: - News  section
extension HomeViewController:UITableViewDelegate,UITableViewDataSource{
    
    func configureArticlesTableObservation(){
        print("Home Observation")
        viewModel.articles.bind({ status in
            guard let status = status else {return}
            if status {
                DispatchQueue.main.async {
                    self.newsTable.reloadData()
                }
            }
        })
    }
    func configureFailureStatusObservation(){
        viewModel.failureRequestStatus.bind({ status in
            guard let status = status else {return}
            if status {
                DispatchQueue.main.async {
                    self.stopAnimation()
                    self.showEmptyStatus()
                    if InternetConnectionObservation.getInstance.internetConnection.value ?? true {
                        self.view.makeToast("please try again", duration: 3 ,title: "Unexpected error" ,image: UIImage(named: K.WARNING_ICON))
                    }
                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        checkLoadingDataStatus()
        return viewModel.getArticlesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.NEWS_CELL, for: indexPath)
        as!NewsViewCell
        let articleData = viewModel.getArticleData(index: indexPath.row)
        cell.configureCell(data: articleData,viewModel: viewModel,index: indexPath.row,viewController: self)
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
    
    func checkLoadingDataStatus(){
        if viewModel.articles.value == false {
            startAnimation()
        } else {
            stopAnimation()
            if viewModel.getArticlesCount() == 0 {
                showEmptyStatus()
            }else {
                HideEmptyStatus()
                self.newsTable.isHidden = false
            }
            
        }
    }
    
    func startAnimation(){
        loadingAnimation.isHidden = false
        loadingAnimation.animationSpeed=1.5
        loadingAnimation.loopMode = .loop
        loadingAnimation.play()
    }
    func stopAnimation(){
        loadingAnimation.isHidden = true
    }
    func showEmptyStatus(){
        if InternetConnectionObservation.getInstance.internetConnection.value ?? false{
            emptyStatusView.isHidden = false
        }
    }
    func HideEmptyStatus(){
        emptyStatusView.isHidden = true
    }
    func updateDisplayStatus(){
        self.newsTable.isHidden = true
        startAnimation()
    }
    
    @objc func refreshData(){
        refreshControl.endRefreshing()
        updateDisplayStatus()
        let currentCategory = viewModel.selectedCayegory
        self.viewModel.getArticlesData(category: currentCategory)
      
    }
    
    
}


// MARK: - search  section
extension HomeViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("search changed")
        if searchText.count > 0 {
            print(searchText)
            updateDisplayStatus()
            self.viewModel.searchForArticles(searchText: searchText)
          } else {
              DispatchQueue.main.async {
                  searchBar.resignFirstResponder()
                  self.viewModel.endSearching()
              }
          }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func closeKeyBoard(){
            searchBar.text = ""
            searchBar.resignFirstResponder()
    }


}

