//
//  MusicCompositionView.swift
//  codabrasoft
//
//  Created by Roman Alikevich on 05.06.2021.
//

import UIKit
import Cartography

class MusicCompositionView: UITableViewCell {
    
    //MARK:- IBOutlets -
    @IBOutlet private weak var musicName: UILabel!
    @IBOutlet private weak var groupName: UILabel!
    @IBOutlet private weak var indicatorView: UIProgressView!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var loadingPercent: UILabel!
    
    //MARK:- Properties -
    private var musicConstraintIndent: CGFloat = 10
    private var musicHeightConstraintMultiply: CGFloat = 0.3
    private var musicLoadState = "load"
    private var musicCancelState = "cancel"
    private var musicPlayState = "play"
    private var musicPauseState = "pause"
    
    //MARK:- Properties -
    private var button: UIButton?
    var audioState: AudioState = .nopeLoading
    var musicState: MusicState = .start
 
    //MARK:- Closure -
    var startLoading: (()->())?
    var loadAudio: (()->())?
    
    //MARK:- Enter point -
    override func awakeFromNib() {
        super.awakeFromNib()
        hiddenButton()
        
        initElements()
        addViews()
        setupConstraints()
    }
    
    //MARK:- Init view -
    func initMusicView(name: String?, groupName: String?, loadingPercent: String? = "0.1%") {
        self.musicName.text = name
        self.groupName.text = groupName
        self.loadingPercent.text = loadingPercent
    }
    
    //MARK:- Update slider function -
    func updateLoadingPercent(loadingPercent: String) {
        self.loadingPercent.text = loadingPercent
    }
    
    //MARK:- Loading audio function -
    @objc func loadHandler(_ tapGestureRecognizer: UITapGestureRecognizer? = nil) {
        loadAudio!()
    }
    
    //MARK:- Hidden load button -
    func audioDidLoad() {
        startButton.isHidden = false
    }
    
    func setBaseAudioState() {
        audioState = .nopeLoading
    }
    
    func setBaseMusicState() {
        musicState = .suspend
    }
    
    func openButton() {
        startButton.isHidden = true
    }
    
    func addLoadButton() {
        initElements()
        addViews()
        setupConstraints()
    }
   
    //MARK:- Reject load function -
    func closeLoading(viewArray: [UIView]) {
        for view in viewArray {
            if type(of: view) == UIButton.self && !view.isHidden {
                view.removeFromSuperview()
            }
        }
    }
    
    //MARK:- Change button state function -
    func switchPlayButton() {
        var state: String = ""
        if musicState == .start {
            state = musicPlayState
            musicState = .suspend
        } else if musicState == .suspend {
            state = musicPauseState
            musicState = .start
        }
        guard let icon = UIImage(named: state) else {
            return
        }
        startButton.setImage(icon, for: .normal)
    }
    
    func changeButton() {
        var state = musicPlayState
        musicState = .suspend
        guard let icon = UIImage(named: state) else {
            return
        }
        startButton.setImage(icon, for: .normal)
    }
    
    //MARK:- Change button by state function -
    func changeButton(viewArray: [UIView]) {
        for view in viewArray {
            if type(of: view) == UIButton.self && !view.isHidden {
                var state: String = ""
                if audioState == .nopeLoading {
                    state = musicCancelState
                } else if audioState == .loading  {
                    state = musicLoadState
                } else {
                    state = musicCancelState
                }
                if let view = view as? UIButton {
                    guard let icon = UIImage(named: state) else {
                        return
                    }
                    view.setImage(icon, for: .normal)
                    print(view)
                }
            }
        }
    }
    
    @IBAction func startLoad(_ sender: Any) {
        startLoading?()
    }
    
    //MARK:- Keep loading state function -
    func transmissProgress(progress: Float) {
        indicatorView.progress = progress
    }
}

//MARK:- Private functions -
private extension MusicCompositionView {
    func initElements() {
        button = UIButton()
        guard let icon = UIImage(named: musicLoadState) else {
            return
        }
        button?.setImage(icon, for: .normal)
    }
    
    func addViews() {
        guard let button = button else {
            return
        }
        self.addSubview(button)
        let loadGesture = UITapGestureRecognizer(target: self, action: #selector(loadHandler(_:)))
        button.addGestureRecognizer(loadGesture)
    }
    
    func setupConstraints() {
        guard let button = button else {
            return
        }
        constrain(button, self) { button, view in
            button.centerY == view.centerY
            button.right == view.right - musicConstraintIndent
            button.height == view.height * musicHeightConstraintMultiply
            button.width == button.height
        }
    }
    
    func hiddenButton() {
        startButton.isHidden = true
    }
}
