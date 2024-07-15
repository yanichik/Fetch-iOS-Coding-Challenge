//
//  DetailViewModel.swift
//  Fetch_Challenge_Desert-Recipes
//
//  Created by admin on 7/13/24.
//

import Foundation

class DetailViewModel {
    // Callbacks for notifying the VC about updates
    var onMealUpdated: (() -> Void)?
    var onMealThumbUpdated: (() -> Void)?
    var onErrorMessageUpdated: ((String) -> Void)?
    
    var rowCount: Int?
    var ingredients: [String]?
    var measurements: [String]?
    
    var mealId: String? {
        didSet {
            Task {
                await fetchMeal(mealIdString: mealId!)
            }
        }
    }
    
    var mealThumb: String? {
        didSet {
            // onMealThumbUpdated()
        }
    }
    var meal: Meal? {
        didSet {
            onMealUpdated?()
            onMealThumbUpdated?()
            ingredients = getIndgredients()
            measurements = getMeasurements()
            rowCount = ingredients?.count
        }
    }
    
    var errorMessage: String? {
        didSet {
            if let errorMessage = errorMessage {
                onErrorMessageUpdated?(errorMessage)
            }
        }
    }
    
    func fetchMeal(mealIdString: String) async {
        do {
            let result = try await NetworkManager.shared.getMeal(mealStr: mealIdString)
            switch result {
            case .success(let meal):
                self.meal = meal
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func getIndgredients() -> [String]{
        guard let meal = self.meal else {
            return []
        }
        let ingredients = Array(meal.allProperties().filter {
            ($0.key.contains("strIngredient")) && (!$0.value.isEmpty)}.values
        )
        return ingredients
    }
    
    func getMeasurements() -> [String]{
        guard let meal = self.meal else {
            return []
        }
        let measurements = Array(meal.allProperties().mapValues {$0.trimmingCharacters(in: .whitespacesAndNewlines)}
            .filter {
            ($0.key.contains("strMeasure")) && (!$0.value.isEmpty)}.values
        )
        return measurements
    }
//    Instructions
//    Ingredients/measurements
}
