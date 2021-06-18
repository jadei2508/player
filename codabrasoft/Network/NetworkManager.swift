//
//  NetworkManager.swift
//  codabrasoft
//
//  Created by Roman Alikevich on 06.06.2021.
//

import UIKit
import Alamofire
import AVKit

class NetworkManager {
    private var player: AVAudioPlayer? = nil
    private var currentRequest: DataRequest?
    
    var progressChange: ((Double)->())?
    
    func loadAudio(url: String, complition: @escaping(_ data: Data?) -> ()) {
        currentRequest = AF.request(url)
            .downloadProgress(closure: { (progress) in
                self.progressChange?(progress.fractionCompleted)
            })
            .responseData { response in
                complition(response.data)
            }
    }
    
    func stopLoading() {
        currentRequest?.suspend()
    }
    
    func isFinished() -> Bool {
        return ((currentRequest?.isFinished) != nil)
    }
    
    func continueLoading() {
        currentRequest?.resume()
    }
}
