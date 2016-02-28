//
//  TweetDetailsViewController.swift
//  twitter
//
//  Created by Isis Anchalee on 2/21/16.
//  Copyright © 2016 Isis Anchalee. All rights reserved.
//

import UIKit

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
        setupGestures()
        addTapGestureToPhoto()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupGestures(){
        let retweetGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("retweetTapped:"))
        let likeGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("likeTapped:"))
        let replyGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("replyTapped:"))
        backImage.userInteractionEnabled = true
        retweetImage.userInteractionEnabled = true
        likeImage.userInteractionEnabled = true
        retweetImage.addGestureRecognizer(retweetGestureRecognizer)
        likeImage.addGestureRecognizer(likeGestureRecognizer)
        backImage.addGestureRecognizer(replyGestureRecognizer)
    }
    
    func retweetTapped(img: AnyObject) {
        if tweet.retweeted{
            TwitterClient.sharedInstance.unretweetWithCompletion(tweet.id!) { (tweet, error) -> () in
                if error != nil {
                    print(error?.description)
                } else {
                    self.retweetImage.image = UIImage(named: "retweet")
                    tweet!.retweeted = !tweet!.retweeted
                    self.retweetCountLabel.text = String(tweet!.retweetCount)
                }
            }
        } else {
            TwitterClient.sharedInstance.retweetWithCompletion(tweet.id!) { (tweet, error) -> () in
                if error != nil {
                    print(error?.description)
                } else {
                    self.retweetImage.image = UIImage(named: "retweeted")
                    tweet!.retweeted = !tweet!.retweeted
                    tweet!.retweetCount += 1
                    self.retweetCountLabel.text = String(tweet!.retweetCount + 1)
                }
            }
        }
    }
    
    func likeTapped(img: AnyObject) {
        if tweet.favorited{
            TwitterClient.sharedInstance.unfavoriteWithCompletion(tweet.id) { (tweet, error) -> () in
                if error != nil {
                    print(error?.description)
                } else {
                    self.likeImage.image = UIImage(named: "like")
                    tweet!.favorited = !tweet!.favorited
                    self.favoriteLabel.text = String(tweet!.favCount)
                }
            }
        } else {
            TwitterClient.sharedInstance.favoriteWithCompletion(tweet.id) { (tweet, error) -> () in
                if error != nil {
                    print(error?.description)
                } else {
                    self.likeImage.image = UIImage(named: "liked")
                    tweet!.favorited = !tweet!.favorited
                    self.favoriteLabel.text = String(tweet!.favCount + 1)
                }
            }
        }
    }
    
    @IBAction func replyBtnTapped(sender: AnyObject) {
        if let tweet = tweet{
            let vc = storyboard?.instantiateViewControllerWithIdentifier("TweetComposeViewController") as! TweetComposeViewController!
            navigationController?.pushViewController(vc, animated: true)
            vc.tweetReplyId = tweet.id
            vc.tweetReplyUsername = tweet.user!.screenName
        }
    }
    
    func replyTapped(img: AnyObject){
        if let tweet = tweet{
            let vc = storyboard?.instantiateViewControllerWithIdentifier("TweetComposeViewController") as! TweetComposeViewController!
            navigationController?.pushViewController(vc, animated: true)
            vc.tweetReplyId = tweet.id
            vc.tweetReplyUsername = tweet.user!.screenName
        }
    }

    func setupViewData() {
        bindDataToView()
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
        setupIcons()
    }
    
    func addTapGestureToPhoto(){
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        profileImageView.userInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func imageTapped(img: AnyObject){
        let params = ["user_id": tweet.retweetedID!]
        TwitterClient.sharedInstance.getUserWithCompletion(params) { (user, error) -> () in            
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
            self.navigationController?.pushViewController(vc, animated: true)
            vc.user = user!
            
        }
    }
    
    func bindDataToView(){
        usernameLabel.text = tweet.user!.name
        print("SECOND SN AND ID \(tweet.user!.screenName!)")
        screenNameLabel.text = "@\(tweet.user!.screenName!)"
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
    }
    
    func setupIcons(){
        if tweet.favorited{
            likeImage.image = UIImage(named: "liked")
        } else {
            likeImage.image = UIImage(named: "like")
        }
        if tweet.retweeted{
            retweetImage.image = UIImage(named: "retweeted")
        }else{
            retweetImage.image = UIImage(named: "retweet")
        }
        backImage.image = UIImage(named: "reply")
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
