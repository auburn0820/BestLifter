//
//  ProfileLogic.swift
//  Best Lifter
//
//  Created by 피수영 on 2021/05/01.
//

import Foundation
import Combine

final class ProfileViewModel: ObservableObject, Identifiable {
    @Published var userRegistered: Bool {
        didSet {
            UserDefaults.standard.setValue(userRegistered, forKey: "userRegistered")
        }
    }
    @Published var name: String {
        didSet {
            UserDefaults.standard.setValue(name, forKey: "name")
        }
    }
    @Published var squatWeightsStr: String {
        didSet {
            UserDefaults.standard.setValue(squatWeightsStr, forKey: "squatWeightsStr")
        }
    }
    @Published var benchPressWeightsStr: String {
        didSet {
            UserDefaults.standard.setValue(benchPressWeightsStr, forKey: "benchPressWeightsStr")
        }
    }
    @Published var deadliftWeightsStr: String {
        didSet {
            UserDefaults.standard.setValue(deadliftWeightsStr, forKey: "deadliftWeightsStr")
        }
    }
    @Published var userWeightStr: String {
        didSet {
            UserDefaults.standard.setValue(userWeightStr, forKey: "userWeightStr")
        }
    }
    @Published var wilksPoint: String {
        didSet {
            UserDefaults.standard.setValue(wilksPoint, forKey: "wilksPoint")
        }
    }
    @Published var gender: Int {
        didSet {
            UserDefaults.standard.setValue(gender, forKey: "gender")
        }
    }
    @Published var genderString: String = ""
    
    init() {
        self.userRegistered = UserDefaults.standard.object(forKey: "userRegistered") as? Bool ?? false
        self.gender = UserDefaults.standard.object(forKey: "gender") as? Int ?? 0
        self.name = UserDefaults.standard.object(forKey: "name") as? String ?? ""
        self.squatWeightsStr = UserDefaults.standard.object(forKey: "squatWeightsStr") as? String ?? ""
        self.benchPressWeightsStr = UserDefaults.standard.object(forKey: "benchPressWeightsStr") as? String ?? ""
        self.deadliftWeightsStr = UserDefaults.standard.object(forKey: "deadliftWeightsStr") as? String ?? ""
        self.userWeightStr = UserDefaults.standard.object(forKey: "userWeightStr") as? String ?? ""
        self.wilksPoint = UserDefaults.standard.object(forKey: "wilksPoint") as? String ?? ""
        self.setGenderString()
    }
    
    func updateSBDWeights() {
        if let benchPressMaxWeight = CoreDataManager.shared.benchPressWeights.max(by: {$0.weight < $1.weight }) {
            if benchPressMaxWeight.weight > Double(self.benchPressWeightsStr)! {
                self.benchPressWeightsStr = String(format: "%.1f", benchPressMaxWeight.weight)
            }
        }
        
        if let squatMaxWeight = CoreDataManager.shared.squatWeights.max(by: {$0.weight < $1.weight }) {
            if squatMaxWeight.weight > Double(self.squatWeightsStr)! {
                self.squatWeightsStr = String(format: "%.1f", squatMaxWeight.weight)
            }
        }
        
        if let deadliftMaxWeight = CoreDataManager.shared.deadliftWeights.max(by: { $0.weight < $1.weight }) {
            if deadliftMaxWeight.weight > Double(self.benchPressWeightsStr)! {
                self.deadliftWeightsStr = String(format: "%.1f", deadliftMaxWeight.weight)
            }
        }
        
        getWilksPoint()
    }
    
    func setGenderString() {
        if gender == 1 {
            genderString = "남성"
        } else if gender == 2 {
            genderString = "여성"
        } else {
            genderString = "성별"
        }
    }
    
    func getWilksPoint() {
        let squatWeights = Double(self.squatWeightsStr) ?? 1
        let benchPressWeights = Double(self.benchPressWeightsStr) ?? 1
        let deadliftWeights = Double(self.deadliftWeightsStr) ?? 1
        let weights = (squatWeights + benchPressWeights + deadliftWeights) * 500
        let userWeightVal = Double(self.userWeightStr) ?? 1
        
        var results: Double = 0
        
        if gender == 1 {
            let a = -216.0475144
            let b = 16.2606339
            let c = -0.00113732
            let d = -0.00113732
            let e = 7.01863E-06
            let f = -1.291E-08
            
            let div1 = a + b * userWeightVal
            let div2 = c * pow(userWeightVal, 2)
            let div3 = d * pow(userWeightVal, 3)
            let div4 = e * pow(userWeightVal, 4)
            let div5 = f * pow(userWeightVal, 5)
            let divider = div1 + div2 + div3 + div4 + div5
            
            results = Double(weights / divider)
        } else if gender == 2 {
            let a = 594.31747775582
            let b = -27.23842536447
            let c = 0.82112226871
            let d = -0.00930733913
            let e = 4.731582E-05
            let f = -9.054E-08
            
            let div1 = a + b * userWeightVal
            let div2 = c * pow(userWeightVal, 2)
            let div3 = d * pow(userWeightVal, 3)
            let div4 = e * pow(userWeightVal, 4)
            let div5 = f * pow(userWeightVal, 5)
            let divider = div1 + div2 + div3 + div4 + div5
            
            results = Double(weights / divider)
        }
        
        self.wilksPoint = String(format: "%.2f", results)
    }
}
