
//
//  ProfileViewController.swift
//  twitter
//
//  Created by Isis Anchalee on 2/26/16.
//  Copyright © 2016 Isis Anchalee. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetCellDelegate{
    var user: User?
    var tweets: [Tweet] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userHeaderImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        bindDataToView()
        populateTimeline()
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
        setupNavIcon()
        addRefresh()
        // Do any additional setup after loading the view.
    }
    
    func addRefresh() {
        self.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "refreshCallback", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl!, atIndex: 0)
    }
    
    func refreshCallback() {
        populateTimeline(self.refreshControl)
    }
    
    func setupNavIcon(){
        let image = UIImage(named: "Twitter_logo_white_32")
        self.navigationItem.titleView = UIImageView(image: image)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        let tweet = tweets[indexPath.row]
        cell.tweet = tweet
        cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return tweets.count ?? 0
    }
    
    func thumbImageClicked(tweet: Tweet?){
        let params = ["user_id": tweet!.retweetedID!]
        TwitterClient.sharedInstance.getUserWithCompletion(params) { (user, error) -> () in
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
            self.navigationController?.pushViewController(vc, animated: true)
            vc.user = user!
            
        }
    }
    
    func populateTimeline(refreshControl: UIRefreshControl? = nil) {
        let params = ["user_id": user!.id!] as NSDictionary
        let url = "/1.1/statuses/user_timeline.json"
        TwitterClient.sharedInstance.getTimelineWithParams(params, url: url, completion: { (tweets, error) -> () in
            self.tweets = tweets!
            self.tableView.reloadData()
            if let refreshControl = refreshControl {
                refreshControl.endRefreshing()
            }
        })
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailsViewController = self.storyboard!.instantiateViewControllerWithIdentifier("TweetDetailsViewController") as! TweetDetailsViewController
        
        let tweet = tweets[indexPath.row]
        detailsViewController.tweet = tweet
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    func bindDataToView(){
        formatName()
        nameLabel.text = "\(user!.name!)"
        usernameLabel.text = "@\(user!.screenName!)"
        tweetCountLabel.text = "\(user!.tweetCount!)"
        followingCountLabel.text = "\(user!.following!)"
        followersCountLabel.text = "\(user!.followers!)"
        userHeaderImage.setImageWithURL(user!.profileBackgroundImageURL!)
        profileImageView.setImageWithURL(user!.profileURL!)
    }
    
    func formatName(){
        nameLabel.textColor = UIColor.whiteColor()
        usernameLabel.textColor = UIColor.whiteColor()
        nameLabel.layer.shadowColor = UIColor.blackColor().CGColor
        nameLabel.layer.shadowOffset = CGSizeMake(5, 5)
        nameLabel.layer.shadowRadius = 5
        nameLabel.layer.shadowOpacity = 1.0
        usernameLabel.layer.shadowColor = UIColor.blackColor().CGColor
        usernameLabel.layer.shadowOffset = CGSizeMake(5, 5)
        usernameLabel.layer.shadowRadius = 5
        usernameLabel.layer.shadowOpacity = 1.0
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
