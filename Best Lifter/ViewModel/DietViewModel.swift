//
//  DietViewModel.swift
//  Best Lifter
//
//  Created by 피수영 on 2021/05/12.
//

import SwiftUI

class DietViewModel: ObservableObject {
    var dailyDiet: DailyDiet
    
    var userDailyCalorie: Int {
        didSet {
            UserDefaults.standard.setValue(userDailyCalorie, forKey: "userDailyCalorie")
        }
    }
    
    var userDailyCarbs: Int {
        didSet {
            UserDefaults.standard.setValue(userDailyCarbs, forKey: "userDailyCarbs")
        }
    }
    
    var userDailyProteins: Int {
        didSet {
            UserDefaults.standard.setValue(userDailyProteins, forKey: "userDailyProteins")
        }
    }
    
    var userDailyFats: Int {
        didSet {
            UserDefaults.standard.setValue(userDailyFats, forKey: "userDailyFats")
        }
    }
    
    var userCalorieTaked: Int {
        didSet {
            UserDefaults.standard.setValue(userCalorieTaked, forKey: "userCalorieTaked")
        }
    }
    
    var userCarbTaked: Int {
        didSet {
            UserDefaults.standard.setValue(userCarbTaked, forKey: "userCarbTaked")
        }
    }
    
    var userProteinTaked: Int {
        didSet {
            UserDefaults.standard.setValue(userProteinTaked, forKey: "userProteinTaked")
        }
    }
    
    var userFatTaked: Int {
        didSet {
            UserDefaults.standard.setValue(userFatTaked, forKey: "userFatTaked")
        }
    }
    
    @Published var bodyWeights = [Double]()
    @Published var bodyWeightsDate = [Date]()
    @Published var totalCalories = [Double]()
    @Published var calorieCGFloat: CGFloat = 0.0
    @Published var carbCGFloat: CGFloat = 0.0
    @Published var proteinCGFloat: CGFloat = 0.0
    @Published var fatCGFloat: CGFloat = 0.0
    
    init() {
        self.userDailyCalorie = UserDefaults.standard.object(forKey: "userDailyCalorie") as? Int ?? 0
        self.userDailyCarbs = UserDefaults.standard.object(forKey: "userDailyCarbs") as? Int ?? 0
        self.userDailyProteins = UserDefaults.standard.object(forKey: "userDailyProteins") as? Int ?? 0
        self.userDailyFats = UserDefaults.standard.object(forKey: "userDailyFats") as? Int ?? 0
        self.userCalorieTaked = UserDefaults.standard.object(forKey: "userCalorieTaked") as? Int ?? 0
        self.userCarbTaked = UserDefaults.standard.object(forKey: "userCarbTaked") as? Int ?? 0
        self.userProteinTaked = UserDefaults.standard.object(forKey: "userProteinTaked") as? Int ?? 0
        self.userFatTaked = UserDefaults.standard.object(forKey: "userFatTaked") as? Int ?? 0
        self.dailyDiet = DailyDiet(date: Date())
        self.bodyWeights = setBodyWeights()
        self.bodyWeightsDate = setBodyWeightsDate()
    }
    
    
    
    func setTakedProperteisToZero() {
        self.userCalorieTaked = 0
        self.userCarbTaked = 0
        self.userProteinTaked = 0
        self.userFatTaked = 0
    }
    
    func setNutritionCGFloat() {
        if userDailyCalorie != 0 {
            let calorieTaked = Float(userCalorieTaked)
            let dailyCalorie = Float(userDailyCalorie)
            let caloriePercentage = calorieTaked / dailyCalorie
            
            self.calorieCGFloat = CGFloat(caloriePercentage)
        }
        
        if userDailyCarbs != 0 {
            let carbTaked = Float(userCarbTaked)
            let dailyCarb = Float(userDailyCarbs)
            let carbPercentage = carbTaked / dailyCarb
            
            self.carbCGFloat = CGFloat(carbPercentage)
        }
        
        if userDailyProteins != 0 {
            let proteinTaked = Float(userCarbTaked)
            let dailyProteins = Float(userDailyProteins)
            let proteinPercentage = proteinTaked / dailyProteins
            
            self.proteinCGFloat = CGFloat(proteinPercentage)
        }
        
        if userDailyFats != 0 {
            let fatTaked = Float(userFatTaked)
            let dailyFat = Float(userDailyFats)
            let fatPercentage = fatTaked / dailyFat
            
            self.fatCGFloat = CGFloat(fatPercentage)
        }
    }
    
    func setUserNutritionInfo(calorie: String, carbs: String, proteins: String, fats: String) {
        if let calorie = Int(calorie), let carbs = Int(carbs), let proteins = Int(proteins), let fats = Int(fats) {
            self.userDailyCalorie = calorie
            self.userDailyCarbs = carbs
            self.userDailyProteins = proteins
            self.userDailyFats = fats
        }
    }
    
    func setBodyWeights() -> [Double] {
        var bodyWeights = [Double]()
        for bodyWeight in CoreDataManager.shared.bodyWeights {
            bodyWeights.append(bodyWeight.weight)
        }
        
        return bodyWeights
    }
    
    func setBodyWeightsDate() -> [Date] {
        var bodyWeightsDate = [Date]()
        for bodyWeight in CoreDataManager.shared.bodyWeights {
            if let date = bodyWeight.date {
                bodyWeightsDate.append(date)
            }
        }
        
        return bodyWeightsDate
    }
    
    func addBodyWeights(weight: Double, profileViewModel: ProfileViewModel) {
        CoreDataManager.shared.addBodyWeight(weight: weight)
        
        profileViewModel.userWeightStr = "\(weight)"
        profileViewModel.getWilksPoint()
        self.bodyWeights = setBodyWeights()
        self.bodyWeightsDate = setBodyWeightsDate()
    }
    
    func nutiritionRate(name: String) -> CGFloat {
        switch name {
        case "calorie":
            return self.calorieCGFloat
        case "carb":
            return self.carbCGFloat
        case "protein":
            return self.proteinCGFloat
        case "fat":
            return self.fatCGFloat
        default:
            return CGFloat(0.0)
        }
    }
}

//struct Transaction {
//    var year: Int
//    var month: Double
//    var quantity: Double
//
//    static func dataEntriesForYear(_ year: Int, transactions: [Transaction]) -> [BarChartDataEntry] {
//        let yeearTransactions = transactions.filter{ $0.year == year }
//        return yeearTransactions.map{ BarChartDataEntry(x: $0.month, y: $0.quantity)}
//    }
//
//    static var allTrasactions: [Transaction] {
//        [
//            Transaction(year: 2021, month: 1, quantity: 80),
//            Transaction(year: 2021, month: 2, quantity: 77),
//            Transaction(year: 2021, month: 3, quantity: 66),
//            Transaction(year: 2021, month: 4, quantity: 15),
//            Transaction(year: 2021, month: 5, quantity: 76),
//            Transaction(year: 2021, month: 6, quantity: 85),
//            Transaction(year: 2021, month: 7, quantity: 81)
//        ]
//    }
//}
//
//
//struct TransactionBarChartView: UIViewRepresentable {
//    let entries: [BarChartDataEntry]
//
//    func makeUIView(context: Context) -> BarChartView {
//        return BarChartView()
//    }
//
//    func updateUIView(_ uiView: BarChartView, context: Context) {
//        let dataSet = BarChartDataSet(entries: entries)
//        dataSet.label = "Transaction"
//        uiView.noDataText = "No data"
//        uiView.data = BarChartData(dataSet: dataSet)
//        formatDataSet(dataSet: dataSet)
//    }
//
//    func formatDataSet(dataSet: BarChartDataSet) {
//        dataSet.colors = [.black]
//        dataSet.valueColors = [.white]
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .none
//        dataSet.valueFormatter = DefaultValueFormatter(formatter: formatter)
//    }
//}
//
//struct TransactionBarChartView_PreViews: PreviewProvider {
//    static var previews: some View {
//        TransactionBarChartView(entries: Transaction.dataEntriesForYear(2021, transactions: Transaction.allTrasactions))
//    }
//}
