//
//  MealModel.swift
//  Fetch_Challenge_Desert-Recipes
//
//  Created by Yan Brunshteyn on 7/9/24.
//

import Foundation

struct MealsList: Codable {
    var meals: [MenuMeals]?
}

struct MenuMeals: Codable {
    var idMeal: String
    var strMeal: String
    var strMealThumb: String
}

struct MealsDetail: Codable {
    var meals: [Meal]?
}

struct Meal: Codable {
    var idMeal: String
    var strMeal: String
    var strInstructions: String
    var strIngredient1: String?
    var strIngredient2: String?
    var strIngredient3: String?
    var strIngredient4: String?
    var strIngredient5: String?
    var strIngredient6: String?
    var strIngredient7: String?
    var strIngredient8: String?
    var strIngredient9: String?
    var strIngredient10: String?
    var strIngredient11: String?
    var strIngredient12: String?
    var strIngredient13: String?
    var strIngredient14: String?
    var strIngredient15: String?
    var strIngredient16: String?
    var strIngredient17: String?
    var strIngredient18: String?
    var strIngredient19: String?
    var strIngredient20: String?
    var strMeasure1: String?
    var strMeasure2: String?
    var strMeasure3: String?
    var strMeasure4: String?
    var strMeasure5: String?
    var strMeasure6: String?
    var strMeasure7: String?
    var strMeasure8: String?
    var strMeasure9: String?
    var strMeasure10: String?
    var strMeasure11: String?
    var strMeasure12: String?
    var strMeasure13: String?
    var strMeasure14: String?
    var strMeasure15: String?
    var strMeasure16: String?
    var strMeasure17: String?
    var strMeasure18: String?
    var strMeasure19: String?
    var strMeasure20: String?
    
    func allProperties() -> [String:String] {
        return [
            "idMeal": idMeal,
            "strMeal": strMeal,
            "strInstructions": strInstructions,
            "strIngredient1": strIngredient1 ?? "",
            "strIngredient2": strIngredient2 ?? "",
            "strIngredient3": strIngredient3 ?? "",
            "strIngredient4": strIngredient4 ?? "",
            "strIngredient5": strIngredient5 ?? "",
            "strIngredient6": strIngredient6 ?? "",
            "strIngredient7": strIngredient7 ?? "",
            "strIngredient8": strIngredient8 ?? "",
            "strIngredient9": strIngredient9 ?? "",
            "strIngredient10": strIngredient10 ?? "",
            "strIngredient11": strIngredient11 ?? "",
            "strIngredient12": strIngredient12 ?? "",
            "strIngredient13": strIngredient13 ?? "",
            "strIngredient14": strIngredient14 ?? "",
            "strIngredient15": strIngredient15 ?? "",
            "strIngredient16": strIngredient16 ?? "",
            "strIngredient17": strIngredient17 ?? "",
            "strIngredient18": strIngredient18 ?? "",
            "strIngredient19": strIngredient19 ?? "",
            "strIngredient20": strIngredient20 ?? "",
            "strMeasure1": strMeasure1 ?? "",
            "strMeasure2": strMeasure2 ?? "",
            "strMeasure3": strMeasure3 ?? "",
            "strMeasure4": strMeasure4 ?? "",
            "strMeasure5": strMeasure5 ?? "",
            "strMeasure6": strMeasure6 ?? "",
            "strMeasure7": strMeasure7 ?? "",
            "strMeasure8": strMeasure8 ?? "",
            "strMeasure9": strMeasure9 ?? "",
            "strMeasure10": strMeasure10 ?? "",
            "strMeasure11": strMeasure11 ?? "",
            "strMeasure12": strMeasure12 ?? "",
            "strMeasure13": strMeasure13 ?? "",
            "strMeasure14": strMeasure14 ?? "",
            "strMeasure15": strMeasure15 ?? "",
            "strMeasure16": strMeasure16 ?? "",
            "strMeasure17": strMeasure17 ?? "",
            "strMeasure18": strMeasure18 ?? "",
            "strMeasure19": strMeasure19 ?? "",
            "strMeasure20": strMeasure20 ?? "",
        ]
    }
}
