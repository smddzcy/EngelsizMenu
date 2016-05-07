//
//  RestaurantViewController.swift
//  EngelsizMenu
//
//  Created by Samed Duzcay on 07/05/16.
//  Copyright © 2016 Samed Düzçay. All rights reserved.
//

import UIKit
import Alamofire
import UIKit.UIGestureRecognizerSubclass

class RestaurantViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var restaurant: Restaurant!
    var menus: [Menu] = [Menu]()
    
    @IBAction func rightSwipe(sender: UISwipeGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Ended {
            if let indexPath = tableView.indexPathsForVisibleRows?[0]{
                if let headerToFocus = self.tableView.headerViewForSection(max(menus.count-1,(indexPath.section) + 1)){
                    self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
                    headerToFocus.textLabel!.becomeFirstResponder()
                    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, headerToFocus.textLabel!)
                    tableView.setNeedsDisplay()
                }
            }
        }
    }
    
    @IBAction func leftSwipe(sender: UISwipeGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Ended {
            if let indexPath = tableView.indexPathsForVisibleRows?[0]{
                if let headerToFocus = self.tableView.headerViewForSection(max(0,(indexPath.section) - 1)){
                    self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
                    headerToFocus.textLabel!.becomeFirstResponder()
                    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, headerToFocus.textLabel!)
                    tableView.setNeedsDisplay()
                }
            }
        }
    }
    
    /**
     Swipe between menu categories with 3 fingers
     
     - parameter direction: Direction of swipe
     
     - returns: True if successful, false otherwise
     */
    override func accessibilityScroll(direction: UIAccessibilityScrollDirection) -> Bool {
        var isScrollingUp:Bool = false
        switch(direction){
        case .Up:
            isScrollingUp = true
            break
        case .Down:
            isScrollingUp = false
            break
        default:
            return false
        }
        var section: Int
        if #available(iOS 9.0, *) {
            if let el = UIAccessibilityFocusedElement(nil) as? UIAccessibilityElement{
                if let cellHighlighted = el.accessibilityContainer as? DishCell{
                    
                    if let indexPath = tableView.indexPathForCell(cellHighlighted){
                        
                        var headerToFocusOptional: UITableViewHeaderFooterView?
                        if isScrollingUp{ // reverse
                            section = min(menus.count-1,(indexPath.section) + 1)
                            headerToFocusOptional = self.tableView.headerViewForSection(section)
                        }else{
                            section = max(0,indexPath.section - 1)
                            headerToFocusOptional = self.tableView.headerViewForSection(section)
                        }

                        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0,inSection: section), atScrollPosition: .Top, animated: true)
                        self.tableView.setNeedsDisplay() // small bug with highspeed usage
                        
                        if let headerToFocus = headerToFocusOptional{
                            
                            UIAccessibilityPostNotification(UIAccessibilityPageScrolledNotification, "\(headerToFocus.textLabel!.text!) kategorisi")
                            if ((tableView.indexPathsForVisibleRows?.contains(indexPath)) != nil){
                                UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, headerToFocus.textLabel!)
                                //headerToFocus.textLabel!.becomeFirstResponder()
                                headerToFocus.textLabel!.accessibilityActivate()
                                self.tableView.setNeedsLayout()
                            }else{
                                UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, headerToFocus.textLabel!)
                                //headerToFocus.textLabel!.becomeFirstResponder()
                                headerToFocus.textLabel!.accessibilityActivate()
                                self.tableView.setNeedsDisplay()
                            }
                            
                            
                            
                        }
                    }
                }
            }
        } else {
            // Fallback on earlier versions
        }
        //if let indexPath = tableView.indexPathsForVisibleRows?[0]{
        
        //}
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    override func viewWillAppear(animated: Bool) {
        self.title = restaurant.name
        
        menus = []
        self.tableView.reloadData()
        let loadingIndicator = GlobalMethods.addActivityIndicator(view)
        Alamofire.request(.GET, "\(AppConstants.apiURL)/menu/get/\(restaurant.restaurantID)")
            .validate()
            .responseJSON { response in
                if response.result.isFailure {
                    loadingIndicator.stopAnimating()
                    loadingIndicator.removeFromSuperview()
                    GlobalMethods.popUpAlert("Hata", msg: "Sunucuyla bağlantı kurulamadı.", viewController: self)
                }else{
                    let menuList: [NSDictionary] = response.result.value as! [NSDictionary]
                    for data in menuList{
                        let menuToAdd: Menu = Menu(menuName: data.valueForKey("menu_name") as! String, menuID: (data.valueForKey("menu_id") as! NSString).integerValue, restaurantID: (data.valueForKey("restaurant_id") as! NSString).integerValue)
                        Alamofire.request(.GET, "\(AppConstants.apiURL)/dish/get/\(menuToAdd.menuID)")
                            .validate()
                            .responseJSON { response2 in
                                let dishList: [NSDictionary] = response2.result.value as! [NSDictionary]
                                for data2 in dishList{
                                    let dishToAdd: Dish = Dish(dishID: (data2.valueForKey("dish_id") as! NSString).integerValue, dishName: data2.valueForKey("dish_name") as! String, dishPrice: (data2.valueForKey("dish_price") as! NSString).doubleValue, dishPriceCurrency: data2.valueForKey("dish_price_currency") as! String, dishDescription: data2.valueForKey("dish_description") as! String)
                                    menuToAdd.dishes.append(dishToAdd)
                                }
                                self.menus.append(menuToAdd)
                                loadingIndicator.stopAnimating()
                                loadingIndicator.removeFromSuperview()
                                self.tableView.reloadData()
                                
                                //set accessibility focus to first menu category
                                UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self.tableView.headerViewForSection(0)?.textLabel!);
                                self.tableView.headerViewForSection(0)?.textLabel!.becomeFirstResponder()
                                self.tableView.setNeedsDisplay()
                        }
                        
                    }
                    
                }
        }
    }
    
    /**
     Used by app to determine the number of sections in the table view
     
     - parameter tableView: UITableView object
     
     - returns: Number of sections, 2 for this app. One for lunch foods, one for dinner foods.
     */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return menus.count
    }
    
    /**
     Used by app to determine the number of rows in each section of the table view
     
     - parameter tableView: UITableView object
     - parameter section:   Section number
     
     - returns: Number of rows
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus[section].dishes.count
    }
    
    /**
     Manages the cells in the table view
     
     - parameter tableView: UITableView object
     - parameter indexPath: Index of the cell
     
     - returns: UITableViewCell for the given index
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("dish", forIndexPath: indexPath) as! DishCell
        let dish: Dish = menus[indexPath.section].dishes[indexPath.row]
        cell.dishName.text = dish.dishName
        cell.dishDescription.text = dish.dishDescription
        cell.dishPrice.text = "\(dish.dishPrice) \(dish.dishPriceCurrency == "TRY" ? "TL" : dish.dishPriceCurrency)"
        return cell
    }
    
    /**
     Used by app to set titles for the headers of sections
     
     - parameter tableView: UITableView object
     - parameter section:   Section number
     
     - returns: Title of the section, or nil if section is not valid
     */
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return menus[section].menuName
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        // set bgcolor of header
        view.tintColor = AppConstants.darkPrimaryColor
        let headerView: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        headerView.alpha = 1
        headerView.contentView.backgroundColor = AppConstants.darkPrimaryColor
        // set text color
        headerView.textLabel?.textColor = UIColor.whiteColor()
        
        // accessibility settings
        headerView.accessibilityLabel = headerView.textLabel?.text!
        headerView.accessibilityValue = "kategorisi"
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
