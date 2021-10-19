//
//  MLModel.swift
//  Best Lifter
//
//  Created by 피수영 on 2021/05/28.
//

import Foundation

struct FoodPredictionLabels: Codable {
    var data: [String]
}

// {"data":{"id":31,"name":"김치찌개","serving":200.0,"calorie":91.0,"carbohydrate":2.0,"protein":8.0,"fat":5.0,"sugars":null,"salts":null},"status":"OK","code":200,"message":"영양정보"}
/*
 "id": 31,
         "name": "김치찌개",
         "serving": 200.0,
         "calorie": 91.0,
         "carbohydrate": 2.0,
         "protein": 8.0,
         "fat": 5.0,
         "sugars": null,
         "salts": null
 */
struct NutritionData: Codable {
    var calorie: Int?
    var carbohydrate: Int?
    var fat: Int?
    var id: Int?
    var name: String?
    var protein: Int?
    var salts: Int?
    var serving: Int?
    var sugars: Int?
}

struct FoodNutrientInfo: Codable {
    var code: Int
    var data: NutritionData?
    var message: String
    var status: String
}

struct UserData: Codable {
    var userName: String?
    var score: Double?
}

struct UserRank: Codable {
    var status: String?
    var code: Int?
    var data: [UserData]?
}

//struct UserInfo: Codable {
//
//}
