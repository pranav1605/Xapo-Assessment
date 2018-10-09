//
//  ProjectDetailViewController.swift
//  TrendingRepo
//
//  Created by Pranav Jaiswal on 08/10/18.
//  Copyright © 2018 Xapo. All rights reserved.
//

import Foundation
import UIKit

class ProjectDetailViewController: UIViewController {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var readMETextView: UITextView!
    
    
    lazy var viewModel: ProjectDetailViewModal = {
        return ProjectDetailViewModal()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.initViewModal()

    }
    
    func setupUI(){
        self.starsLabel.superview?.layer.cornerRadius = 2.0
        self.starsLabel.superview?.layer.borderColor = UIColor.lightGray.cgColor
        self.starsLabel.superview?.layer.borderWidth = 0.5
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width/2
        self.avatarImageView.clipsToBounds = true
        self.avatarImageView.contentMode = UIViewContentMode.scaleAspectFill
       
        
        // code block in scrolling be deactivated.
        // wkWebView.setCodeScrollDisable()
        
    }
    
    func initViewModal(){
        
        //vm binding
       
        
        viewModel.refreshView = { [weak self] () in
            DispatchQueue.main.async {
                self?.usernameLabel.text = self?.viewModel.nameText
                self?.descriptionLabel.text = self?.viewModel.descriptionText
                self?.starsLabel.text = self?.viewModel.starText
                self?.forksLabel.text = self?.viewModel.forkText
                self?.avatarImageView.image = self?.viewModel.profileImage
            }
        }
        
        viewModel.refreshReadMeView = { [weak self] () in
            DispatchQueue.main.async {
                self?.readMETextView.text = self?.viewModel.readMeContent!
            }
        }
        
        viewModel.project = self.project
        
        viewModel.fetchDetails()
        
    }
    
    
   
    /*func fetchReadMe() {
        self.getReadMeFileTask?.cancel()
        //https://api.github.com/search/repositories?q=Algorithm_Interview_Notes-Chinese%20in:name
        if let readmeAPIURL = self.project?.readMeAPIString
        {
            let service = Service.init(baseUrl: readmeAPIURL)
            self.getReadMeFileTask = service.loadReadme(forProject: self.project!, completion: { [weak self] (project, error) in
            DispatchQueue.main.async {
                print(self?.project?.readMeContent)
                self?.usernameLabel.text = project.owner?.login
            }
        })
        }
    }*/
    
   
    
    var project: TrendingProject?{
        didSet{
            self.title = project?.name
        }
    }
    
    
    
    deinit {
        print("Detailed View Controller Deinitialized")
    }
    
}
