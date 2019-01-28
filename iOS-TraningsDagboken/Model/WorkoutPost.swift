//
//  WorkoutPost.swift
//  iOS-TraningsDagboken
//
//  Created by Eddy Garcia on 2018-09-23.
//  Copyright © 2018 Eddy Garcia. All rights reserved.
//

import Foundation

class WorkoutPost {
    
    var name : String
    var date : String
    var location : String
    var adress : String
    var description : String
    var image : String
    var isGood : Bool
    
    var managedObject : WorkoutPostMO?
    
    
//Designated initializer
    init(name : String, date : String, location : String, adress : String, description : String, image : String, isGood : Bool) {
        self.name = name
        self.date =  date
        self.location = location
        self.adress = adress
        self.description = description
        self.image = image
        self.isGood = isGood
    }
    //gives us the option of choosing how ti initialize our object
    convenience init(){
        
        self.init(name: "", date: "", location: "", adress: "", description: "", image: "", isGood: false)
        
    }
    
}
