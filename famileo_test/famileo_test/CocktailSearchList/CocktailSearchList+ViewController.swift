//
//  ViewController.swift
//  famileo_test
//
//  Created by Quentin Deschamps on 16/08/2023.
//

import UIKit

class CocktailSearchListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - Properties
    private let itemsPerRow = 2
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var coordinator: CocktailSearchListCoordinator?
    private var model: CocktailSearchListModel!
    
    var collectionViewContent: [Cocktail] = []
    
    static func instantiate(model: CocktailSearchListModel) -> CocktailSearchListViewController {
        let storyboard = UIStoryboard(name: "CocktailSearchListViewController", bundle: nil)
        
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
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: CocktailViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CocktailViewCell.identifier)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        collectionView.collectionViewLayout = layout
        
        collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        model.searchCocktails(searchTextfield.text ?? "", completion: { [weak self] _ in
            self?.collectionViewContent = self?.model.cocktails ?? []
            self?.collectionView.reloadData()
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewContent.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CocktailViewCell.identifier, for: indexPath)
        
        guard let item = model.cocktails.get(index: indexPath.row), let cell = cell as? CocktailViewCell else { return cell }
        
        cell.configureCell(item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 2 - 8, height: 200)
    }
}

