//
//  OnWorkoutViewModel.swift
//  Best Lifter
//
//  Created by 피수영 on 2021/05/03.
//

import Foundation
import Combine

class OnWorkoutViewModel: ObservableObject {
    // 로컬 디비 구축 필요
    @Published var program: Routine
    var selectedWorkout: String = ""
    let workouts = ["Bench Press", "Overhead Press", "Squat", "Deadlift", "Pull Up", "Dips", "Barbell Row", "Lunge", "Shoulder Press", "Side Lateral Raise"]
    
    // Timer Variables
    @Published var timerString: String = "00:00"
    private var cancellable: AnyCancellable!
    private var onWorkoutTimerModel = OnworkoutTimerModel(timeInterval: 1)
    var totalWeight: Int
    var totalVolume: Int
    
    init() {
        self.program = Routine(name: "운동", date: "")
        self.totalWeight = 0
        self.totalVolume = 0
        cancellable = onWorkoutTimerModel.$timeString
            .map({$0.description})
            .assign(to: \OnWorkoutViewModel.timerString, on: self)
    }
    
    func setDate() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        program.date = formatter.string(from: date)
    }
}


// MARK: Get/Set Workout Methods
extension OnWorkoutViewModel {
    func getWorkouts() -> [Excercise] {
        return program.excercises
    }
    
    func getWorkoutSet(name: String) -> [Set] {
        let set: [Set] = []
        
        for i in self.program.excercises {
            if i.name == name {
                return i.sets
            }
        }
        
        return set
    }
    
    func addWorkout(name: String) {
        let id = WorkoutID.init(rawValue: name)?.toInt() ?? 0
        let newExcercise = Excercise(id: id, name: name, sets: [Set]())
        
        for i in program.excercises {
            if i.id == id {
                return
            }
        }
        
        self.program.excercises.append(newExcercise)
    }
    
    func addSet(name: String, reps: Int, weight: Double) {
        for i in 0..<program.excercises.count {
            if program.excercises[i].name == name {
                program.excercises[i].addSet(name: name, reps: reps, weight: weight)
                break
            }
        }
    }
    
    func deleteSet(id: Int, name: String) {
        for i in 0..<program.excercises.count {
            if program.excercises[i].name == name {
                program.excercises[i].removeSet(id: id)
                break
            }
        }
    }
    
    func refreshSetNum(name: String) {
        for i in 0..<program.excercises.count {
            if program.excercises[i].name == name {
                program.excercises[i].refreshSetNum()
                break
            }
        }
    }
    
    func getSets(name: String) -> [Set] {
        var sets = [Set]()
        for i in program.excercises {
            if i.name == name {
                sets = i.sets
                break
            }
        }
        
        return sets
    }
    
    func saveBestSet() {
        let benchPress = getSets(name: "Bench Press")
        let squat = getSets(name: "Squat")
        let deadlift = getSets(name: "Deadlift")
        
        if !benchPress.isEmpty {
            let benchPressMaxWeight = benchPress.max { $0.weight < $1.weight }!.weight
            CoreDataManager.shared.addBenchPressRecord(weight: benchPressMaxWeight)
        }
        
        if !squat.isEmpty {
            let squatMaxWeight = squat.max { $0.weight < $1.weight }!.weight
            CoreDataManager.shared.addSquatRecord(weight: squatMaxWeight)
            
        }
        
        if !deadlift.isEmpty {
            let deadliftMaxWeight = deadlift.max { $0.weight < $1.weight }!.weight
            CoreDataManager.shared.addDeadliftRecord(weight: deadliftMaxWeight)
        }
    }
    
    func modifySetRepsAndWeights(name: String, setNum: Int, weight: Double, reps: Int) {
        for index in 0..<program.excercises.count {
            if program.excercises[index].name == name {
                program.excercises[index].sets[setNum].modifySet(weight: weight, reps: reps)
                return
            }
        }
    }
}


// MARK: Timer Methods
extension OnWorkoutViewModel {
    func timerStart() {
        onWorkoutTimerModel.start()
    }
}
