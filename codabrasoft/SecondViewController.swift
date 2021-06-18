//
//  SecondViewController.swift
//  codabrasoft
//
//  Created by Roman Alikevich on 17.06.2021.
//

import UIKit
import AVFoundation

class SecondViewController: UIViewController {
    private let metadataTitle = "title"
    private let metadataType = "type"
    private let metadataAlbumName = "albumName"
    private let metadataArtist = "artist"
    private let metadataArtwork = "artwork"
    var localURL: URL? = nil
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var picture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    @IBAction func BackButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        if let localURLU = localURL {
            try! FileManager.default.removeItem(at: localURLU)
        }
//
        performSegue(withIdentifier: "backToGeneral", sender: nil)
    }
    
    func setUpView() {
        if let url = localURL {
            let asset = AVAsset(url: url)
            for metaDataItem in asset.commonMetadata {
                if metaDataItem.commonKey?.rawValue == metadataTitle {
                    if let titleData = metaDataItem.value as? String {
                        songTitle.text = titleData
                    }
                }
                if metaDataItem.commonKey?.rawValue == metadataType {
                    if let titleData = metaDataItem.value as? String {
                        genre.text = titleData
                    }
                }
                if metaDataItem.commonKey?.rawValue == metadataAlbumName {
                    if let titleData = metaDataItem.value as? String {
                        albumName.text = titleData
                    }
                }
                if metaDataItem.commonKey?.rawValue == metadataArtist {
                    if let titleData = metaDataItem.value as? String {
                        artist.text = titleData
                    }
                }
                if metaDataItem.commonKey?.rawValue == metadataArtwork {
                    if let imageData = metaDataItem.value as? Data {
                        picture.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
}
