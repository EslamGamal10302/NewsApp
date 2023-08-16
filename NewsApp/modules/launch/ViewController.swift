//
//  ViewController.swift
//  NewsApp
//
//  Created by Eslam gamal on 30/07/2023.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var appIcon: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        showAnimation()
    }
    func showAnimation() {
        UIView.animate(withDuration: 2,animations: {
                self.appIcon.frame = CGRect(x:  self.appIcon.frame.minX-120, y:  self.appIcon.frame.minY-120, width:  self.appIcon.frame.width + 240, height:  self.appIcon.frame.height + 240)
            
        }) { completion in
            if completion {
               self.labelAnimation()
             
            }
        }
    }
    func labelAnimation(){
        UIView.animate(withDuration: 1,animations: {  self.appName.alpha=1}){
            completion in
               if completion {
                   let home = self.storyboard?.instantiateViewController(identifier: "home") as! UITabBarController
                   home.modalPresentationStyle = .fullScreen
                   home.modalTransitionStyle = .crossDissolve
                   self.present(home, animated: true)
                
               }
        }
    }

}

