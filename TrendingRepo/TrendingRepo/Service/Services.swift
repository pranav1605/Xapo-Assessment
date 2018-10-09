//
//  TrendingProjectsService.swift
//  TrendingRepo
//
//  Created by Pranav Jaiswal on 08/10/18.
//  Copyright © 2018 Xapo. All rights reserved.
//

import Foundation
import UIKit

class Service {
    
    public typealias JSON = [String: Any]
    private var baseUrl: URL
    
    init(baseUrl: String) {
        self.baseUrl = URL.init(string: baseUrl)!
    }
    
    func loadTrendingGithubProjects(completion: @escaping ([TrendingProject]? ,Error?) -> ()) -> URLSessionDataTask? {
        // Creating the URLRequest object
        let request = URLRequest(url: self.baseUrl)
        // Sending request to the server.
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if error != nil {
                // If there is an error in the web request, print it to the console
                print(error!.localizedDescription)
            }
            var err: NSError?
            do {
                let decoder = JSONDecoder()
                let projects = try decoder.decode([TrendingProject].self, from: data!)
                completion(projects, error)
            } catch let error1 as NSError {
                err = error1
                print("JSON error: \(String(describing: err))")
            }
            if (err != nil) {
                //If there is an error parsing JSON, print it to the console
                print("JSON Error \(err!.localizedDescription)")
            }
        })
        task.resume()
        return task
    }
    
    func loadDetail(forProject:TrendingProject, completion: @escaping (TrendingProject ,Error?) -> ()) -> URLSessionDataTask? {
        // Creating the URLRequest object
        let request = URLRequest(url: self.baseUrl)
        // Sending request to the server.
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if error != nil {
                // If there is an error in the web request, print it to the console
                print(error!.localizedDescription)
            }
            var err: NSError?
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? JSON
                {
                    if let trendingProjects = jsonResponse["items"] as? NSArray, let project = trendingProjects[0] as? JSON
                    {
                        let owner = Owner.init()
                        owner.login = ((project["owner"] as? NSDictionary)?.value(forKey: "login") as! String)
                        owner.avatar_url = ((project["owner"] as? NSDictionary)?.value(forKey: "avatar_url") as! String)
                        forProject.owner = owner
                        //https://api.github.com/repos/imhuay/Algorithm_Interview_Notes-Chinese/contents/{+path}
                        let readMeAPIString = (project["contents_url"] as? String)?.replacingOccurrences(of: "{+path}", with: "README.md")
                        forProject.readMeAPIString = readMeAPIString
                    }
                }
                completion(forProject, error)
            } catch let error1 as NSError {
                err = error1
                print("JSON error: \(String(describing: err))")
            }
            if (err != nil) {
                //If there is an error parsing JSON, print it to the console
                print("JSON Error \(err!.localizedDescription)")
            }
        })
        task.resume()
        return task
    }
    
    
    func loadReadme(forProject:TrendingProject, completion: @escaping (TrendingProject ,Error?) -> ()) -> URLSessionDataTask? {
        // Creating the URLRequest object
        let request = URLRequest(url: self.baseUrl)
        // Sending request to the server.
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if error != nil {
                // If there is an error in the web request, print it to the console
                print(error!.localizedDescription)
            }
            var err: NSError?
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? JSON
                {
                    if let downloadFilePath = jsonResponse["download_url"] as? String, let downloadFileURL = URL.init(string: downloadFilePath)
                    {
                        let urlData = try Data.init(contentsOf: downloadFileURL)
                        var filePath =  (UIApplication.shared.delegate as! AppDelegate).applicationDocumentsDirectory
                        filePath.appendPathComponent("\(forProject.name ?? "")_README.md")
                        let written = try urlData.write(to: filePath)
                        
                        //print("donw file path: \(filePath), is wtrittrn: \(written)")
                        forProject.readMeFilePath = filePath
                    }
                }
                completion(forProject, error)
            } catch let error1 as NSError {
                err = error1
                print("JSON error: \(String(describing: err))")
            }
            if (err != nil) {
                //If there is an error parsing JSON, print it to the console
                print("JSON Error \(err!.localizedDescription)")
            }
        })
        task.resume()
        return task
    }
    
}

enum ServiceError: Error {
    case noInternetConnection
    case custom(String)
    case other
}

extension ServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return "No internet connection."
        case .other:
            return "Something went wrong"
        case .custom(let message):
            return message
        }
    }
}




