//
//  Tweet.swift
//  twitter
//
//  Created by Isis Anchalee on 2/19/16.
//  Copyright © 2016 Isis Anchalee. All rights reserved.
//

import UIKit



class Tweet: NSObject {
    var id: Int?
    var user: User?
    var user_id: Int?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var retweetName: String? = nil
    var replyName: String? = nil
    var favorited = false
    var retweeted = false
    var retweetCount = 0
    var favCount = 0
    var screenName: String?
    var retweetedID: Int?
    
    
    init(dictionary: NSDictionary){
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        user_id = user!.id!
        text = dictionary["text"] as? String
        id = dictionary["id"] as? Int
        favorited = dictionary["favorited"] as? Bool ?? false
        retweeted = dictionary["retweeted"] as? Bool ?? false
        screenName = user!.screenName
        
        if let createdAtStr = dictionary["created_at"] as? String {
            createdAtString = createdAtStr
            createdAt = DateManager.defaultFormatter.dateFromString(createdAtString!)
        }
        if let retweetCountData = dictionary["retweet_count"] as? Int {
            retweetCount = retweetCountData
        } else {
            retweetCount = 0
        }
        if let favCountData = dictionary["favorite_count"] as? Int {
            favCount = favCountData
        } else {
            favCount = 0
        }
        if let retweetedStatus = dictionary["retweeted_status"] as? NSDictionary {
            if let retweetUserDict = retweetedStatus["user"] as? NSDictionary {
                let retweetUser = User(dictionary: retweetUserDict)
                retweetName = user!.name!
                user = retweetUser
                retweetedID = user?.id
            }
            if let textStr = retweetedStatus["text"] as? String{
                text = textStr
            }
        } else {
            retweetedID = user_id
        }
        if let repliedTo = dictionary["in_reply_to_screen_name"] as? String {
            replyName = repliedTo
        }
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array{
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
}
