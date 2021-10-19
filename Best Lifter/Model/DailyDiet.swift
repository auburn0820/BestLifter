//
//  Diet.swift
//  Best Lifter
//
//  Created by 피수영 on 2021/05/28.
//

import Foundation

struct Food {
    var name: String
    var calorie: Float
    var carb: Float
    var protein: Float
    var fat: Float
    
    init(name: String, calorie: Float, carb: Float, protein: Float, fat: Float) {
        self.name = name
        self.calorie = calorie
        self.carb = carb
        self.protein = protein
        self.fat = fat
    }
}

struct Meal {
    var mealTime: String
    var calories: Float
    var carbs: Float
    var proteins: Float
    var fats: Float
    var foodsParsedStringInMeal: String
    var foods: [Food]
    
    init(mealTime: String) {
        self.mealTime = mealTime
        self.calories = Float()
        self.carbs = Float()
        self.proteins = Float()
        self.fats = Float()
        self.foodsParsedStringInMeal = String()
        self.foods = [Food]()
    }
    
    mutating func parseFoodStringInMeal() {
        for food in foods {
            foodsParsedStringInMeal.append("\(mealTime) \(food.name) \(food.calorie) \(food.carb) \(food.protein) \(food.fat)\n")
        }
    }
    
    mutating func addFood(name: String, calorie: Float, carb: Float, protein: Float, fat: Float) {
        foods.append(Food(name: name, calorie: calorie, carb: carb, protein: protein, fat: fat))
        
        calories += calorie
        carbs += carb
        proteins += protein
        fats += fat
    }
    
    func getFoodsParsedStringInMeal() -> String {
        return foodsParsedStringInMeal
    }
    
    func getFoods() -> [Food] {
        return foods
    }
}

struct DailyDiet {
    var date: Date
    var calories: Float
    var carbs: Float
    var proteins: Float
    var fats: Float
    var foodsParsedStringInDailyDiet: String
    var meals: [Meal] = [Meal(mealTime: "아침"), Meal(mealTime: "점심"), Meal(mealTime: "저녁")]
    
    init(date: Date) {
        self.date = date
        self.calories = 0
        self.carbs = 0
        self.proteins = 0
        self.fats = 0
        self.foodsParsedStringInDailyDiet = String()
    }
    
    mutating func addFoodToMeal(mealTime: String, name: String, calorie: Float, carb: Float, protein: Float, fat: Float) {
        switch mealTime {
        case "아침":
            meals[0].addFood(name: name, calorie: calorie, carb: carb, protein: protein, fat: fat)
            break
        case "점심":
            meals[1].addFood(name: name, calorie: calorie, carb: carb, protein: protein, fat: fat)
            break
        case "저녁":
            meals[2].addFood(name: name, calorie: calorie, carb: carb, protein: protein, fat: fat)
            break
        default:
            break
        }
        
        self.calories += Float(calorie)
        self.carbs += Float(carb)
        self.proteins += Float(protein)
        self.fats += Float(fat)
    }
    
    func parseDailyDiet(meal: Meal) -> String{
        return meal.foodsParsedStringInMeal
    }
    
    mutating func addMeal(mealTime: String) {
        meals.append(Meal(mealTime: mealTime))
    }
    
    func getNutritions() -> Self {
        return self
    }
    
    func getCarbs() -> Float {
        return self.carbs
    }
    
    func getProteins() -> Float {
        return self.proteins
    }
    
    func getFats() -> Float {
        return self.fats
    }
}
