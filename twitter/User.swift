//
//  User.swift
//  twitter
//
//  Created by Isis Anchalee on 2/19/16.
//  Copyright © 2016 Isis Anchalee. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"


class User {
    var name: String?
    var screenName: String?
    var description: String?
    var profileURL: NSURL?
    var dictionary: NSDictionary?
    var followers: Int?
    var following: Int?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        description = dictionary["description"] as? String
        followers = dictionary["followers_count"] as? Int
        following = dictionary["following"] as? Int
        profileURL = NSURL(string: dictionary["profile_image_url_https"] as! String)
    }
    
    func logout(){
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
        
    }
    
    class var currentUser: User? {
        get {
            if let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData {
                do {
                    let data = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
                    User.currentUser = User(dictionary: data)
                } catch {
                    print("Failed getting JSON object with data")
                }
            }
        
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            if user != nil {
                do {
                    let data = try NSJSONSerialization.dataWithJSONObject((user?.dictionary)!, options: NSJSONWritingOptions(rawValue: 0))
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                } catch {
                    print("Failed getting data with JSON object")
                }
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    

}