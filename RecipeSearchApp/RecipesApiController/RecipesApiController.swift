//
//  File.swift
//  RecipeSearchApp
//
//  Created by Stephanie Ballard on 4/13/21.
//

import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case failedFetch
    case noData
    case failedDecode
}

class RecipesApiController {
    
    // MARK: - Enums -
    
    enum ImageSize: String {
        case size90X90 = "90x90"
        case size240X150 = "240x150"
        case size312x150 = "312x150"
        case size312x231 = "312x231"
        case size480x360 = "480x360"
        case size556x370 = "556x370"
        case size636x393 = "636x393"
    }
    
    enum ImageType: String {
        case jpg = "jpg"
        case png = "png"
    }
    
    // MARK: - Properties -
    
    var recipeSearchResults = [Recipe]()
    private lazy var jsonDecoder = JSONDecoder()
    private let recipeSearchBaseURL = URL(string: "https://api.spoonacular.com/recipes/complexSearch")!
    private let recipeImageSearchResultsBaseURL = URL(string: "https://spoonacular.com/recipeImages")
    private let apiKey = "c63d7d17b8754173aa6104f09814f9a1"
    
    // MARK: - Fetch Request -
    
    func performSearch(with searchTerm: String, completion: @escaping (Result<[Recipe], NetworkError>) -> Void) {
        
        guard var urlComponents = URLComponents(url: recipeSearchBaseURL, resolvingAgainstBaseURL: true) else { return }
        let queryItems = [URLQueryItem(name: "query", value: searchTerm), URLQueryItem(name: "apiKey", value: apiKey)]

        urlComponents.queryItems = queryItems
        
        let requestURL = (urlComponents.url)!
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        print(requestURL)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching recipes: \(error)")
                completion(.failure(.failedFetch))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200
            else {
                return completion(.failure(.failedFetch))
            }
            
            guard let data = data else {
                print("No data returned from server")
                completion(.failure(.noData))
                return
            }
            
            do {
                self.recipeSearchResults = try self.jsonDecoder.decode(SearchResult.self, from: data).results
                completion(.success(self.recipeSearchResults))
            } catch {
                print("Error decoding recipes: \(error)")
                completion(.failure(.failedDecode))
            }
        }.resume()
    }
    
//    func fetchSearchedRecipeImage(with id: Int, completion: @escaping (Result<UIImage?, NetworkError>) -> Void) {
//        guard let baseURL = recipeImageSearchResultsBaseURL else { return }
//        let url = baseURL.appendingPathComponent(imageFetchAppendingPathComponents(with: id, of: RecipesApiController.ImageSize(rawValue: ImageSize.size312x231.rawValue)!))
//                         .appendingPathExtension(ImageType.jpg.rawValue)
//        
//        var requestURL = URLRequest(url: url)
//        requestURL.httpMethod = HTTPMethod.get.rawValue
//        requestURL.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        print(requestURL)
//        
//        URLSession.shared.dataTask(with: url) { data, _, error in
//            if let error = error {
//                print("Error fetching searched recipe image: \(error)")
//                completion(.failure(.failedFetch))
//                return
//            }
//
//            guard let data = data else {
//                print("No data returned from server")
//                completion(.failure(.noData))
//                return
//            }
//
//            let image = UIImage(data: data)
//            completion(.success(image))
//        }.resume()
//    }
//    
//    func imageFetchAppendingPathComponents(with imageId: Int, of size: ImageSize) -> String {
//        return "\(imageId)-\(size.rawValue)"
//    }
}

//requestURL.setValue("application/json", forHTTPHeaderField: "Content-Type") // add this when you are doing a post so the server knows that it is receiving json
