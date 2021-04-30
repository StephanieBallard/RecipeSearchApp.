//
//  SelfLoadingImageView.swift
//  RecipeSearchApp
//
//  Created by Stephanie Ballard on 4/26/21.
//

import UIKit

class CustomImageView: UIImageView {
    
    func fetchSearchedRecipeImage(with urlString: String, completion: @escaping (Result<UIImage?, NetworkError>) -> Void) {
        
        guard let url = URL(string: urlString) else { return }
        
        var requestURL = URLRequest(url: url)
        requestURL.httpMethod = HTTPMethod.get.rawValue
        print(requestURL)
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching searched recipe image: \(error)")
                completion(.failure(.failedFetch))
                return
            }

            guard let data = data else {
                print("No data returned from server")
                completion(.failure(.noData))
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
                completion(.success(self.image))
            }
        }.resume()
    }
}

