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
    
    func createTweetWithCompletion(params: NSDictionary, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/statuses/update.json",
            parameters: params,
            progress: { (progress: NSProgress) -> Void in },
            success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let tweet = Tweet(dictionary: response as! NSDictionary)
                completion(tweet: tweet, error: nil)
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error creating tweet")
                completion(tweet: nil, error: error)
        })
    }
    
    func retweetWithCompletion(id: Int, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/statuses/retweet/\(id).json",
            parameters: nil,
            progress: { (progress: NSProgress) -> Void in },
            success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let tweet = Tweet(dictionary: response as! NSDictionary)
                completion(tweet: tweet, error: nil)
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error retweeting")
                completion(tweet: nil, error: error)
        })
    }
    
    
    func favoriteWithCompletion(id: Int?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/favorites/create.json",
            parameters: NSDictionary(dictionary: ["id": id!]),
            progress: { (progress: NSProgress) -> Void in },
            success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let tweet = Tweet(dictionary: response as! NSDictionary)
                completion(tweet: tweet, error: nil)
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error favoriting")
                completion(tweet: nil, error: error)
        })
    }
    
    
    func openUrl(url: NSURL){
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
                print("Successfully got the access token!")
                TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                self.requestCurrentUser()
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
    
    func getUserWithCompletion(params: NSDictionary?, completion: (user: User?, error: NSError?) -> ()) {
        GET("1.1/users/lookup.json", parameters: params, progress: { (progress: NSProgress) -> Void in
            }, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let user = User(dictionary: response![0] as! NSDictionary)
                completion(user: user, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error) -> Void in
                completion(user: nil, error: error)
        })
        
    }
    
    func unretweetWithCompletion(id: Int, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/statuses/unretweet/\(id).json",
            parameters: nil,
            progress: { (progress: NSProgress) -> Void in },
            success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let tweet = Tweet(dictionary: response as! NSDictionary)
                completion(tweet: tweet, error: nil)
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error un-retweeting")
                completion(tweet: nil, error: error)
        })
    }
    
    func unfavoriteWithCompletion(id: Int?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/favorites/destroy.json",
            parameters: NSDictionary(dictionary: ["id": id!]),
            progress: { (progress: NSProgress) -> Void in },
            success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let tweet = Tweet(dictionary: response as! NSDictionary)
                completion(tweet: tweet, error: nil)
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                completion(tweet: nil, error: error)
        })
    }
    
    func getTimelineWithParams(params: NSDictionary?, url: String, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET(url, parameters: params, progress: { (progress: NSProgress) -> Void in
            }, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                
                completion(tweets: tweets, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error) -> Void in
                completion(tweets: nil, error: error)
        })
    }
}
