//
//  WorkoutDescriptionCell.swift
//  iOS-TraningsDagboken
//
//  Created by Eddy Garcia on 2018-09-25.
//  Copyright © 2018 Eddy Garcia. All rights reserved.
//

import UIKit

class WorkoutDescriptionCell: UITableViewCell {
    
    @IBOutlet var descriptionLabel : UILabel! {
        didSet{
            descriptionLabel.numberOfLines = 0
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
