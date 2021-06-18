//
//  Track.swift
//  codabrasoft
//
//  Created by Roman Alikevich on 11.06.2021.
//

import UIKit

//MARK: - Track model -
class Track {
    
    //MARK: - Properties -
    private var name: String?
    private var groupName: String?
    private var url: String?
    private var isloaded: Bool?
    
    //MARK: - Init -
    init(name: String, groupName: String, url: String, isloaded: Bool = false) {
        self.name = name
        self.groupName = groupName
        self.url = url
        self.isloaded = isloaded
    }
    
    //MARK: - Setter -
    func setIsDownloaded(isloaded: Bool) {
        self.isloaded = isloaded
    }
    
    //MARK: - Getter -
    func isDownloaded() -> Bool? {
        return isloaded
    }
    
    func getName() -> String? {
        return name
    }
    
    func getGroupName() -> String? {
        return groupName
    }
    
    func getUrl() -> String? {
        return url
    }
}
