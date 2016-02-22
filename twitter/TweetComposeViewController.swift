//
//  TweetComposeViewController.swift
//  twitter
//
//  Created by Isis Anchalee on 2/21/16.
//  Copyright © 2016 Isis Anchalee. All rights reserved.
//

import UIKit

class TweetComposeViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var tweetBtn: UIButton!
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    var tweetReplyId: Int?
    var tweetReplyUsername: String?
    
    @IBAction func tweetButtonPressed(sender: AnyObject) {
        let params: NSMutableDictionary = (dictionary: ["status": tweetTextView.text])
        if let tweetReplyId = tweetReplyId {
            params.setValue(tweetReplyId, forKey: "in_reply_to_status_id")
        }
        
        TwitterClient.sharedInstance.createTweetWithCompletion(params) { (tweet, error) -> () in
            if error != nil {
                print(error?.description)
            }
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextView.delegate = self
        tweetTextView.becomeFirstResponder()
        let user = User.currentUser
        profileImageView.setImageWithURL((user!.profileURL ?? NSURL(string:"http://placekitten.com/40/40"))!)
        nameLabel.text = user?.name
        screenNameLabel.text = user?.screenName
        setupReply()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupReply(){
        if tweetReplyId != nil{
            tweetTextView.text = "@\(tweetReplyUsername!)"
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        let counter = 140 - tweetTextView.text.characters.count
        counterLabel.text = "\(counter)"
        if counter < 0 {
            counterLabel.textColor = UIColor.redColor()
            tweetBtn.backgroundColor = UIColor.lightGrayColor()
            tweetBtn.enabled = false
        } else {
            counterLabel.textColor = UIColor.lightGrayColor()
            tweetBtn.enabled = true
        }
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
