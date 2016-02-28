//
//  TweetsViewController.swift
//  twitter
//
//  Created by Isis Anchalee on 2/19/16.
//  Copyright © 2016 Isis Anchalee. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tweets: [Tweet]? = []
    var refreshControl: UIRefreshControl!
    
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
    
    func populateTimeline(refreshControl: UIRefreshControl? = nil) {
        let url = "/1.1/statuses/home_timeline.json"
        TwitterClient.sharedInstance.getTimelineWithParams(nil, url: url, completion: { (tweets, error) -> () in
            self.tweets = tweets
            print(self.tweets)
            self.tableView.reloadData()
            if let refreshControl = refreshControl {
                refreshControl.endRefreshing()
            }
        })
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
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailsViewController = self.storyboard!.instantiateViewControllerWithIdentifier("TweetDetailsViewController") as! TweetDetailsViewController
        
        let tweet = tweets![indexPath.row]
        detailsViewController.tweet = tweet
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.navigationController?.pushViewController(detailsViewController, animated: true)
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
        let image = UIImage(named: "white-logo.png")
        self.navigationItem.titleView = UIImageView(image: image)
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
