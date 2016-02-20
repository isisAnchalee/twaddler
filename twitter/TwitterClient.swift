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
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseUrl,
                consumerKey: twitterConsumerKey,
                consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> () ) {
        loginCompletion = completion
        requestSerializer.removeAccessToken()
        
        // fetch request token & redirect to authorization page
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(authURL)
            
            }) { (error: NSError!) -> Void in
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func openUrl(url: NSURL){
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
                print("Successfully got the access token!")
                TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                self.requestCurrentUser()
                self.requestHomeTimelineTweets()
            }) { (error: NSError!) -> Void in
                print("Failed to get access token.")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func requestCurrentUser(){
        TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, progress: { (progress: NSProgress) -> Void in
            }, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                self.loginCompletion?(user: user, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error) -> Void in
                self.loginCompletion?(user: nil, error: error)
        })
    }
    
    func requestHomeTimelineTweets() {
        TwitterClient.sharedInstance.GET("1.1/statuses/home_timeline.json", parameters: nil, progress: { (progress: NSProgress) -> Void in
            }, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                
                for tweet in tweets{
                    print("text: \(tweet.text), created: \(tweet.createdAt)")
                }
            }, failure: { (operation: NSURLSessionDataTask?, error) -> Void in
        })
    }
}
