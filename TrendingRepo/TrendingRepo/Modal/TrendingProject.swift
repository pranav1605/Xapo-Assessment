//
//  TrendingProject.swift
//  TrendingRepo
//
//  Created by Pranav Jaiswal on 08/10/18.
//  Copyright © 2018 Xapo. All rights reserved.
//

import Foundation

class TrendingProject:NSObject, Codable {
    var author: String?
    var name: String?
    var url: String?
    var desc: String?
    var language: String?
    var stars: Int?
    var forks: Int?
    var currentPeriodStars: Int?
    @objc dynamic var owner: Owner?
    var readMeAPIString: String?
    var readMeFilePath: URL?
    
    enum CodingKeys: String, CodingKey {
        case author
        case name
        case url
        case desc = "description"
        case language
        case stars
        case forks
        case currentPeriodStars
        case owner
        case readMeAPIString
        case readMeFilePath
    }
}

class Owner:NSObject, Codable {
    @objc dynamic var login: String?
    var avatar_url: String?{
        didSet{
            if let url = URL(string: self.avatar_url!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            {
                DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {[weak self] in
                    if let imageData = try? Data(contentsOf: url){
                        self?.imageAsBase64String = imageData.base64EncodedString()
                    }
                }
            }
        }
    }
    @objc dynamic var imageAsBase64String: String?
    
}
