//
//  CoreDataManager.swift
//  Best Lifter
//
//  Created by 피수영 on 2021/05/24.
//

import Foundation
import CoreData

class CoreDataManager: ObservableObject {
    static let shared = CoreDataManager()
    let container: NSPersistentContainer
    @Published var routines: [Program] = []
    @Published var diets: [DailyDietMeal] = []
    @Published var bodyWeights: [BodyWeight] = []
    @Published var benchPressWeights: [BenchPress] = []
    @Published var squatWeights: [Squat] = []
    @Published var deadliftWeights: [Deadlift] = []
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Best_Lifter")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error loading core data. \(error.localizedDescription)")
            } else {
                print("Successfully loaded core data.")
            }
        }
        fetchRoutines()
        fetchDailyDiet()
        fetchBodyWeights()
        fetchSquatRecord()
        fetchBenchPressRecord()
        fetchDeadliftRecord()
    }
    
    func fetchBodyWeights() {
        let request = NSFetchRequest<BodyWeight>(entityName: "BodyWeight")
        
        do {
            bodyWeights = try container.viewContext.fetch(request)
        } catch {
            print("Error body weights fetching. \(error.localizedDescription)")
        }
    }
    
    func saveBodyWeights() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
                fetchBodyWeights()
            } catch {
                print("Error bench press record saving. \(error.localizedDescription)")
            }
        }
    }
    
    func addBodyWeight(weight: Double) {
        let newBodyWeight = BodyWeight(context: container.viewContext)
        newBodyWeight.weight = weight
        newBodyWeight.date = Date()
        
        saveBodyWeights()
    }
    
    func fetchBenchPressRecord() {
        let benchPressRecordRequest = NSFetchRequest<BenchPress>(entityName: "BenchPress")
        
        do {
            benchPressWeights = try container.viewContext.fetch(benchPressRecordRequest)
        } catch {
            print("Error SBD records fetching. \(error.localizedDescription)")
        }
    }
    
    func fetchSquatRecord() {
        let squatRecordRequest = NSFetchRequest<Squat>(entityName: "Squat")
        
        do {
            squatWeights = try container.viewContext.fetch(squatRecordRequest)
        } catch {
            print("Error SBD records fetching. \(error.localizedDescription)")
        }
    }
    
    func fetchDeadliftRecord() {
        let deadliftRecordRequest = NSFetchRequest<Deadlift>(entityName: "Deadlift")
        
        do {
            deadliftWeights = try container.viewContext.fetch(deadliftRecordRequest)
        } catch {
            print("Error SBD records fetching. \(error.localizedDescription)")
        }
    }
    
    func saveBenchPressRecord() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
                fetchBenchPressRecord()
            } catch {
                print("Error bench press record saving. \(error.localizedDescription)")
            }
        }
    }
    
    func addWeightsAndDatesToArr(returnArr: inout [WorkoutRecord], weights: [Double], dates: [Date]) {
        for index in 0..<weights.count {
            returnArr.append(WorkoutRecord(weight: weights[index], date: dates[index]))
        }
    }
    
    func getWorkoutRecords(workoutName: String) -> [WorkoutRecord] {
        var returnArr = [WorkoutRecord]()
        print(workoutName)
        if workoutName == "Bench Press" {
            let weights = getBenchPressWeightsArr()
            let dates = getBenchPressDateArr()
            addWeightsAndDatesToArr(returnArr: &returnArr, weights: weights, dates: dates)
        } else if workoutName == "Squat" {
            let weights = getSquatWeightsArr()
            let dates = getSquatDateArr()
            addWeightsAndDatesToArr(returnArr: &returnArr, weights: weights, dates: dates)
        } else {
            let weights = getDeadliftWeightsArr()
            let dates = getDeadliftDateArr()
            addWeightsAndDatesToArr(returnArr: &returnArr, weights: weights, dates: dates)
        }
        
        return returnArr
    }
    
    func getBenchPressDateArr() -> [Date] {
        var returnArr = [Date]()
        
        for benchPressDate in benchPressWeights {
            if let date = benchPressDate.date {
                returnArr.append(date)
            }
        }
        
        return returnArr
    }
    
    func getSquatDateArr() -> [Date] {
        var returnArr = [Date]()
        
        for squatDate in squatWeights {
            if let date = squatDate .date {
                returnArr.append(date)
            }
        }
        
        return returnArr
    }
    
    func getDeadliftDateArr() -> [Date] {
        var returnArr = [Date]()
        
        for deadliftDate in deadliftWeights {
            if let date = deadliftDate.date {
                returnArr.append(date)
            }
        }
        
        return returnArr
    }
    
    func getBenchPressWeightsArr() -> [Double] {
        var returnArr = [Double]()
        
        for benchPress in benchPressWeights {
            returnArr.append(benchPress.weight)
        }
        
        return returnArr
    }
    
    func getSquatWeightsArr() -> [Double] {
        var returnArr = [Double]()
        
        for squat in squatWeights {
            returnArr.append(squat.weight)
        }
        
        return returnArr
    }
    
    func getDeadliftWeightsArr() -> [Double] {
        var returnArr = [Double]()
        
        for deadlift in deadliftWeights {
            returnArr.append(deadlift.weight)
        }
        
        return returnArr
    }
    
    func saveSquatRecord() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
                fetchSquatRecord()
            } catch {
                print("Error squat record saving. \(error.localizedDescription)")
            }
        }
    }
    
    func saveDeadliftRecord() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
                fetchDeadliftRecord()
            } catch {
                print("Error deadlift record saving. \(error.localizedDescription)")
            }
        }
    }
    
    func addBenchPressRecord(weight: Double) {
        let newBenchPressRecord = BenchPress(context: container.viewContext)
        newBenchPressRecord.weight = weight
        newBenchPressRecord.date = Date()
        
        saveBenchPressRecord()
    }
    
    func addSquatRecord(weight: Double) {
        let newSquatRecord = Squat(context: container.viewContext)
        newSquatRecord.weight = weight
        newSquatRecord.date = Date()
        
        saveSquatRecord()
    }
    
    func addDeadliftRecord(weight: Double) {
        let newDeadliftRecord = Deadlift(context: container.viewContext)
        newDeadliftRecord.weight = weight
        newDeadliftRecord.date = Date()
        
        saveDeadliftRecord()
    }
    
    /*
     Relative with Program
     */
    func fetchRoutines() {
        let request = NSFetchRequest<Program>(entityName: "Program")
        
        do {
            routines = try container.viewContext.fetch(request)
        } catch {
            print("Error routines fetching. \(error.localizedDescription)")
        }
    }
    
    func saveRoutines() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
                fetchRoutines()
            } catch {
                print("Error routines saving. \(error.localizedDescription)")
            }
        }
    }
    
    func addRoutine(totalWeight: Int, excercises: [Excercise]) {
        let newRoutine = Program(context: container.viewContext)
        newRoutine.date = Date()
        newRoutine.total_weight = Int16(totalWeight)
        newRoutine.routine = parseRoutine(excercises: excercises)
        
        saveRoutines()
    }
    
    func parseRoutine(excercises: [Excercise]) -> String {
        var parsedRoutine: String = ""
        for i in excercises {
            parsedRoutine.append("\n\(i.name)|\(getExcerciseMaxWeightSet(sets: i.sets))")
        }
        
        return parsedRoutine
    }
    
    func getExcerciseMaxWeightSet(sets: [Set]) -> Double {
        let maxSetWeight = sets.map { $0.weight }.max() ?? 0.0
        
        return maxSetWeight
    }
    
    func deleteRoutine(offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let routine = routines[index]
        container.viewContext.delete(routine)
        saveRoutines()
    }
    
    func deleteRoutinesAll() {
        routines.removeAll()
    }
    
    /*
     Relative with DailyDiet
     */
    
    func fetchDailyDiet() {
        let request = NSFetchRequest<DailyDietMeal>(entityName: "DailyDietMeal")
        
        do {
            diets = try container.viewContext.fetch(request)
        } catch {
            print("Error diets fetching. \(error.localizedDescription)")
        }
    }
    
    func saveDailyDiet() {
        do {
            try container.viewContext.save()
            fetchDailyDiet()
        } catch {
            print("Error diets saving. \(error.localizedDescription)")
        }
    }
    
    func addDiet(foodsparsedStringInMeal: String) {
        let newDiet = DailyDietMeal(context: container.viewContext)
        newDiet.dailyDiet = foodsparsedStringInMeal
        saveDailyDiet()
    }
    
    func deleteDiet(offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let diet = diets[index]
        container.viewContext.delete(diet)
        saveDailyDiet()
    }
    
    func deleteDietsAll() {
        diets.removeAll()
        saveDailyDiet()
    }
}

struct WorkoutRecord {
    var weight: Double
    var date: Date
}
