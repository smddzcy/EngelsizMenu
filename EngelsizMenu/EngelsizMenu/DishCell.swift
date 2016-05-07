//
//  DishCell.swift
//  EngelsizMenu
//
//  Created by Samed Duzcay on 07/05/16.
//  Copyright © 2016 Samed Düzçay. All rights reserved.
//

import UIKit

class DishCell: UITableViewCell {

    @IBOutlet weak var dishName: UILabel!
    @IBOutlet weak var dishDescription: UILabel!
    @IBOutlet weak var dishPrice: UILabel!
    
    //override func awakeFromNib() { self.accessibilityElements = [self.dishName, self.dishPrice, self.dishDescription]; }
}
