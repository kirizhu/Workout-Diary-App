//
//  TrainingTableViewCell.swift
//  iOS-TraningsDagboken
//
//  Created by Eddy Garcia on 2018-09-18.
//  Copyright © 2018 Eddy Garcia. All rights reserved.
//

import UIKit

class TrainingTableViewCell: UITableViewCell {
    
    
    
    
    
    @IBOutlet var DateLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var thumbnailImageView: UIImageView!{
        didSet{
            //setting the cornerRadius to half the image width
            thumbnailImageView.layer.cornerRadius = thumbnailImageView.bounds.width / 2
            //crops the image
            thumbnailImageView.clipsToBounds = true
        }
    }
    @IBOutlet var heartImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
