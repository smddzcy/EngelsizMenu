//
//  GlobalMethods.swift
//  EngelsizMenu
//
//  Created by Samed Duzcay on 07/05/16.
//  Copyright © 2016 Samed Düzçay. All rights reserved.
//

import UIKit

class GlobalMethods{
    /**
     Pops up an alert with given title and string
     
     - parameter title: Title for the alert
     - parameter msg:   Message for the alert
     */
    static func popUpAlert(title: String, msg: String, viewController: UIViewController){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.Default, handler: nil))
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    /**
     Adds an activity indicator to given view
     
     - parameter view: UIView object to add the indicator
     
     - returns: Indicator which is added to the view
     */
    static func addActivityIndicator(view: UIView) -> UIActivityIndicatorView{
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0 , 50, 50))
        loadingIndicator.center = view.center
        loadingIndicator.transform = CGAffineTransformMakeScale(2, 2);
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating();
        // to remove : loadingIndicator.stopAnimating()
        // loadingIndicator.removeFromSuperview()
        return loadingIndicator
    }
    
    /**
     Gives a UIColor object colored with a given HEX code
     
     - parameter hex: HEX code
     
     - returns: UIColor object with given HEX code color
     */
    static func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if cString.hasPrefix("#"){
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if cString.characters.count != 6 {
            return UIColor.grayColor()
        }
        
        var rgbValue :UInt32 = 0
        
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1)
        )
    }
}