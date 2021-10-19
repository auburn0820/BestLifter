//
//  OnworkoutModel.swift
//  Best Lifter
//
//  Created by 피수영 on 2021/05/07.
//

import Foundation
import Combine

class OnworkoutTimerModel {
    private let timeInterval: TimeInterval
    private var cancellableTimer: AnyCancellable!
    private var seconds = 0
    private var minutes = 0
    private var hours = 0
    @Published var timeString = "00:00"
    
    required init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    func start() {
        cancellableTimer = Timer.publish(every: timeInterval, on: RunLoop.main, in: .default)
            .autoconnect()
            .sink(receiveValue: { (_) in
                self.timeLogic()
            })
    }
    
    func stop() {
        seconds = 0
        minutes = 0
        hours = 0
        cancellableTimer?.cancel()
    }
    
    func timeLogic() {
        seconds += 1
        
        if seconds >= 60 {
            minutes += 1
            seconds = 0
        }
        
        if minutes >= 60 {
            hours += 1
            minutes = 0
        }
        
        let secondsString = seconds < 10 ? "0\(seconds)" : "\(seconds)"
        let minutesString = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        
        timeString = hours == 0 ? "\(minutesString):\(secondsString)" : "0\(hours):\(minutes):\(seconds)"
    }
}
