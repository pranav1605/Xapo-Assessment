//
//  TrendingRepoTableViewCell.swift
//  TrendingRepo
//
//  Created by Pranav Jaiswal on 08/10/18.
//  Copyright © 2018 Xapo. All rights reserved.
//

import Foundation
import UIKit

class ProjectListTableViewCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var starsLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setUpCell(viewModal:ProjectListCellViewModel)
    {
        self.titleLabel.text = viewModal.titleText
        self.starsLabel.text = viewModal.starsText
        self.descriptionLabel.text = viewModal.descText
    }
    
}
