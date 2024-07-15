//
//  MenuViewModel.swift
//  Fetch_Challenge_Desert-Recipes
//
//  Created by Yan Brunshteyn on 7/13/24.
//

import Foundation

class MenuViewModel {
    // Callbacks for notifying the VC about updates
    var onMealsListUpdated: (() -> Void)?
    var onErrorMessageUpdated: ((String) -> Void)?
    
    var heightForRow: CGFloat = 60

    var mealsList: [MenuMeals] = [] {
        didSet {
            onMealsListUpdated?()
        }
    }

    var errorMessage: String? {
        didSet {
            if let errorMessage = errorMessage {
                onErrorMessageUpdated?(errorMessage)
            }
        }
    }

    func fetchDesertMeals() async {
        do {
            let result = try await NetworkManager.shared.getDessertMealsList()
            switch result {
            case .success(let meals):
                mealsList = sortMealsAlphabetically(meals)
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func sortMealsAlphabetically(_ meals: [MenuMeals]) -> [MenuMeals] {
        let sortedMeals = meals.sorted { meal1, meal2 in
            return meal1.strMeal < meal2.strMeal
        }
        return sortedMeals
    }
}
