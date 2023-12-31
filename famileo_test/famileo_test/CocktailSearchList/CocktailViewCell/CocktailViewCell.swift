//
//  CocktailViewCell.swift
//  famileo_test
//
//  Created by Quentin Deschamps on 16/08/2023.
//

import Foundation
import UIKit

class CocktailViewCell: UICollectionViewCell {
    static let identifier = "\(CocktailViewCell.self)"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(_ model: Cocktail) {
        if let url = URL(string: model.thumb?.replacingOccurrences(of: "\\", with: "") ?? "") {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let imageData = data else { return }
                
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: imageData)
                }
            }.resume()
        }
        title.text = model.title ?? ""
        
        self.backView.layer.cornerRadius = 8
        self.backView.layer.masksToBounds = true
        
        self.layer.shadowOpacity = 0.18
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.masksToBounds = false
    }
}
