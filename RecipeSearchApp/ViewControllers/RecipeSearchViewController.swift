//
//  RecipeSearchViewController.swift
//  RecipeSearchApp
//
//  Created by Stephanie Ballard on 3/23/21.
//

import UIKit

class RecipeSearchViewController: UIViewController {
    
    // MARK: - Enum -
    
    enum Section {
        case main
    }
    
    // MARK: - Properties -
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Recipe>!
    var collectionView: UICollectionView!
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.placeholder = "Search for something yummy!"
        searchBar.returnKeyType = UIReturnKeyType.search
        searchBar.barStyle = .black
        return searchBar
    }()

    let recipesApiController = RecipesApiController()
    
    // MARK: - Life Cycle Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureDataSource()
    }
    
    //    override var preferredStatusBarStyle: UIStatusBarStyle {
    //        return .lightContent
    //    }
    
    // MARK: - Selector -
    
    @objc func handleShowSearchBar() {
        theSearchBar(shouldShow: true)
        searchBar.becomeFirstResponder()
    }
    
    @objc func reloadRecipeImages() {
        collectionView.reloadData()
    }
    
    // MARK: - Helper Functions -
    
    private func configureUI() {
        showSearchBarButton(shouldShow: true)
        
        view.backgroundColor = UIColor.recipePink
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.register(RecipeCell.self, forCellWithReuseIdentifier: RecipeCell.reuseIdentifier)
        
        view.addSubviews(subviews: searchBar, collectionView)
        
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5)
        
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.recipePink
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.layer.cornerRadius = 12
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
//        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        //        collectionView.register(WWLogoHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WWLogoHeader.reuseIdentifier)
        collectionView.register(RecipeCell.self, forCellWithReuseIdentifier: RecipeCell.reuseIdentifier)
        
        let refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
    }
    
    private func configureDataSource() {
//        cell for item at
        dataSource = UICollectionViewDiffableDataSource<Section, Recipe>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, recipe: Recipe) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCell.reuseIdentifier, for: indexPath) as? RecipeCell
            cell?.recipe = recipe
       
            return cell
        }
        
        self.dataSource.reorderingHandlers.didReorder = { [weak self] transaction in
            guard let self = self else { return }
            self.recipesApiController.recipeSearchResults = transaction.finalSnapshot.itemIdentifiers
            print(self.recipesApiController.recipeSearchResults)
        }
        
        // if the collection view is editing you will be able to edit the cells
//        dataSource.reorderingHandlers.canReorderItem = { [weak self] _ -> (Bool) in
//            guard let self = self else { return false }
//            return self.collectionView.isEditing
//        }
        // when the user reorganizes the data use this to keep the source of truth correct, you need to use weak self here if you use self inside this closure that way it wont hold a strong reference to it. if you dont use self the class still owns the reference to it.
        // used to keep the source of truth accurate (the backing store) so that way when the user clicks the detail view the correct one will displayed
        
        
        // initial data
        
    }
    
    
    // TODO: ***** dont forget you accidentally messed with the plist on this project, need to download a fresh copy from github and update the files to this. shame on you for not committing!!!!
    
    
    
    private func applySearchSnapShot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Recipe>()
        snapshot.appendSections([.main])
        snapshot.appendItems(recipesApiController.recipeSearchResults)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    // MARK: - Search Bar Methods -
    
    private func showSearchBarButton(shouldShow: Bool) {
        if shouldShow {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleShowSearchBar))
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    private func theSearchBar(shouldShow: Bool) {
        showSearchBarButton(shouldShow: !shouldShow)
        searchBar.showsCancelButton = shouldShow
        
        navigationItem.titleView = shouldShow ? searchBar : nil
        let searchField = searchBar.value(forKey: "searchField") as? UITextField
        if let field = searchField {
            field.backgroundColor = .white
            field.returnKeyType = .search
        }
    }
}

// MARK: - Extensions -

// MARK: - CollectionView Delegate Methods -
extension RecipeSearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipe = recipesApiController.recipeSearchResults[indexPath.item]
        let detailViewController = RecipeDetailViewController()
        detailViewController.recipe = recipe
        navigationController?.pushViewController(detailViewController, animated: true)
        print(recipe)
    }
}

// MARK: - CollectionView Delegate Flow Layout Methods -
extension RecipeSearchViewController: UICollectionViewDelegateFlowLayout {
    
}

// MARK: - Search Bar Delegate -

extension RecipeSearchViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        theSearchBar(shouldShow: false)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        
        guard let searchbarText = searchBar.text else { return }
        recipesApiController.performSearch(with: searchbarText) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    print(self.recipesApiController.recipeSearchResults)
                    self.applySearchSnapShot()
                case .failure(let error):
                    print(error)
                }
            }
        }
        
//        var snapShot = dataSource.snapshot()
//        snapShot.
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(reloadRecipeImages), object: nil)
        self.perform(#selector(reloadRecipeImages), with: nil, afterDelay: 1.0)
    }
}

func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
}

