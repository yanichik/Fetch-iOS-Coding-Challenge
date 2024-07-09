//
//  NetworkManager.swift
//  Fetch_Challenge_Desert-Recipes
//
//  Created by admin on 7/9/24.
//

import Foundation

enum FetchError: String, Error {
    case invalidURL = "This is an invalid URL. Please try again."
    case invalidResponse = "Invalid response from server. Please try again."
    case invalidData = "Received blank data. Please try again."
    case parseError = "Getting parse error. Please try again."
}


class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    let baseURLString = "https://themealdb.com/api/json/v1/1/filter.php"
    let queryDessertMeals = "?c=Dessert"
    let queryMealDetails = "?i="
    
    func getRequest(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            completionHandler(data, response, error)
        }
        task.resume()
    }
    
    func parseJSON<T: Codable>(data: Data, type: T.Type, completion: (T?) -> Void) -> Void {
        let decoder = JSONDecoder()
        do {
            let responseData = try decoder.decode(type.self, from: data)
            completion(responseData)
        } catch {
            completion(nil)
        }
    }
    
    func getDessertMealsList(completion: @escaping (Result<MealsList, FetchError>) -> Void) -> Void {
        guard let url = URL(string: baseURLString + queryDessertMeals) else {
            completion(.failure(.invalidURL))
            return
        }
        getRequest(url: url) { (data, response, error) in
            if error != nil {
                completion(.failure(.invalidResponse))
            } else {
                do {
                    guard let d = data else {
                        completion(.failure(.invalidData))
                        return
                    }
                    self.parseJSON(data: d, type: MealsList.self) { meals in
                        if let desertMealsList = meals {
                            completion(.success(desertMealsList))
                        } else {
                            completion(.failure(.parseError))
                        }
                    }
                }
            }
        }
    }
}
