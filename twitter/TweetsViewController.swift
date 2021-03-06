//
//  TweetsViewController.swift
//  twitter
//
//  Created by Isis Anchalee on 2/19/16.
//  Copyright © 2016 Isis Anchalee. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TweetCellDelegate, TweetDetailsViewControllerDelegate {

    var tweets: [Tweet]? = []
    var refreshControl: UIRefreshControl!
    var endpoint: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        populateTimeline()
        addRefresh()
        setupNavIcon()
    }
    
    func updateTweetCell(tweetDetailsViewController: TweetDetailsViewController, tweet: Tweet, indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! TweetCell
        cell.tweet.retweeted = tweet.retweeted
        cell.tweet.retweetCount = tweet.retweetCount
        cell.tweet.favorited = tweet.favorited
        cell.tweet.favCount = tweet.favCount
        print("fav count \(tweet.favCount) retweet count \(tweet.retweetCount) faved? \(tweet.favorited) \(tweet.favCount) ")
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
    }
    

    func populateTimeline(refreshControl: UIRefreshControl? = nil) {
        let url: String?
        if let endpoint = endpoint{
            url = endpoint
        } else {
            url = "/1.1/statuses/home_timeline.json"
        }
        TwitterClient.sharedInstance.getTimelineWithParams(nil, url: url!, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            if let refreshControl = refreshControl {
                refreshControl.endRefreshing()
            }
        })
    }
    
    func retweetClicked(tweet: Tweet?, indexPath: NSIndexPath){
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! TweetCell
        if tweet!.retweeted{
            TwitterClient.sharedInstance.unretweetWithCompletion(tweet!.id!) { (tweet, error) -> () in
                if error != nil {
                    print(error?.description)
                } else {
                    cell.tweet = tweet
                    cell.retweetImage.image = UIImage(named: "retweet")
                    cell.retweetCountLabel.text = String(tweet!.retweetCount)
                }
            }
        } else {
            TwitterClient.sharedInstance.retweetWithCompletion(tweet!.id!) { (tweet, error) -> () in
                if error != nil {
                    print(error?.description)
                } else {
                    cell.tweet = tweet
                    cell.retweetImage.image = UIImage(named: "retweeted")
                    cell.retweetCountLabel.text = String(tweet!.retweetCount)
                }
            }
        }
    }
    
    func likeClicked(tweet: Tweet?, indexPath: NSIndexPath){
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! TweetCell
        if tweet!.favorited{
            TwitterClient.sharedInstance.unfavoriteWithCompletion(tweet!.id) { (tweet, error) -> () in
                if error != nil {
                    print(error?.description)
                } else {
                    cell.tweet = tweet
                    cell.likeImage.image = UIImage(named: "like")
                    cell.likeCountLabel.text = String(tweet!.favCount)
                }
            }
        } else {
            TwitterClient.sharedInstance.favoriteWithCompletion(tweet!.id) { (tweet, error) -> () in
                if error != nil {
                    print(error?.description)
                } else {
                    cell.tweet = tweet
                    cell.likeImage.image = UIImage(named: "liked")
                    cell.likeCountLabel.text = String(tweet!.favCount + 1)
                }
            }
        }
    }
    
    func addRefresh() {
        self.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "refreshCallback", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl!, atIndex: 0)
    }
    
    func refreshCallback() {
        populateTimeline(self.refreshControl)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return tweets!.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        let tweet = tweets![indexPath.row]
        cell.tweet = tweet
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailsViewController = self.storyboard!.instantiateViewControllerWithIdentifier("TweetDetailsViewController") as! TweetDetailsViewController
        detailsViewController.indexPath = indexPath
        detailsViewController.delegate = self
        let tweet = tweets![indexPath.row]
        detailsViewController.tweet = tweet
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    @IBAction func onNew(sender: AnyObject) {
        let vc = storyboard?.instantiateViewControllerWithIdentifier("TweetComposeViewController") as! TweetComposeViewController!
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        let loginViewController = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController")
        UIApplication.sharedApplication().keyWindow?.rootViewController = loginViewController
        User.currentUser?.logout()
    }
    
    func setupNavIcon(){
        let image = UIImage(named: "Twitter_logo_white_32")
        self.navigationItem.titleView = UIImageView(image: image)
    }
    
    
    func thumbImageClicked(tweet: Tweet?){
        print("CLICKED!!!")
        let params = ["user_id": tweet!.retweetedID!]
        TwitterClient.sharedInstance.getUserWithCompletion(params) { (user, error) -> () in
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
            self.navigationController?.pushViewController(vc, animated: true)
            vc.user = user!
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let cell = sender as? UITableViewCell {
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = tweets![indexPath!.row]
            let viewController = segue.destinationViewController as! TweetDetailsViewController
            viewController.tweet = tweet
        }
    }

}
