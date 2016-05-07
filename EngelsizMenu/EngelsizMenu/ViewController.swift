//
//  ViewController.swift
//  EngelsizMenu
//
//  Created by Samed Duzcay on 07/05/16.
//  Copyright © 2016 Samed Düzçay. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var resultCount: UILabel!
    
    //in your view controller
    var manager: OneShotLocationManager?
    
    var restaurants:[Restaurant] = [Restaurant]()
    var asyncReqIsSent:Bool = false
    
    @IBOutlet weak var restaurantName: UITextField!
    
    @IBAction func searchButtonTap(sender: UIButton) {
        getRestaurants()
    }
    
    func getRestaurants(){
        // request in progress
        if asyncReqIsSent {
            return
        }
        
        // reset fields
        restaurants = []
        resultCount.hidden = true
        tableView.hidden = true
        tableView.reloadData()
        
        asyncReqIsSent = true
        let loadingIndicator = GlobalMethods.addActivityIndicator(view)
        if let name = restaurantName.text{
            if name.characters.count == 0 {
                // konumdan çek
            }
            Alamofire.request(.GET, "\(AppConstants.apiURL)/restaurant/get/\(name)")
                .validate()
                .responseJSON { response in
                    if response.result.isFailure {
                        loadingIndicator.stopAnimating()
                        loadingIndicator.removeFromSuperview()
                        GlobalMethods.popUpAlert("Hata", msg: "Sunucuyla bağlantı kurulamadı.", viewController: self)
                    }else{
                        let restaurantList: [NSDictionary] = response.result.value as! [NSDictionary]
                        for data in restaurantList{
                            let restaurantToAdd: Restaurant = Restaurant(restaurantID: (data.valueForKey("restaurant_id") as! NSString).integerValue,name: data.valueForKey("restaurant_name") as! String, location: ((data.valueForKey("restaurant_lat") as! NSString).doubleValue,(data.valueForKey("restaurant_lng") as! NSString).doubleValue))
                            self.restaurants.append(restaurantToAdd)
                        }
                        loadingIndicator.stopAnimating()
                        loadingIndicator.removeFromSuperview()
                        // show the result count
                        self.tableView.hidden = false
                        self.resultCount.hidden = false
                        self.resultCount.text = "\(self.restaurants.count) sonuç bulundu."
                        self.tableView.reloadData()
                        UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, self.resultCount); // give focus
                        self.resultCount.becomeFirstResponder()
                        self.asyncReqIsSent = false
                    }
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        getRestaurants()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set table view's delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
        // delete separator
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // set navigation layout
        let nav = self.navigationController?.navigationBar
        nav?.translucent = false
        nav?.barTintColor = AppConstants.darkPrimaryColor // actual color is same as select date button highlight color
        nav?.tintColor = UIColor.whiteColor() // text & button color
        nav?.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        nav?.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        nav?.shadowImage = AppConstants.darkPrimaryColor.toImage()
        
    }
    
    /**
     Used by app to determine the number of sections in the table view
     
     - parameter tableView: UITableView object
     
     - returns: Number of sections, 2 for this app. One for lunch foods, one for dinner foods.
     */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    /**
     Used by app to determine the number of rows in each section of the table view
     
     - parameter tableView: UITableView object
     - parameter section:   Section number
     
     - returns: Number of rows
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    @IBAction func searchWithLocation(sender: AnyObject) {
        manager = OneShotLocationManager()
        manager!.fetchWithCompletion {location, error in
            
            // fetch location or an error
            if let loc = location {
                
                
                // request in progress
                if self.asyncReqIsSent {
                    return
                }
                
                // reset fields
                self.restaurants = []
                self.resultCount.hidden = true
                self.tableView.hidden = true
                self.tableView.reloadData()
                
                self.asyncReqIsSent = true
                let loadingIndicator = GlobalMethods.addActivityIndicator(self.view)
                if let name = self.restaurantName.text{
                    if name.characters.count == 0 {
                        // konumdan çek
                    }
                    Alamofire.request(.GET, "\(AppConstants.apiURL)/restaurant/get/\(loc.coordinate.latitude)/\(loc.coordinate.longitude)")
                        .validate()
                        .responseJSON { response in
                            if response.result.isFailure {
                                loadingIndicator.stopAnimating()
                                loadingIndicator.removeFromSuperview()
                                GlobalMethods.popUpAlert("Hata", msg: "Sunucuyla bağlantı kurulamadı.", viewController: self)
                            }else{
                                let restaurantList: [NSDictionary] = response.result.value as! [NSDictionary]
                                for data in restaurantList{
                                    let restaurantToAdd: Restaurant = Restaurant(restaurantID: (data.valueForKey("restaurant_id") as! NSString).integerValue,name: data.valueForKey("restaurant_name") as! String, location: ((data.valueForKey("restaurant_lat") as! NSString).doubleValue,(data.valueForKey("restaurant_lng") as! NSString).doubleValue))
                                    self.restaurants.append(restaurantToAdd)
                                }
                                loadingIndicator.stopAnimating()
                                loadingIndicator.removeFromSuperview()
                                // show the result count
                                self.tableView.hidden = false
                                self.resultCount.hidden = false
                                self.resultCount.text = "\(self.restaurants.count) sonuç bulundu."
                                self.tableView.reloadData()
                                UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, self.resultCount); // give focus
                                self.resultCount.becomeFirstResponder()
                                self.asyncReqIsSent = false
                            }
                    }
                }
                
            }
            self.manager = nil
            
        }
    }
    
    /**
     Manages the cells in the table view
     
     - parameter tableView: UITableView object
     - parameter indexPath: Index of the cell
     
     - returns: UITableViewCell for the given index
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("restaurant", forIndexPath: indexPath) as! SearchResultCell
        let restaurant: Restaurant = restaurants[indexPath.row]
        cell.restaurantName.text = restaurant.name
        return cell
    }
    
    /**
     Performs the detail page opener segue when a row is selected
     
     - parameter tableView: UITableView object
     - parameter indexPath: Index of the cell
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("restaurantDetailSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "restaurantDetailSegue") {
            let svc = segue.destinationViewController as! RestaurantViewController;
            // Pass the restaurant object
            
            //let cell = sender as! SearchResultCell
            svc.restaurant = restaurants[(tableView.indexPathForSelectedRow!.row)]
        }
    }
    
    
}

extension UIColor{
    func toImage() -> UIImage {
        let rect = CGRectMake(0, 0, 1, 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        self.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

