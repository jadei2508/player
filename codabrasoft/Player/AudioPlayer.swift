//
//  AudioPlayer.swift
//  codabrasoft
//
//  Created by Roman Alikevich on 10.06.2021.
//

import UIKit
import AVKit

class AudioPlayer {
    private var player: AVAudioPlayer?
    private var sliderTime: Float = 0.0
    private var timeBuffer: Timer?
    
    var updateTime: ((TimeInterval?)->())?
    
    func playByName(trackName: URL) {
        DispatchQueue.global(qos: .background).async {
            do {
                print("track:\(trackName)")
                self.player = try AVAudioPlayer(contentsOf: trackName, fileTypeHint: AVFileType.mp3.rawValue)
                self.player?.volume = 1.0
                self.player?.currentTime = TimeInterval(self.sliderTime)
                self.player?.prepareToPlay()
                self.player?.play()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getPlayerUrl() -> URL? {
        return player?.url
    }
    
    func getCurrentTime() -> TimeInterval? {
        return player?.currentTime
    }
    
    func audioTimeControl(complition: @escaping(_ time: TimeInterval?) -> ()) {
        self.player?.stop()
        complition(self.player?.duration)
    }
    
    func getPlayerDuration() -> TimeInterval? {
        return self.player?.duration
    }
    
    func continuePlay() {
        self.player?.play()
    }
    
    func setCurrentTime(currentTime: Float) {
        self.player?.currentTime = TimeInterval(currentTime)
    }
    
    func setSliderTime(sliderTime: Float) {
        self.sliderTime = sliderTime
    }
   
    func pause() {
        player?.pause()
    }
}

