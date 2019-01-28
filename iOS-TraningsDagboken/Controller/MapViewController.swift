//
//  MapViewController.swift
//  iOS-TraningsDagboken
//
//  Created by Eddy Garcia on 2018-09-25.
//  Copyright © 2018 Eddy Garcia. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet var mapView : MKMapView!
    
    //var workoutPost = WorkoutPost()
    var workoutPost : WorkoutPostMO!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //forward geocoding
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(workoutPost.adress ?? "", completionHandler: {placemarks, error in
            if let error = error {
                print(error)
                return
            }//get placemark
            if let placemarks = placemarks {
                let placemark = placemarks[0]
                //add annotation
                let annotation = MKPointAnnotation()
                annotation.title = self.workoutPost.location
                annotation.subtitle = self.workoutPost.adress
                
                if let location = placemark.location{
                    annotation.coordinate = location.coordinate
                    
                    //display annotation
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                    
                }
            }
        })
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.showsPointsOfInterest = true
        mapView.showsBuildings = true
        mapView.showsUserLocation = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
