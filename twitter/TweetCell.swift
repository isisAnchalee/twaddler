//
//  TweetCell.swift
//  twitter
//
//  Created by Isis Anchalee on 2/21/16.
//  Copyright © 2016 Isis Anchalee. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetHandleLabel: UILabel!
    @IBOutlet weak var tweetBodyLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var profileImageViewTopMargin: NSLayoutConstraint!
    
    var tweet: Tweet!{
        didSet {
            profileImageView.setImageWithURL((tweet.user!.profileURL ?? NSURL(string:"http://placekitten.com/40/40"))!)
            userNameLabel.text = tweet.user!.name
            tweetHandleLabel.text = "@\(tweet.user!.screenName!)"
            timeAgoLabel.text = DateManager.getFriendlyTime(tweet.createdAt!)
            tweetBodyLabel.text = tweet.text!
            retweetLabel.hidden = false
            if tweet.retweetName != nil {
                retweetLabel.text = "\(tweet.retweetName!) retweeted"
            } else if tweet.replyName != nil {
                retweetLabel.text = "In reply to \(tweet.replyName!)"
            } else {
                retweetLabel.hidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
