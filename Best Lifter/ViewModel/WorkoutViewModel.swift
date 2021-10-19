//
//  WorkoutViewModel.swift
//  Best Lifter
//
//  Created by 피수영 on 2021/05/27.
//

import Foundation
import UIKit

class WorkoutViewModel: ObservableObject {
    func formattingRoutineString(routine: String) -> [[String]] {
        let arrSeperatedByNewLine = routine.components(separatedBy: "\n")
        
        var seperatedArr = [[String]]()
        
        for i in 0..<arrSeperatedByNewLine.count {
            seperatedArr[i] = arrSeperatedByNewLine[i].components(separatedBy: " ")
        }
        
        return seperatedArr
    }
    
    func openVisionObjectTrack() {
        let url = "VisionTracker://"
        let visionObjectTrackURL = NSURL(string: url)!

        if UIApplication.shared.canOpenURL(visionObjectTrackURL as URL) {
            UIApplication.shared.open(visionObjectTrackURL as URL)
        }
    }
}
