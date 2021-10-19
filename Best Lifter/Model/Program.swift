//
//  program.swift
//  Best Lifter
//
//  Created by 피수영 on 2021/04/30.
//

import Foundation
import CoreData

// 운동
// 프로그램

enum WorkoutID: String {
    case BenchPress = "Bench Press"
    case Deadlift = "Deadlift"
    case Squat = "Squat"
    case OverheadPress = "Overhead Press"
    case PullUp = "Pull Up"
    case BarbellRow = "Barbell Row"
    case Lunge = "Lunge"
    case Dips = "Dips"
    case ShoulderPress = "Shoulder Press"
    case SideLateralRaise = "Side Lateral Raise"
    
    func toString() -> String {
        return self.rawValue
    }
    
    func toInt() -> Int {
        switch self {
        case .Squat:
            return 0
        case .BenchPress:
            return 1;
        case .Deadlift:
            return 2
        case .BarbellRow:
            return 3
        case .Dips:
            return 4
        case .Lunge:
            return 5
        case .PullUp:
            return 6
        case .OverheadPress:
            return 7
        case .ShoulderPress:
            return 8
        case .SideLateralRaise:
            return 9
        }
    }
}

struct Set: Identifiable {
    // id is set number
    var id: Int
    var setNum: Int
    var reps: Int
    var weight: Double
    
    mutating func modifySet(weight: Double, reps: Int) {
        self.reps = reps
        self.weight = weight
    }
}

struct Excercise: Identifiable {
    var id: Int
    var name: String
    var sets: [Set]
    var idCount: Int = 0
    
    mutating func addSet(name: String, reps: Int, weight: Double) {
//        let id: Int? = WorkoutID.init(rawValue: name)?.toInt()
        
        
        print("Set number : \(sets.count + 1)")
        self.sets.append(Set(id: idCount, setNum: sets.count + 1, reps: reps, weight: weight))

        
        idCount += 1
    }
    
    mutating func removeSet(id: Int) {
        for i in 0..<sets.count {
            if sets[i].id == id {
                sets.remove(at: i)
                break
            }
        }
    }
    
    mutating func refreshSetNum() {
        for i in 0..<sets.count {
            sets[i].setNum = i + 1
        }
    }
}

struct Routine {
    var name: String
    var date: String
    var excercises: [Excercise]
    
    init(name: String, date: String) {
        self.name = name
        self.date = date
        self.excercises = [Excercise]()
    }
}
