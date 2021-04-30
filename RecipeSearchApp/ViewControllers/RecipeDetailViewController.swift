//
//  RecipeDetailViewController.swift
//  RecipeSearchApp
//
//  Created by Stephanie Ballard on 4/12/21.
//

import UIKit
import WebKit

class RecipeDetailViewController: UIViewController {
    
    // MARK: - Properties -
    
    let recipeTitleTextLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.recipeTeal
        label.numberOfLines = 0
        return label
    }()
    
    let recipeImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    var recipe: Recipe?
    
    // MARK: - Life Cycle Functions -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helper Methods -
    
    private func configureUI() {
        view.backgroundColor = UIColor.recipePink
        
        view.addSubviews(subviews: recipeTitleTextLabel, recipeImageView)
        
        recipeTitleTextLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 30, paddingLeft: 20, paddingRight: 20)
        
        recipeImageView.anchor(top: recipeTitleTextLabel.bottomAnchor, left: recipeTitleTextLabel.leftAnchor, right: recipeTitleTextLabel.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20, width: 150, height: 150)
        
        guard let recipe = recipe else { return }
        recipeTitleTextLabel.text = recipe.title.capitalized
        
    }
}

// MARK: - Extensions -


// did select will fetch the recipe details
// image fetch called in the custom image view
// detail vc will display the returned data from the call in the did select
