//
//  TrainingLogViewController.swift
//  iOS-TraningsDagboken
//
//  Created by Mehmed Vrana on 2018-09-20.
//  Copyright © 2018 Eddy Garcia. All rights reserved.
//

import UIKit
import CoreData

class TrainingLogViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate {
    
    var workoutPost : WorkoutPostMO!
    
    @IBOutlet var nameTextField: RoundedTextField! {
        didSet {
            nameTextField.tag = 0
            nameTextField.becomeFirstResponder()
            nameTextField.delegate = self
        }
    }
    
    @IBOutlet var locationTextField: RoundedTextField! {
        didSet{
            locationTextField.tag = 1
            locationTextField.delegate = self
        }
    }
    
  
    @IBOutlet var dateTextField: RoundedTextField! {
        didSet{
            dateTextField.tag = 2
            dateTextField.delegate = self
            
        }
    }
    
    @IBOutlet var adressTextField: RoundedTextField! {
        didSet{
            adressTextField.tag = 3
            adressTextField.delegate = self
        }
    }
    
    @IBOutlet var descriptionTextField: UITextView! {
        didSet{
            descriptionTextField.tag = 4
            descriptionTextField.layer.cornerRadius = 5.0
            descriptionTextField.layer.masksToBounds = true
            
        }
    }
    
    
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet var imageView: UIImageView!
    
    
    @IBOutlet weak var datePickerTF: UITextField!
    
    private var datePicker: UIDatePicker?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // format the display of our datepicker
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePickerTF.inputView = datePicker
        datePicker?.addTarget(self, action: #selector(TrainingLogViewController.dataChanged(datePicker:)), for: .valueChanged)

        _ = UITapGestureRecognizer(target: self, action: #selector(TrainingLogViewController.viewTapped(gestureRecognizer:)))

        // assign date picker to our textfield
        datePickerTF.inputView = datePicker

    }

    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)

    }

    @objc func dataChanged(datePicker: UIDatePicker) {

        //format the date display in textfield
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        datePickerTF.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK: - UITableViewDelegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            let photoSourceRequestController = UIAlertController(title: "", message: NSLocalizedString("Choose an image source", comment: "Choose an image source"), preferredStyle: .actionSheet)
            
            let cameraAction = UIAlertAction(title: NSLocalizedString("Camera", comment: "Camera"), style: .default, handler: { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .camera
                    
                    self.present(imagePicker, animated: true, completion: nil)
                }
            })
            
            let photoLibraryAction = UIAlertAction(title: NSLocalizedString("Gallery", comment: "Gallery"), style: .default, handler: { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .photoLibrary
                    
                    self.present(imagePicker, animated: true, completion: nil)
                }
                
            })
            
            photoSourceRequestController.addAction(cameraAction)
            photoSourceRequestController.addAction(photoLibraryAction)
            
            present(photoSourceRequestController, animated: true, completion: nil)
        }
        
    }
    
    // MARK: - UITextFieldDelegate methods
    
    func textFieldShouldReturn(_ textField:UITextField ) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
            
        }
        return true
    }
    
    // MARK: - Action method 
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        
        
        if nameTextField.text == "" || locationTextField.text == "" || dateTextField.text == "" || adressTextField.text == "" || descriptionTextField.text == ""  {
            let alertController = UIAlertController(title: "Oops", message: NSLocalizedString("We cannot continue because one of the fields is empty. Note that all fields are mandatory", comment: "We cannot continue because one of the fields is empty. Note that all fields are mandatory"), preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            
            
            return
        }
        
        
        print("Name: \(nameTextField.text ?? "")")
        print("Location: \(locationTextField.text ?? "")")
        print("Date: \(dateTextField.text ?? "")")
        print("Adress: \(adressTextField.text ?? "")")
        print("Description: \(descriptionTextField.text ?? "")")
        
        // Saving the restaurant to database
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            workoutPost = WorkoutPostMO(context: appDelegate.persistentContainer.viewContext)
            
            workoutPost.name = nameTextField.text
            workoutPost.location = locationTextField.text
            workoutPost.adress = adressTextField.text
            workoutPost.date = dateTextField.text
            workoutPost.summary = descriptionTextField.text
            workoutPost.isGood = false
            
            if let workoutPostImage = imageView.image {
                workoutPost.image = workoutPostImage.pngData()
            }
            print("Saving data to context")
            appDelegate.saveContext()
        }
        dismiss(animated: true, completion: nil)
    }
        // MARK: - UIImagePickerControllerDelegate method
        
       

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let selectedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            imageView.contentMode = .scaleAspectFill
            imageView.image = selectedImage
            imageView.clipsToBounds = true
            
        }
        let leadingConstraint = NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: imageView.superview, attribute: .leading, multiplier: 1, constant: 0)
        leadingConstraint.isActive = true
        
        let trailingConstraint = NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: imageView.superview, attribute: .trailing, multiplier: 1, constant: 0)
        trailingConstraint.isActive = true
        
        let topConstraint = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: imageView.superview, attribute: .top, multiplier: 1, constant: 0)
        topConstraint.isActive = true
        
        let bottomConstraint = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: imageView.superview, attribute: .bottom, multiplier: 1, constant: 0)
        bottomConstraint.isActive = true
        
        dismiss(animated: true, completion: nil)
        
    }
}
    

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
