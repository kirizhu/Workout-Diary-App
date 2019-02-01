//
//  TrainingTableViewController.swift
//  iOS-TraningsDagboken
//
//  Created by Eddy Garcia on 2018-09-17.
//  Copyright © 2018 Eddy Garcia. All rights reserved.
//

import UIKit
import CoreData



class TrainingTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
    
    var workoutPosts :[WorkoutPostMO] = []
    var searchResults : [WorkoutPostMO] = []
    var searchController : UISearchController!
    var fetchedResultController : NSFetchedResultsController<WorkoutPostMO>!
    
    @IBOutlet var emptyWorkoutView : UIView!
    

    
    // MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
          //searchbar
        searchController = UISearchController(searchResultsController: nil)
        //self.navigationItem.searchController = searchController
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        //background if empty
        tableView.backgroundView = emptyWorkoutView
        tableView.backgroundView?.isHidden = true
        
    //fetching from data store
        let fetchRequest : NSFetchRequest<WorkoutPostMO> = WorkoutPostMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            let context = appDelegate.persistentContainer.viewContext
            fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultController.delegate = self
            
            do{
                try fetchedResultController.performFetch()
                if let fetchedObjects = fetchedResultController.fetchedObjects {
                    workoutPosts = fetchedObjects
                }
            }catch{
                print(error)
            }
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableViewDataSource Protocol
    
    //  return the number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if workoutPosts.count > 0 {
            tableView.backgroundView?.isHidden = true
            tableView.separatorStyle = .singleLine
        }else {
            tableView.backgroundView?.isHidden = false
            tableView.separatorStyle = .none
        }
        
        return 1
    }
    //  return the number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive {
            return searchResults.count
        }else{
            return workoutPosts.count
        }
    }
    //  Custom cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //  set cellIdentifier, as! is for setting the cell to our own custom one named TrainingTableViewCell
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TrainingTableViewCell
        //determine if whe get result from search or org array
        let workoutPost = (searchController.isActive) ? searchResults[indexPath.row] : workoutPosts[indexPath.row]
        
        cell.nameLabel.text = workoutPost.name
        if let workoutPostImage = workoutPost.image {
            cell.thumbnailImageView.image = UIImage(data: workoutPostImage as Data)
        }
        
        cell.locationLabel.text = workoutPost.location
        cell.DateLabel.text = workoutPost.date
        cell.heartImageView.isHidden = workoutPost.isGood ? false : true
        
        return cell
    }
    
    // MARK: - TableViewDelegate Protocol

    
    //like func
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let likeAction = UIContextualAction(style: .normal, title: NSLocalizedString("Like", comment: "Like")) { (action, sourceView, completionHandler) in
            let cell = tableView.cellForRow(at: indexPath) as! TrainingTableViewCell
            self.workoutPosts[indexPath.row].isGood = (self.workoutPosts[indexPath.row].isGood) ? false : true
            cell.heartImageView.isHidden = self.workoutPosts[indexPath.row].isGood ? false : true
            
            completionHandler(true)
        }
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [likeAction])
        return swipeConfiguration
    }
    
    //share and delete func
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title:NSLocalizedString("Delete", comment: "Delete")) {
            (action, sourceView, completionHandler) in
            // Delete the row from the data source
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                let workoutPostToDelete = self.fetchedResultController.object(at: indexPath)
                context.delete(workoutPostToDelete)
                appDelegate.saveContext() }
            
            // Call completion handler to dismiss the action button
            completionHandler(true)
            
        }
        //share
        let shareAction = UIContextualAction(style: .normal, title: NSLocalizedString("Share" , comment: "Share")) {
            (action , sourceView, completionHandler) in
            let defaultText = NSLocalizedString("Just worked out at ", comment: "Just worked out at ") + self.workoutPosts[indexPath.row].location!
            
            let activityController : UIActivityViewController
            
            //Image sharing  if let to verify if imageToShare contains a value or not
            if let workoutPostImage = self.workoutPosts[indexPath.row].image,
             let imageToShare =  UIImage(data: workoutPostImage as Data){
                activityController = UIActivityViewController(activityItems: [defaultText, imageToShare],applicationActivities: nil)
            } else {
                activityController = UIActivityViewController(activityItems: [defaultText],applicationActivities : nil)
            }
            //Ipad bugifx popover
            if let popoverController = activityController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
            
            self.present(activityController, animated: true, completion: nil)
            completionHandler(true)
            
        }
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        return swipeConfiguration
        
    }
    // SEARCHBAR
    func filterContent(for searchText : String){
        searchResults = workoutPosts.filter({ (workoutPost) -> Bool in
            if let name = workoutPost.name {
                let isMatch = name.localizedCaseInsensitiveContains(searchText)
                return isMatch
            }
            return false
        })
    }
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
            
        }
        
       
    }
    
    // MARK: - Navigation Protocol
    
    //  Passing data through segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWorkoutDetails" {
            if let indexPath =  tableView.indexPathForSelectedRow {
                let destinationController = segue.destination  as! WorkoutDetailViewController
                destinationController.workoutPost = (searchController.isActive) ? searchResults[indexPath.row] : workoutPosts[indexPath.row]
            }
        }
    }
    // MARK: - NSFetchedResultsControllerDelegate methods
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?){
        
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
            
        }
        if let fetchedObjects = controller.fetchedObjects {
            workoutPosts = fetchedObjects as! [WorkoutPostMO]
        }
        
    }
    
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
        


}

