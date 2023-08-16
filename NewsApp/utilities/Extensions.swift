//
//  Extensions.swift
//  NewsApp
//
//  Created by Eslam gamal on 31/07/2023.
//

import Foundation
import UIKit
//MARK: - Custom String date
extension String {
    func formattedDateString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "MMM d, yyyy"
            return dateFormatter.string(from: date)
        }
        return nil
    }
}

//MARK: - Custom alerts
extension UIViewController {
    func confirmAlert(title:String = "Delete" , subTitle:String = "Are you sure you want to delete this Item?" , imageName:String = K.WARNING_ICON, confirmBtn: String = "Yes, Delete" ,handler: (() -> Void)?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myAlert = storyboard.instantiateViewController(withIdentifier: "CustomAlertViewController") as! CustomAlertViewController
        
        myAlert.titles = title
        myAlert.subTitle = subTitle
        myAlert.imageName = imageName
        myAlert.okBtn = confirmBtn
        myAlert.okBtnHandler = handler
        myAlert.cancelBtn = "Cancel"
        
        myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(myAlert, animated: true, completion: nil)
    }
    
    func internetErrorAlert(title:String = "No Internet Connection" , subTitle:String = "No internet Connection please make sure to connect to 4G or Wifi , now you see backup news" , imageName:String = K.WARNING_ICON, confirmBtn: String = "Ok") {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myAlert = storyboard.instantiateViewController(withIdentifier: "CustomAlertViewControllerOneButton") as! CustomAlertViewControllerOneButton
        
        myAlert.titles = title
        myAlert.subTitle = subTitle
        myAlert.imageName = imageName
        myAlert.okBtn = confirmBtn
        
        myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(myAlert, animated: true, completion: nil)
    }
}


