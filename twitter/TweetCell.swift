//
//  TweetCell.swift
//  twitter
//
//  Created by Isis Anchalee on 2/21/16.
//  Copyright © 2016 Isis Anchalee. All rights reserved.
//

import UIKit

@objc protocol TweetCellDelegate {
    optional func thumbImageClicked(tweet: Tweet?)
    optional func retweetClicked(tweet: Tweet?, indexPath: NSIndexPath)
    optional func likeClicked(tweet: Tweet?, indexPath: NSIndexPath)
}

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
    weak var delegate: TweetCellDelegate?

    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!

    
    @IBOutlet weak var likeIconView: UIImageView!
    @IBOutlet weak var retweetIconView: UIImageView!
    var indexPath: NSIndexPath?

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
            likeCountLabel.text = "\(tweet.favCount)"
            retweetCountLabel.text = "\(tweet.retweetCount)"

        }
    }
    
    func addTapGestureToPhoto(){
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("clickedProfileImage:"))
        profileImageView.userInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func addTapGestureToIcons(){
        let likeTapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("clickedLikeBtn:"))
        likeImage.userInteractionEnabled = true
        likeImage.addGestureRecognizer(likeTapGestureRecognizer)
        let retweetGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("clickedRetweetBtn:"))
        retweetImage.userInteractionEnabled = true
        retweetImage.addGestureRecognizer(retweetGestureRecognizer)
    }
    
    func clickedLikeBtn(sender: UITapGestureRecognizer){
        delegate?.likeClicked!(tweet, indexPath: self.indexPath!)
    }
    
    func clickedRetweetBtn(sender: UITapGestureRecognizer){
        delegate?.retweetClicked!(self.tweet, indexPath: self.indexPath!)
    }

    func clickedProfileImage(sender: UITapGestureRecognizer){
        delegate?.thumbImageClicked?(self.tweet)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
        addTapGestureToPhoto()
        addTapGestureToIcons()
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
            likeImage.image = UIImage(named: "liked")
        } else {
            likeImage.image = UIImage(named: "like")
        }
        if tweet.retweeted{
            retweetImage.image = UIImage(named: "retweeted")
        }else{
            retweetImage.image = UIImage(named: "retweet")
        }
        replyImage.image = UIImage(named: "reply")
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
