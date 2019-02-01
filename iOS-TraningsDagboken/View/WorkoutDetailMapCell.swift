//
//  WorkoutDetailMapCell.swift
//  iOS-TraningsDagboken
//
//  Created by Eddy Garcia on 2018-09-25.
//  Copyright © 2018 Eddy Garcia. All rights reserved.
//

import UIKit
import MapKit

class WorkoutDetailMapCell: UITableViewCell {
    
    @IBOutlet var mapView : MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(location: String){
        //get location
        let geoCoder = CLGeocoder()
        print(location)
        geoCoder.geocodeAddressString(location, completionHandler: { placemarks, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            //get first placemark
            if let placemarks = placemarks {
                let placemark = placemarks[0]
                
                //add annotation
                let annotation = MKPointAnnotation()
                
                if let location = placemark.location {
                    //display annotation
                    annotation.coordinate = location.coordinate
                    self.mapView.addAnnotation(annotation)
                    //set zoom
                    let region = MKCoordinateRegion.init(center: annotation.coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
                    self.mapView.setRegion(region, animated: false)
                }
            }
            
        })
        
    }

}
