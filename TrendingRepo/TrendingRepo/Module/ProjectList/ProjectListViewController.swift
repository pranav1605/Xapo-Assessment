//
//  ViewController.swift
//  TrendingRepo
//
//  Created by Pranav Jaiswal on 08/10/18.
//  Copyright © 2018 Xapo. All rights reserved.
//

import UIKit

class ProjectListViewController: UIViewController {
    
    @IBOutlet weak var trendingProjectsTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var viewModel: ProjectListViewModel = {
        return ProjectListViewModel()
    }()
    
    override func viewDidLoad() {
        //Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        self.trendingProjectsTableView.estimatedRowHeight = UITableViewAutomaticDimension
        self.trendingProjectsTableView.rowHeight = UITableViewAutomaticDimension
        self.initViewModal()
        
    }
    
    func initViewModal(){
        
        //vm binding
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.activityIndicator.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.trendingProjectsTableView.alpha = 0.0
                    })
                }else {
                    self?.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.trendingProjectsTableView.alpha = 1.0
                    })
                }
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.trendingProjectsTableView.reloadData()
            }
        }
        
        viewModel.initFetch()
        
    }
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    let detailedSegueID = "DetailsSegue"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailedSegueID {
            if let viewController = segue.destination as? ProjectDetailViewController, let project = viewModel.selectedProject
            {
                viewController.project = project
            }
        }
    }

}

extension ProjectListViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel.numberOfCells)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectDetailCellReuseID", for: indexPath) as? ProjectListTableViewCell
        {
            let projectCellViewModel = viewModel.getCellViewModel(at: indexPath)
            cell.setUpCell(viewModal: projectCellViewModel)
            return cell
        }
        else {
            fatalError("Unhandled")
        }
    }
}
extension ProjectListViewController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.viewModel.userPressed(at: indexPath)
        self.performSegue(withIdentifier: detailedSegueID, sender: nil)
    }
}



