//
//  Menu.swift
//  EngelsizMenu
//
//  Created by Samed Duzcay on 07/05/16.
//  Copyright © 2016 Samed Düzçay. All rights reserved.
//

import Foundation

class Menu{
    
    let restaurantID: Int
    let menuID: Int
    let menuName: String
    var dishes: [Dish] = [Dish]()
    
    init(menuName:String, menuID: Int, restaurantID: Int){
        self.menuName = menuName
        self.menuID = menuID
        self.restaurantID = restaurantID
    }
}