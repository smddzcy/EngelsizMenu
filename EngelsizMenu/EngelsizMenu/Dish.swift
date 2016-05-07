//
//  Dish.swift
//  EngelsizMenu
//
//  Created by Samed Duzcay on 07/05/16.
//  Copyright © 2016 Samed Düzçay. All rights reserved.
//

import Foundation

class Dish{
    
    let dishID: Int
    let dishName: String
    let dishPrice: Double
    let dishPriceCurrency: String
    let dishDescription: String
    
    init(dishID: Int, dishName: String, dishPrice:Double,dishPriceCurrency: String,dishDescription:String){
        self.dishID = dishID
        self.dishName = dishName
        self.dishPrice = dishPrice
        self.dishPriceCurrency = dishPriceCurrency
        self.dishDescription = dishDescription
    }
}