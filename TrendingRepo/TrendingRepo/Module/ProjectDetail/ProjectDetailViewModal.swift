//
//  ProjectDetailViewModal.swift
//  TrendingRepo
//
//  Created by Pranav Jaiswal on 09/10/18.
//  Copyright © 2018 Xapo. All rights reserved.
//

import Foundation
import UIKit

class ProjectDetailViewModal{
    var getProjectDetailsTask: URLSessionDataTask?
    var getProjectReadMeFileTask: URLSessionDataTask?
    
    var project: TrendingProject?{
        didSet{
            self.observeModel()
            if let name = project?.owner?.login{
                self.nameText = name
            }
            if let description = project?.desc{
                self.descriptionText = description
            }
            if let stars = project?.stars{
                self.starText = String(stars)+" Stars"
            }
            if let forks = project?.forks{
                self.forkText = String(forks)+" Forks"
            }
            if let description = project?.desc{
                self.descriptionText = description
            }
            if let encodedImageString = project?.owner?.imageAsBase64String, let imageData = Data.init(base64Encoded: encodedImageString) {
                DispatchQueue.main.async { [weak self] in
                    self?.profileImage = UIImage(data: imageData)!
                }
            }
        }
    }
    
    var observers = [NSKeyValueObservation]()
    
    var nameText:String?{
        didSet{
            self.refreshView?()
        }
    }
    
    var descriptionText:String?{
        didSet{
            self.refreshView?()
        }
    }
    
    var profileImage:UIImage?{
        didSet{
            self.refreshView?()
        }
    }
    var forkText:String?{
        didSet{
            self.refreshView?()
        }
    }
    var starText:String?{
        didSet{
            self.refreshView?()
        }
    }
    
    var readMeContent:String?{
        didSet{
            self.refreshReadMeView?()
        }
    }
    
    var refreshView: (()->())?
    var refreshReadMeView: (()->())?
    init() {
        
    }
    
    func observeModel() {
        self.observers = [
            (project?.observe(\TrendingProject.owner?.imageAsBase64String, options: .new) {[weak self] project, change in
                if let encodedImageString = project.owner?.imageAsBase64String, let imageData = Data.init(base64Encoded: encodedImageString) {
                    DispatchQueue.main.async {
                        self?.profileImage = UIImage(data: imageData)!
                    }
                }
                })!
        ]
    }
    
    
    func fetchDetails() {
        self.getProjectDetailsTask?.cancel()
        //https://api.github.com/search/repositories?q=Algorithm_Interview_Notes-Chinese%20in:name
        let service = Service.init(baseUrl: "https://api.github.com/search/repositories?q=\((project?.name)!)")
        self.getProjectDetailsTask = service.loadDetail(forProject: self.project!, completion: { [weak self] (project, error) in
            DispatchQueue.main.async {
                if let name = project.owner?.login
                {
                    self?.nameText = name
                }
                self?.fetchReadMe()
            }
        })
    }
    
    func fetchReadMe() {
        self.getProjectReadMeFileTask?.cancel()
        
        if let readmeAPIURL = self.project?.readMeAPIString
            //https://api.github.com/search/repositories?q=Algorithm_Interview_Notes-Chinese%20in:name
        {
            let service = Service.init(baseUrl: readmeAPIURL)
            self.getProjectReadMeFileTask = service.loadReadme(forProject: self.project!, completion: { [weak self] (project, error) in
                DispatchQueue.main.async {
                    if let filePath = self?.project?.readMeFilePath, let data = try? Data(contentsOf: filePath)
                    {
                        let contents = String(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
                        self?.readMeContent = contents
                    }
                
            }
            })
        }
    }
    
}


