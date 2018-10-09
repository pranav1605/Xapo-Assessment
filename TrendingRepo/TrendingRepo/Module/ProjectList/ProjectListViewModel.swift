//
//  TrendingProjectViewModal.swift
//  TrendingRepo
//
//  Created by Pranav Jaiswal on 08/10/18.
//  Copyright © 2018 Xapo. All rights reserved.
//

import Foundation
import UIKit

class ProjectListViewModel {
    var getProjectsTask: URLSessionDataTask?
    private var projects: [TrendingProject] = [TrendingProject]()
    
    private var cellViewModels: [ProjectListCellViewModel] = [ProjectListCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    
    var selectedProject: TrendingProject?
    
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    init() {
        
    }
    
    func initFetch() {
        self.getProjectsTask?.cancel()
        
        self.isLoading = true
        let apiService = Service.init(baseUrl: "https://github-trending-api.now.sh/repositories?")
        self.getProjectsTask = apiService.loadTrendingGithubProjects(completion: {[weak self] (fetchedProjects, error) in
            self?.isLoading = false
            if let error = error {
                self?.alertMessage = error.localizedDescription
            } else {
                self?.processFetchedProjects(projects: fetchedProjects!)
            }
        })
    }

    func getCellViewModel(at indexPath: IndexPath) -> ProjectListCellViewModel {
        return cellViewModels[indexPath.row]
    }


    private func processFetchedProjects(projects: [TrendingProject] ) {
        self.projects = projects // Cache
        var vms = [ProjectListCellViewModel]()
        for i in 0..<self.projects.count {
            vms.append(self.createCellViewModel(project: self.projects[i]))
        }
        self.cellViewModels = vms
    }
    
    private func createCellViewModel(project: TrendingProject ) -> ProjectListCellViewModel {
        let stars = "★"+" "+String(project.stars!)
        return ProjectListCellViewModel(titleText: project.name!, starsText: stars, descText: project.desc!)
    }
    
    func userPressed(at indexPath: IndexPath){
        let project = self.projects[indexPath.row]
        self.selectedProject = project
    }
}


struct ProjectListCellViewModel {
    let titleText: String
    let starsText: String
    let descText: String
}
