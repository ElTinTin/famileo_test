//
//  ViewController.swift
//  famileo_test
//
//  Created by Quentin Deschamps on 16/08/2023.
//

import UIKit

class CocktailSearchListViewController: UIViewController {
    // MARK: - Properties
    private let reuseIdentifier = "CocktailViewCell"
    private let itemsPerRow = 2
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var coordinator: CocktailSearchListCoordinator?
    private var model: CocktailSearchListModel!
    
    static func instantiate(model: CocktailSearchListModel) -> CocktailSearchListViewController {
        let storyboard = UIStoryboard(name: "CocktailSearchList", bundle: nil)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "CocktailSearchListViewController") as? CocktailSearchListViewController else {
            fatalError("Failed to instantiate CocktailSearchListViewController")
        }
        viewController.model = model
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Bibli'Cocktail"
        coordinator?.navigationController = navigationController
        
        collectionView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    }
}

extension CocktailSearchListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return model.sectionCount
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        guard let item = model.cocktails.get(index: indexPath.row), let cell = cell as? CocktailViewCell else { return cell }
        
        // TODO: Cocktail View Cell config
    }
}

extension CocktailSearchListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath ) -> CGSize {
        let availableWidth = view.frame.width
        let widthPerItem = Int(availableWidth) / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}

