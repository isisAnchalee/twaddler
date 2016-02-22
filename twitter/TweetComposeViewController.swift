//
//  TweetComposeViewController.swift
//  twitter
//
//  Created by Isis Anchalee on 2/21/16.
//  Copyright © 2016 Isis Anchalee. All rights reserved.
//

import UIKit

class TweetComposeViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!

    @IBAction func backButtonPressed(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func tweetButtonPressed(sender: AnyObject) {
        let params: NSMutableDictionary = (dictionary: ["status": tweetTextView.text])
        
        TwitterClient.sharedInstance.createTweetWithCompletion(params) { (tweet, error) -> () in
            
            if error != nil {
                print(error?.description)
            }
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = User.currentUser
        profileImageView.setImageWithURL((user!.profileURL ?? NSURL(string:"http://placekitten.com/40/40"))!)
        nameLabel.text = user?.name
        screenNameLabel.text = user?.screenName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
