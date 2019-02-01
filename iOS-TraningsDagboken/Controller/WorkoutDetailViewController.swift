//
//  WorkoutDetailViewController.swift
//  iOS-TraningsDagboken
//
//  Created by Eddy Garcia on 2018-09-23.
//  Copyright © 2018 Eddy Garcia. All rights reserved.
//

import UIKit



class WorkoutDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: WorkoutDetailHeaderView!
    
    var workoutPost : WorkoutPostMO!
    //var workoutPost : WorkoutPost = WorkoutPost()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        navigationItem.largeTitleDisplayMode = .never
        
        // Configure header view
        headerView.nameLabel.text = workoutPost.name
        headerView.locationLabel.text = workoutPost.location
        
        if let workoutPostImage = workoutPost.image{
        headerView.headerImageView.image = UIImage(data: workoutPostImage as Data)
        }
        
        headerView.heartImageView.isHidden = (workoutPost.isGood) ? false : true
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - TableViewDataSource Protocol
    
    //  return the number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    //  return the number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    //  Custom cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WorkoutDateAdressCell.self), for: indexPath) as! WorkoutDateAdressCell
            cell.iconImageView.image = UIImage(named: "calendar")
            cell.shortTextLabel.text = workoutPost.date
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WorkoutDateAdressCell.self), for: indexPath) as! WorkoutDateAdressCell
            cell.iconImageView.image = UIImage(named: "map")
            cell.shortTextLabel.text = workoutPost.adress
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WorkoutDescriptionCell.self), for: indexPath) as! WorkoutDescriptionCell
            cell.descriptionLabel.text = workoutPost.summary
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WorkoutDetailSeparatorCell.self ), for: indexPath) as! WorkoutDetailSeparatorCell
            cell.titleLabel.text = NSLocalizedString("HOW TO GET THERE", comment: "HOW TO GET THERE")
            
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WorkoutDetailMapCell.self), for: indexPath) as! WorkoutDetailMapCell
            
            if let workoutPostAdress = workoutPost.adress {
                cell.configure(location: workoutPostAdress)
            }
            
            return cell
        default:
            fatalError("Failed to instantiate tableViewCell for detailViewController")
        }
        

    }
    //Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap" {
            let destinationController = segue.destination as! MapViewController
            destinationController.workoutPost = workoutPost
        }
    }


}
