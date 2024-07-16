//
//  NetworkManager.swift
//  Fetch_Challenge_Desert-Recipes
//
//  Created by Yan Brunshteyn on 7/9/24.
//

import Foundation
import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    let baseMealsURLString = "https://themealdb.com/api/json/v1/1/filter.php"
    let baseQueryMealURLString = "https://themealdb.com/api/json/v1/1/lookup.php"
    let queryDessertMeals = "?c=Dessert"
    let queryMealDetails = "?i="
    
    func getRequest(url: URL) async throws -> (Data?, HTTPURLResponse?) {
        let (data, response) = try await URLSession.shared.data(from: url)
        return (data, response as? HTTPURLResponse)
    }
    
    func parseJSON<T: Codable>(data: Data, type: T.Type) async -> Result<T, FetchError> {
        let decoder = JSONDecoder()
        do {
            let responseData = try decoder.decode(type.self, from: data)
            return .success(responseData)
        } catch {
            return .failure(.parseError)
        }
    }
    
    func getDessertMealsList() async throws -> Result<[MenuMeals], FetchError> {
        guard let url = URL(string: baseMealsURLString + queryDessertMeals) else {
            throw FetchError.invalidURL
        }
        let (data, response) = try await getRequest(url: url)
        if let statusCode = response?.statusCode {
            print("statusCode: \(statusCode)")
            if !(200...299).contains(statusCode) {
                return .failure(.invalidResponse(statusCode: statusCode))
            }
        }
        guard let d = data else {
            throw FetchError.invalidData (reason: "Returned blank data field in server response.")
        }
        let parseResult = await parseJSON(data: d, type: MealsList.self)
        switch parseResult {
        case .success(let parsed):
            guard let meals = parsed.meals else {
                return .failure(.invalidData (reason: "Returned nil data when parsing JSON."))
            }
            return .success(meals)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getMeal(mealStr: String) async throws -> Result<Meal, FetchError> {
        guard let url = URL(string: baseQueryMealURLString + queryMealDetails + mealStr) else {
            throw FetchError.invalidURL
        }
        let (data, response) = try await getRequest(url: url)
        if let statusCode = response?.statusCode {
            print("statusCode: \(statusCode)")
            if !(200...299).contains(statusCode) {
                return .failure(.invalidResponse(statusCode: statusCode))
            }
        }
        guard let d = data else {
            throw FetchError.invalidData (reason: "Returned blank data field in server response.")
        }
        let parseResult = await parseJSON(data: d, type: MealsDetail.self)
        switch parseResult {
        case .success(let parsed):
            guard let meal = parsed.meals?[0] else {
                return .failure(.invalidData (reason: "Returned nil data when parsing JSON."))
            }
            return .success(meal)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func loadImage(from urlString: String) async throws -> UIImage? {
        guard let url = URL(string: urlString) else {
            throw FetchError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw FetchError.invalidData(reason: "Image data is corrupted.")
        }
        return image
    }
    
    enum FetchError: Error {
        case invalidURL
        case invalidResponse (statusCode: Int)
        case invalidData (reason: String)
        case parseError
        
        var localizedDescription: String {
            switch self {
            case .invalidURL:
                return "This is an invalid URL. Please try again."
            case .invalidResponse(let statusCode):
                return "Invalid server response with statusCode \"\(statusCode)\". Please try again."
            case .invalidData (let reason):
                return "\(reason) Please try again."
            case .parseError:
                return "Getting parse error. Please try again."
            }
        }
    }
}
