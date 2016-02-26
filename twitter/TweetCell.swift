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
    
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var replyImage: UIImageView!
    
    @IBOutlet weak var imageTopMargin: NSLayoutConstraint!
    @IBOutlet weak var nameTopMargin: NSLayoutConstraint!
    @IBOutlet weak var usernameTopMargin: NSLayoutConstraint!
    @IBOutlet weak var timeAgoTopMargin: NSLayoutConstraint!
    
    
    
    var tweet: Tweet!{
        didSet {
            setupIcons()
            profileImageView.setImageWithURL((tweet.user!.profileURL ?? NSURL(string:"http://placekitten.com/40/40"))!)
            userNameLabel.text = tweet.user!.name
            tweetHandleLabel.text = "@\(tweet.user!.screenName!)"
            timeAgoLabel.text = DateManager.getFriendlyTime(tweet.createdAt!)
            tweetBodyLabel.text = tweet.text!
            setInitialConstraints()
            if tweet.retweetName != nil {
                retweetLabel.text = "\(tweet.retweetName!) retweeted"
            } else if tweet.replyName != nil {
                retweetLabel.text = "In reply to \(tweet.replyName!)"
            } else {
                adjustConstraints()
            }

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
    }
    
    func setInitialConstraints(){
        retweetLabel.hidden = false
        imageTopMargin.constant = 26
        nameTopMargin.constant = 23
        usernameTopMargin.constant = 23
        timeAgoTopMargin.constant = 23
    }
    
    func adjustConstraints(){
        retweetLabel.hidden = true
        imageTopMargin.constant = 13
        nameTopMargin.constant = 10
        timeAgoTopMargin.constant = 10
        usernameTopMargin.constant = 10
    }
    
    func setupIcons(){
        if tweet.favorited{
            likeImage.setImageWithURL(NSURL(string:"https://g.twimg.com/dev/documentation/image/like-action-on-pressed.png")!)
        } else {
            likeImage.setImageWithURL(NSURL(string:"https://g.twimg.com/dev/documentation/image/like-action.png")!)
        }
        if tweet.retweeted{
            retweetImage.setImageWithURL(NSURL(string:"https://g.twimg.com/dev/documentation/image/retweet-action-on-pressed.png")!)
        }else{
            retweetImage.setImageWithURL(NSURL(string:"https://g.twimg.com/dev/documentation/image/retweet-action.png")!)
        }
        replyImage.setImageWithURL(NSURL(string:"https://g.twimg.com/dev/documentation/image/reply-action_0.png")!)
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
