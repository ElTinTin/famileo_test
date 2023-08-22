//
//  CocktailDetail+ViewController.swift
//  famileo_test
//
//  Created by Quentin Deschamps on 22/08/2023.
//

import UIKit

class CocktailDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var glassTypeLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    var coordinator: CocktailSearchListCoordinator?
    private var model: CocktailDetailModel?
    
    static func instantiate(model: CocktailDetailModel) -> CocktailDetailViewController {
        let storyboard = UIStoryboard(name: "CocktailDetailViewController", bundle: nil)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "CocktailDetailViewController") as? CocktailDetailViewController else {
            fatalError("Failed to instance CocktailDetailViewController")
        }
        
        viewController.model = model
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coordinator?.navigationController = navigationController
        self.navigationController?.navigationBar.tintColor = .orange
        
        setupUI()
    }
    
    func setupUI() {
        if let url = URL(string: model?.cocktail?.thumb?.replacingOccurrences(of: "\\", with: "") ?? "") {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let imageData = data else { return }
                
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: imageData)
                }
            }.resume()
        }
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        imageView.layer.shadowRadius = 2
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.masksToBounds = false
        
        titleLabel.text = model?.cocktail?.title ?? ""
        
        typeLabel.text = model?.cocktail?.type ?? ""
        typeLabel.colorTagged()
        
        categoryLabel.text = model?.cocktail?.category ?? ""
        categoryLabel.colorTagged()
        
        glassTypeLabel.text = model?.cocktail?.glass ?? ""
        glassTypeLabel.colorTagged()
        
        instructionsLabel.text = model?.cocktail?.instructions ?? ""
        
        if let ingredients = model?.ingredients {
            for (ingredient, measure) in ingredients {
                let label = UILabel()
                label.text = "\(ingredient) : \(measure)"
                label.colorTagged()
                
                label.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
                label.textAlignment = .center
                
                stackView.addArrangedSubview(label)
            }
            
            stackView.heightAnchor.constraint(equalToConstant: CGFloat(ingredients.count * 44 + (ingredients.count - 2) * 2)).isActive = true
        }
    }
}