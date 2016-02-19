//
//  TwitterClient.swift
//  twitter
//
//  Created by Isis Anchalee on 2/19/16.
//  Copyright © 2016 Isis Anchalee. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "cPuu0nHslWJc8snprZYeODPho"
let twitterConsumerSecret = "uEasdpRcaTdQjoRhq01JgEs2pbSi2SZuACIZjZWhiB0ek0Yfx6"
let twitterBaseUrl = NSURL(string:"https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseUrl,
                consumerKey: twitterConsumerKey,
                consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func loginWithCompletion(completion: ((Bool?, NSError?) -> Void)? ) {
        requestSerializer.removeAccessToken()
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
                print("hey!")
            
            }) { (error: NSError!) -> Void in
                print("\(error)")
        }
    }
}
