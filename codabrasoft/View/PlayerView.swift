//
//  PlayerView.swift
//  codabrasoft
//
//  Created by Roman Alikevich on 06.06.2021.
//

import UIKit



class PlayerView: UITableViewHeaderFooterView, UIGestureRecognizerDelegate {
    
    //MARK:- IBOutlets -
    @IBOutlet private weak var playView: UIImageView!
    @IBOutlet private weak var slider: UISlider!
    @IBOutlet private weak var timer: UILabel!
    
    //MARK:- Closure -
    var headerAction: ((Float)->())?
    var switchPlayingMusic: ((Float)->())?
    
    //MARK:- Play state function -
    private enum PlayState {
        case nopePlay
        case play
        case pause
    }
    
    private var playState: PlayState = .nopePlay
    
    //MARK:- Set up play view -
    override func awakeFromNib() {
        super.awakeFromNib()
        setViewParams()
        addPlayViewGestureRecognizer()
        addSliderGestureRecognizer()
    }
    
    func initPlayView(sliderValue: Float, timer: String) {
        self.slider.value = sliderValue
        self.timer.text = timer
    }
    
    func setSliderValue(sliderValue: Float) {
        self.slider.value = sliderValue
    }
    
    func setSliderColor(color: UIColor) {
        self.slider.tintColor = color
    }
    
    func setUpSliderSize(time: Float) {
        slider.maximumValue = time
    }
    
    func setSlider(time: Float) {
        slider.value = time
    }
    
    //MARK:- Switch track active function -
    @objc func switchMusicActive(_ tapGestureRecognizer: UITapGestureRecognizer? = nil) {
        print("switchMusicActive")
        switchPlayingMusic?(slider.value)
    }
    
    //MARK:- Change play state function -
    func changePlayState() -> Bool {
        if playState == .nopePlay {
            guard let icon = UIImage(systemName: "pause.fill") else {
                return false
            }
            playView.image = icon
            playState = .pause
            return false
        } else if playState == .play {
            guard let icon = UIImage(systemName: "pause.fill") else {
                return false
            }
            playView.image = icon
            playState = .pause
            return false
        } else {
            guard let icon = UIImage(systemName: "play.fill") else {
                return false
            }
            playView.image = icon
            playState = .play
            return true
        }
    }
    
    //MARK:- player control function -
    @objc func tapHandler(_ tapGestureRecognizer: UITapGestureRecognizer? = nil) {
        headerAction?(slider.value)
    }
    
    func getSliderValue() -> Float {
        return slider.value
    }
}

//MARK:- Private functions -
private extension PlayerView {
    func setViewParams() {
        playView.backgroundColor = .clear
        playView.isUserInteractionEnabled = true
    }
    
    func addPlayViewGestureRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(switchMusicActive(_:)))
        playView.addGestureRecognizer(tapRecognizer)
    }
    
    func addSliderGestureRecognizer() {
        slider.addTarget(self, action: #selector(tapHandler(_:)), for: .valueChanged)
    }
}
