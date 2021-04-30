//
//  SearchTerm.swift
//  RecipeSearchApp
//
//  Created by Stephanie Ballard on 3/23/21.
//

import UIKit

struct SearchResult: Decodable, Hashable {
    let results: [Recipe]
}

struct Recipe: Decodable, Hashable {
    let id: Int
    let title: String
    var image: String
}
