//
//  AudioTimer.swift
//  codabrasoft
//
//  Created by Roman Alikevich on 15.06.2021.
//

import UIKit

class AudioTimer {
    private let timerFormat = "%02i:%02i"
    private let timerDivider = 60
    private let timerInterval = 0.1
    private var timeBuffer: Timer?
    
    var updateTime: (()->())?
    
    func play() {
        timeBuffer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(self.updateTimeValue), userInfo: nil, repeats: true)
    }
    
    func pauseTimer() {
        timeBuffer?.invalidate()
    }
    
    func continuesTimer() {
        timeBuffer?.fire()
    }
    
    @objc func updateTimeValue() {
        updateTime?()
    }
    
    func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / timerDivider % timerDivider
        let seconds = Int(time) % timerDivider
        return String(format:timerFormat, minutes, seconds)
    }
}
