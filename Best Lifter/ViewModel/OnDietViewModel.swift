//
//  OnDietViewModel.swift
//  Best Lifter
//
//  Created by 피수영 on 2021/05/10.
//

import Foundation
import SwiftUI

class OnDietViewModel: ObservableObject {
    let dietButtons = ["사진 입력", "직접 입력", "취소"]
    let imagePickerController = UIImagePickerController()
    lazy var selectedButton: String = String()
    var pickedImage: Image?
    var selectedFoodLabel: String?
    var mealTime: Int = Int()
    var foodInfo: FoodNutrientInfo?
    
    @Published var meals = DailyDiet(date: Date())
    @Published var predictedLables = [String]()
    @Published var mealTimeString: String = "끼니"
    
    var calorie = 0
    var carb = 0
    var protein = 0
    var fat = 0
    
    init() {
        
    }
    
    func setNutritionToZero() {
        self.calorie = 0
        self.carb = 0
        self.protein = 0
        self.fat = 0
    }
    
    func setMealTime(mealTime: Int) {
        switch mealTime {
        case 1:
            self.mealTimeString = "아침"
        case 2:
            self.mealTimeString = "점심"
        case 3:
            self.mealTimeString = "저녁"
        default:
            break
        }
    }
    
    func seperateParsedDietString(dailyDiet: String) -> [[String]] {
        let seperatedDailyDietByNewLine = dailyDiet.components(separatedBy: "\n")
        var seperatedDailyDietByBlankSpace = [[String]]()
        
        for index in 0..<seperatedDailyDietByNewLine.count {
            let compoents = seperatedDailyDietByNewLine[index].components(separatedBy: " ")
            seperatedDailyDietByBlankSpace[index] = compoents
        }
        
        return seperatedDailyDietByBlankSpace
    }
    
    func addFood(mealTime: String, name: String, calorie: String, carb: String, protein: String, fat: String) {
        if let calorie = Float(calorie), let carb = Float(carb), let protein = Float(protein), let fat = Float(fat) {
            meals.addFoodToMeal(mealTime: mealTime, name: name, calorie: calorie, carb: carb, protein: protein, fat: fat)
            
            self.calorie = Int(calorie)
            self.carb = Int(carb)
            self.protein = Int(protein)
            self.fat = Int(fat)
            
            
        } else {
            print("Can't add food")
        }
    }
    
    func sendImageToPredictServer(image: UIImage) {
//        guard let foodPredictionLabels = Network.shared.sendImageToPredictServer(image: image) else { return }
        
        Network.shared.sendImageToPredictServer(image: image) { foodPredictionLables in
            self.predictedLables = foodPredictionLables.data
        }
    }
    
    func sendFoodNameToDBServer(foodName: String) {
//        guard let foodPredictionLabels = Network.shared.sendImageToPredictServer(image: image) else { return }
        
        Network.shared.sendFoodNameToDBServer(foodName: foodName) { foodInfo in
            self.foodInfo = foodInfo
            
            print(foodInfo)
            
            if let foodInfo = foodInfo.data {
                self.addFood(mealTime: "점심", name: foodInfo.name ?? "",
                        calorie: String(foodInfo.calorie ?? 0),
                        carb: String(foodInfo.carbohydrate ?? 0),
                        protein: String(foodInfo.protein ?? 0),
                        fat: String(foodInfo.fat ?? 0))
                
                self.calorie = foodInfo.calorie ?? 0
                self.carb = foodInfo.carbohydrate ?? 0
                self.protein = foodInfo.protein ?? 0
                self.fat = foodInfo.fat ?? 0
            }
        }
        
        
        
//        print(foodInfo)
    }
    
    @ViewBuilder
    func checkSelectedButton(isSubView: Binding<Bool>, isAddDiet: Binding<Bool>, onDietViewModel: OnDietViewModel, dietViewModel: DietViewModel) -> some View {
        // 각각 뷰를 선언한다.
        if selectedButton == "사진 입력" {
            AddDietByPhoto(onDietViewModel: onDietViewModel, dietViewModel: dietViewModel)
        } else if selectedButton == "직접 입력" {
            AddDietByUserInput(onDietViewModel: onDietViewModel, dietViewModel: dietViewModel)
        }
    }
}
