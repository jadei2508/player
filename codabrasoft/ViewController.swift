//
//  ViewController.swift
//  codabrasoft
//
//  Created by Roman Alikevich on 05.06.2021.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    //MARK:- Properties -
    private let tableViewSectionNumber = 1
    private let tableViewMusicCellHeight: CGFloat = 80
    private let tableHeaderViewHeight: CGFloat = 180
    private let defaultSliderValue: Float = 0
    private let defaultSliderColor: UIColor = .red
    private let headerDequeueReusableIndex = "playerView"
    private let musicDequeueReusableIndex = "musicComposition"
    private let nibNameHeaderDequeueReusableIndex = "PlayerView"
    private let nibNameMusicDequeueReusableIndex = "MusicCompositionView"
    
    //MARK: - IBOutlets -
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK:- Properties -
    var networkManager: NetworkManager?
    var audioPlayer: AudioPlayer?
    var audioTimer: AudioTimer?
    var audioManager: AudioManager?
    var sliderTime: Float = 0.0
    var trackList: [Track]? = []
    var didSelectCellIndex = -1
    
    //MARK:- Closure -
    var changePlayingState: (()->())?
    var changePlayingStateBack: (()->())?
    
    //MARK: - Enter point -
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager = NetworkManager()
        audioPlayer = AudioPlayer()
        audioTimer = AudioTimer()
        audioManager = AudioManager()
        initTrackList()
        setUpTableView()
        findLoadedTrack()
    }
    
    func isLoadedTrack(index: Int) -> Bool {
        guard let name = trackList?[index].getName() else {
            return false
        }
        let fileManager = FileManager.default
        var url = audioManager?.getDirectoryUrl()
        url?.appendPathComponent(name)
        if let filePath = url?.path {
            if fileManager.fileExists(atPath: filePath) {
                return true
            }
        }
        return false
    }
    
    func findLoadedTrack() {
        guard let trackList = trackList else {
            return
        }
        let fileManager = FileManager.default
        for track in trackList {
            guard let name = track.getName() else {
                return
            }
            var url = audioManager?.getDirectoryUrl()
            url?.appendPathComponent(name)
            
            if let filePath = url?.path {
                if fileManager.fileExists(atPath: filePath) {
                    track.setIsDownloaded(isloaded: true)
                }
            }
        }
    }
    //MARK: - Init UITableView -
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: nibNameMusicDequeueReusableIndex, bundle: Bundle.main), forCellReuseIdentifier: musicDequeueReusableIndex)
        tableView.register(UINib(nibName: nibNameHeaderDequeueReusableIndex, bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: headerDequeueReusableIndex)
    }
}

//MARK: - TableView delegates -
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = trackList?.count else { return 0 }
        
        return count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewSectionNumber
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableHeaderViewHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewForHeader()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewMusicCellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellForRow(indexPath: indexPath)
    }
    
    @IBAction func unwind( _ segue: UIStoryboardSegue) {
        guard segue.identifier == "backToGeneral" else {return}
        trackList?[didSelectCellIndex].setIsDownloaded(isloaded: false)
        audioPlayer?.pause()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let isDownloaded = self.trackList?[indexPath.row].isDownloaded() else {
            return
        }
        if isDownloaded {
            didSelectCellIndex = indexPath.row
            self.performSegue(withIdentifier: "Second", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Second" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let name = trackList?[indexPath.row].getName(),
                  let currentTrack = trackList?[indexPath.row] else { return }
            let isDownloaded = self.trackList?[indexPath.row].isDownloaded()
            if currentTrack.isDownloaded() {
                let secondView = segue.destination as? SecondViewController
                guard var url = audioManager?.getDirectoryUrl() else {
                    return
                }
            
                url.appendPathComponent(name)
                secondView?.localURL = url
            }
        }
    }
}

//MARK: - Functions -
private extension ViewController {
    func initTrackList() {
        trackList?.append(Track(name: "Dont_Give_In.mp3", groupName: "Cro", url: "https://www.dropbox.com/s/3wpjswsxyj2dc2j/1.%20Don%27t%20Give%20In.mp3?dl=1"))
        trackList?.append(Track(name: "Drag_You_Under.mp3", groupName: "Cro", url: "https://www.dropbox.com/s/m9phefatwc10w5x/2.%20Drag%20You%20Under.mp3?dl=1"))
        trackList?.append(Track(name: "No_Ones_Victim.mp3", groupName: "Cro", url: "https://www.dropbox.com/s/bzo6d0u575vh8pe/3.%20No%20One%27s%20Victim.mp3?dl=1"))
        trackList?.append(Track(name: "From_the_Grave.mp3", groupName: "Cro", url: "https://www.dropbox.com/s/a1hsl8krjjfu5ie/4.%20From%20the%20Grave.mp3?dl=1"))
        trackList?.append(Track(name: "No_Ones_Coming.mp3", groupName: "Cro", url: "https://www.dropbox.com/s/650k4zes5xbxg3e/5.%20No%20One%27s%20Coming.mp3?dl=1"))
        trackList?.append(Track(name: "PTSD.mp3", groupName: "Cro", url: "https://www.dropbox.com/s/pvhzvr08f3ofgax/6.%20PTSD.mp3?dl=1"))
        trackList?.append(Track(name: "The_Final_Test.mp3", groupName: "Cro", url: "https://www.dropbox.com/s/pou31j3w2urgoap/7.%20The%20Final%20Test.mp3?dl=1"))
        trackList?.append(Track(name: "One_Bad_Decision.mp3", groupName: "Cro", url: "https://www.dropbox.com/s/qm0okz4fpyr1n5r/8.%20One%20Bad%20Decision.mp3?dl=1"))
        trackList?.append(Track(name: "Two_Hours.mp3", groupName: "Cro", url: "https://www.dropbox.com/s/4k01tffo5s3kt71/9.%20Two%20Hours.mp3?dl=1"))
        trackList?.append(Track(name: "Dont_Talk_About_It.mp3", groupName: "Cro", url: "https://www.dropbox.com/s/m8rw1erk2qn37pf/10.%20Don%27t%20Talk%20About%20It.mp3?dl=1"))
    }
    
    func viewForHeader() -> UITableViewHeaderFooterView {
        if let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerDequeueReusableIndex) as? PlayerView {
            cell.setSliderValue(sliderValue: defaultSliderValue)
            cell.setSliderColor(color: defaultSliderColor)
            
            changePlayingState = {
                cell.changePlayState()
            }
            
            changeSliderPlayingState(cell: cell)
            
            changePlayingStateByPlayerView(cell: cell)
            
            self.audioTimer?.updateTime = {
                if let duration = self.audioPlayer?.getPlayerDuration() {
                    cell.setUpSliderSize(time: Float(duration))
                }
                
                cell.initPlayView(sliderValue: Float(self.audioPlayer?.getCurrentTime() ?? 0), timer: self.audioTimer?.timeString(time: self.audioPlayer?.getCurrentTime() ?? 0) ?? "")
            }
            return cell
        }
        return UITableViewHeaderFooterView()
    }
    
    func changeSliderPlayingState(cell: PlayerView) {
        cell.headerAction = { timeValue in
            self.audioPlayer?.audioTimeControl { trackDuration in
            
                self.audioPlayer?.setCurrentTime(currentTime: timeValue)
                print("audioTimeControl")
                self.audioPlayer?.continuePlay()
            }
        }
    }
    
    func changePlayingStateByPlayerView(cell: PlayerView) {
        cell.switchPlayingMusic = { currentTime in
            if !cell.changePlayState() {
                self.audioPlayer?.continuePlay()
                self.audioTimer?.play()
            } else {
                self.audioPlayer?.pause()
                self.audioTimer?.pauseTimer()
            }
            self.changePlayingStateBack?()
        }
    }
    
    func cellForRow(indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: musicDequeueReusableIndex, for: indexPath) as? MusicCompositionView {
            cell.initMusicView(name: trackList?[indexPath.row].getName(), groupName: trackList?[indexPath.row].getGroupName())
            
            if isLoadedTrack(index: indexPath.row) {
                cell.openButton()
            }
            resetCellToZero(cell: cell, indexPath: indexPath)

            cell.transmissProgress(progress: Float(0.0))
            if (self.trackList?[indexPath.row].isDownloaded())! {
                finishAudioLoading(cell: cell)
            } else {
                startAudioLoading(cell: cell, indexPath: indexPath)
            }
            changeLoadingState(cell: cell, indexPath: indexPath)
            return cell
        }
        return UITableViewCell()
    }
    
    func changeLoadingState(cell: MusicCompositionView, indexPath: IndexPath) {
        cell.startLoading = {
            
            var url = self.audioManager?.getDirectoryUrl()
            if let name = self.trackList?[indexPath.row].getName() {
                url?.appendPathComponent(name)
                if self.audioPlayer?.getPlayerUrl() != url {
                    self.startPlayingByUrl(url: url)
                } else {
                    self.changeAudioState(cell: cell)
                }
            }
            
            self.changePlayingState?()
            self.changePlayingStateBack = {
                cell.switchPlayButton()
            }
            cell.switchPlayButton()
        }
    }
    
    func changeAudioState(cell: MusicCompositionView){
        if cell.musicState == .start {
            self.audioPlayer?.pause()
            self.audioTimer?.pauseTimer()
        } else {
            let time = self.audioPlayer?.getCurrentTime()
            self.audioPlayer?.continuePlay()
            self.audioTimer?.continuesTimer()
        }
    }
    
    func startPlayingByUrl(url: URL?) {
        if let filePath = url {
            self.audioPlayer?.playByName(trackName: (filePath))
            self.audioTimer?.play()
        }
    }
    
    func resetCellToZero(cell: MusicCompositionView, indexPath: IndexPath) {
        if didSelectCellIndex == indexPath.row {
            cell.openButton()
            cell.addLoadButton()
            cell.setBaseAudioState()
            cell.setBaseMusicState()
            cell.switchPlayButton()
        }
    }
    
    func startAudioLoading(cell: MusicCompositionView, indexPath: IndexPath) {
        cell.loadAudio = {
            self.changePlayerState(cell: cell, indexPath: indexPath)
            self.changePlayingState?()
            self.trackList?[indexPath.row].setIsDownloaded(isloaded: true)
        }
    }
    
    func finishAudioLoading(cell: MusicCompositionView) {
        cell.closeLoading(viewArray: cell.subviews)
        cell.audioDidLoad()
        cell.changeButton()
    }
    
    func updateLoadingProgress(cell: MusicCompositionView) {
        self.networkManager?.progressChange = { progress in
            DispatchQueue.main.async {
                cell.updateLoadingPercent(loadingPercent: "\(round(progress * 100))%")
                cell.transmissProgress(progress: Float(progress))
            }
        }
    }
    
    func loadAudioFile(cell: MusicCompositionView, indexPath: IndexPath) {
        self.networkManager?.loadAudio(url: self.trackList?[indexPath.row].getUrl() ?? "") { data in
            cell.closeLoading(viewArray: cell.subviews)
            cell.audioDidLoad()
            
            if let data = data {
                if let name = self.trackList?[indexPath.row].getName() {
                    self.audioManager?.saveAudio(audioFile: data, fileName: name)
                    var finishUrl: URL? = nil
                    if let url = self.audioManager?.getFileUrl() {
                        finishUrl = url.deletingLastPathComponent()
                    }
                    
                    finishUrl = finishUrl?.appendingPathComponent(name)
                }
            }
            
            guard let url = self.audioManager?.getFileUrl() else {
                return
            }
            self.audioPlayer?.playByName(trackName: (url))
            self.audioTimer?.play()
        }
    }
    
    func changePlayerState(cell: MusicCompositionView, indexPath: IndexPath) {
        if cell.audioState == AudioState.nopeLoading {
            self.loadAudioFile(cell: cell, indexPath: indexPath)
            self.updateLoadingProgress(cell: cell)
            cell.changeButton(viewArray: cell.subviews)
            cell.audioState = AudioState.loading
        } else if cell.audioState == AudioState.loading {
            cell.changeButton(viewArray: cell.subviews)
            cell.audioState = AudioState.suspending
            self.networkManager?.stopLoading()
        } else {
            self.networkManager?.continueLoading()
            cell.changeButton(viewArray: cell.subviews)
        }
    }
}
