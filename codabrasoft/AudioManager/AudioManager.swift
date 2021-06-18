//
//  AudioManager.swift
//  codabrasoft
//
//  Created by Roman Alikevich on 12.06.2021.
//

import UIKit

class AudioManager {
    private var fileUrl: URL? = nil
    private var directoryUrl = URL(string: "file:///Users/Romanalikevich/Desktop/portfolio-ios/codabrasoft/codabrasoft/Audio")!
    
    func saveAudio(audioFile: Data, fileName: String) -> Bool {
        do {
            fileUrl = directoryUrl.appendingPathComponent(fileName)
            
            guard let fileUrl = fileUrl else {
                return false
            }
            
            try audioFile.write(to: fileUrl)
            
            return true
        } catch {
            return false
        }
    }
    
    func getFileUrl() -> URL? {
        return fileUrl
    }
    
    func getDirectoryUrl() -> URL {
        return directoryUrl
    }
}
