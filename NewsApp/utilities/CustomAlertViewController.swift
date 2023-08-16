//
//  CustomAlertViewController.swift
//  NewsApp
//
//  Created by Eslam gamal on 31/07/2023.
//

import UIKit

class CustomAlertViewController: UIViewController {
    
    
    @IBOutlet weak var myAlertImage: UIImageView!
    @IBOutlet weak var alertTitle: UILabel!
    @IBOutlet weak var okBtnView: UIButton!
    @IBOutlet weak var cancelBtnView: UIButton!
    @IBOutlet weak var alertSubTitle: UILabel!
    var titles:String!
    var subTitle:String!
    var imageName:String!
    var okBtn: String?
    var okBtnHandler : (() -> Void)?
    var cancelBtn:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let font = UIFont(name: "Chalkduster", size: 17.0)!
        cancelBtnView.isHidden=false
        var attributedText = NSAttributedString(string: "Cancel", attributes: [NSAttributedString.Key.font: font])
        cancelBtnView.setAttributedTitle(attributedText, for: .normal)
        attributedText = NSAttributedString(string: okBtn ?? "Ok", attributes: [NSAttributedString.Key.font: font])
        okBtnView.setAttributedTitle(attributedText, for: .normal)
        alertTitle.text=titles
        alertSubTitle.text=subTitle
        myAlertImage.image=UIImage(named: imageName)
        
        
    }
    
    
    @IBAction func saveBtn(_ sender: UIButton) {
        if let handler = okBtnHandler{
            handler()
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
