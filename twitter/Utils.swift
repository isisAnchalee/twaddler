
//
//  Utils.swift
//  twitter
//
//  Created by Isis Anchalee on 2/27/16.
//  Copyright © 2016 Isis Anchalee. All rights reserved.
//

import UIKit

class Utils {
    class func configureDefaultNavigationBar(navBar: UINavigationBar) {
        navBar.translucent = false
        navBar.barTintColor = UIColor(red: 85.0/255.0, green: 172.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        navBar.tintColor = UIColor.whiteColor()
        navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    class func setupNavIcon(){
        
    }
}
