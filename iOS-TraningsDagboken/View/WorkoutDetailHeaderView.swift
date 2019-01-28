//
//  WorkoutDetailHeaderView.swift
//  iOS-TraningsDagboken
//
//  Created by Eddy Garcia on 2018-09-25.
//  Copyright © 2018 Eddy Garcia. All rights reserved.
//

import UIKit

class WorkoutDetailHeaderView: UIView {

    @IBOutlet var headerImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel! {
        didSet{
            nameLabel.numberOfLines = 0
        }
    }
    @IBOutlet var locationLabel: UILabel! {
        didSet{
            locationLabel.layer.cornerRadius = 5.0
            locationLabel.layer.masksToBounds = true
        }
    }
    @IBOutlet var heartImageView: UIImageView!
    
    
}
