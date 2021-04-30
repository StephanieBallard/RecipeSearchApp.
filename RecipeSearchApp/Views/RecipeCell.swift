//
//  RecipeCell.swift
//  RecipeSearchApp
//
//  Created by Stephanie Ballard on 4/8/21.
//

import UIKit

class RecipeCell: UICollectionViewCell {
    
    // MARK: - Properties -
    
    static let reuseIdentifier = "RecipeCell"
    private let padding: CGFloat = 4
    
    let recipeNameTextLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.textAlignment = .left
        textLabel.numberOfLines = 0
        textLabel.textColor = .black
        return textLabel
    }()
    
    let recipeImageView: CustomImageView = {
        let imageView = CustomImageView(image: UIImage(named: "RecipePlaceHolderImage"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var recipeApiController: RecipesApiController?
    
    var recipe: Recipe? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Initializers -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Help Methods -
    
    private func updateViews() {
        guard let searchedRecipe = recipe else { return }
        recipeNameTextLabel.text = searchedRecipe.title.capitalized
        recipeImageView.fetchSearchedRecipeImage(with: searchedRecipe.image) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    print("success")
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func configureCell() {
        backgroundColor = UIColor.recipeTeal
        layer.borderWidth = 4
        layer.borderColor = UIColor.recipeLightBlue?.cgColor
        layer.cornerRadius = 10
        
        addSubviews(subviews: recipeNameTextLabel, recipeImageView)
        
        recipeNameTextLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding)
        recipeImageView.anchor(top: recipeNameTextLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: padding, paddingLeft: padding, paddingBottom: padding, paddingRight: padding)
    }
}
