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
    @IBOutlet weak var emptyCvImageView: UIImageView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var numberOfResultLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
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
        
        searchButton.tintColor = .orange
        deleteButton.tintColor = .red
        
        numberOfResultLabel.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        self.collectionViewContent = []
        self.collectionView.reloadData()
        self.emptyCvImageView.isHidden = false
        self.searchTextfield.text = ""
        self.numberOfResultLabel.isHidden = true
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        model.searchCocktails(searchTextfield.text ?? "", completion: { [weak self] result in
            switch result {
            case .success():
                self?.collectionViewContent = self?.model.cocktails ?? []
                self?.collectionView.reloadData()
                self?.emptyCvImageView.isHidden = true
                self?.numberOfResultLabel.isHidden = false
                self?.numberOfResultLabel.text = self?.collectionViewContent.count ?? 0 > 1 ? "\(self?.collectionViewContent.count ?? 0) résultats" : "\(self?.collectionViewContent.count ?? 0) résultats"
            case .failure(let failure):
                var title = ""
                var message = ""
                
                if failure == .noData {
                    title = "Dommage"
                    message = "Votre recherche ne rencontre aucun résultat. Essayez autre chose"
                }
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.openDetail(model.cocktails, indexPath)
    }
}

