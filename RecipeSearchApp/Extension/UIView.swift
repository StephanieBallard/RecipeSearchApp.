//
//  UIView.swift
//  RecipeSearchApp
//
//  Created by Stephanie Ballard on 3/23/21.
//

import UIKit

extension UIView {
    func addSubviews(subviews: UIView...) {
        subviews.forEach {
            addSubview($0)
        }
    }
}
