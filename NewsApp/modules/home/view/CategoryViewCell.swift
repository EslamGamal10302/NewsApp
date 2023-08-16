//
//  CategoryViewCell.swift
//  NewsApp
//
//  Created by Eslam gamal on 30/07/2023.
//

import UIKit

class CategoryViewCell: UICollectionViewCell {
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func layoutSublayers(of layer: CALayer) {
        self.container.layer.cornerRadius = cellView.bounds.height*0.17
        self.container.layer.masksToBounds = true
    }
    
    func configureCell(title:String,image:UIImage){
        categoryTitle.text=title
        categoryImage.image=image
      
    }
    
}
