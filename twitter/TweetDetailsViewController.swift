//
//  TweetDetailsViewController.swift
//  twitter
//
//  Created by Isis Anchalee on 2/21/16.
//  Copyright © 2016 Isis Anchalee. All rights reserved.
//

import UIKit
@objc protocol TweetDetailsViewControllerDelegate {
    optional func newTweetClicked(tweetDetailedViewController: TweetDetailsViewController, replyToTweet: Tweet?)
    optional func favClicked(tweetDetailedViewController: TweetDetailsViewController, favTweet: Tweet?, completion: ((tweet: Tweet?, error: NSError?) -> ())?)
    optional func retweetClicked(tweetDetailedViewController: TweetDetailsViewController, retweetTweet: Tweet?, completion: ((tweet: Tweet?, error: NSError?) -> ())?)
}

class TweetDetailsViewController: UIViewController {
    var tweet: Tweet!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var tweetBodyLabel: UILabel!
    
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var likeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViewData() {
        usernameLabel.text = tweet.user!.name
        screenNameLabel.text = tweet.user!.screenName
        dateLabel.text = DateManager.detailedFormatter.stringFromDate(tweet.createdAt!)
        tweetBodyLabel.text = tweet.text
        retweetCountLabel.text = String(tweet.retweetCount)
        favoriteLabel.text = String(tweet.favCount)
        profileImageView.setImageWithURL((tweet.user!.profileURL ?? NSURL(string:"http://placekitten.com/40/40"))!)
        if tweet.retweetName != nil {
            retweetLabel.text = "\(tweet.retweetName!) retweeted"
        } else if tweet.replyName != nil {
            retweetLabel.text = "In reply to \(tweet.replyName!)"
        } else {
            retweetLabel.hidden = true
        }
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
        likeImage.setImageWithURL(NSURL(string:"https://g.twimg.com/dev/documentation/image/like-action.png")!)
        backImage.setImageWithURL(NSURL(string:"https://g.twimg.com/dev/documentation/image/reply-action_0.png")!)
        retweetImage.setImageWithURL(NSURL(string:"https://g.twimg.com/dev/documentation/image/retweet-action.png")!)
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
