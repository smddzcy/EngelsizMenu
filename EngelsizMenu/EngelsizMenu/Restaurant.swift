//
//  Restaurant.swift
//  EngelsizMenu
//
//  Created by Samed Duzcay on 07/05/16.
//  Copyright © 2016 Samed Düzçay. All rights reserved.
//

import Foundation

class Restaurant{
    
    let restaurantID: Int
    let name: String
    let location: (Double, Double) // Latitude - Longitude
    
    init(restaurantID:Int, name:String, location: (Double,Double)){
        self.restaurantID = restaurantID
        self.name = name
        self.location = location
    }
    
}