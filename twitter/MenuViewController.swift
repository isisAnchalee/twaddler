//
//  MenuViewController.swift
//  twitter
//
//  Created by Isis Anchalee on 2/26/16.
//  Copyright © 2016 Isis Anchalee. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var profileViewController: UIViewController!
    private var tweetsViewController: UIViewController!
    var viewControllers: [UINavigationController] = []
    @IBOutlet weak var tableView: UITableView!
    var hamburgerViewController: HamburgerViewController!
    var icons: [UIImage] = [UIImage(named: "Businesswoman")!, UIImage(named: "Mobile Home")!, UIImage(named: "Google Alerts Filled")!]
    
    let titles = ["Profile", "Home Timeline", "Mentions"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupMenu()
        setupNavIcon()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell") as! MenuCell
        cell.iconImage.image = icons[indexPath.row]
        cell.menuTitleLabel.text = titles[indexPath.row]
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
    }
    
    func setupMenu(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        profileViewController = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController")
        let profVC = profileViewController as! ProfileViewController
        let mentionsController = storyboard.instantiateViewControllerWithIdentifier("TweetsViewController") as! TweetsViewController
        mentionsController.endpoint = "1.1/statuses/mentions_timeline.json"
        let mentionsNavController = UINavigationController(rootViewController: mentionsController)
        profVC.user = User.currentUser!
        tweetsViewController = storyboard.instantiateViewControllerWithIdentifier("TweetsViewController")
        let profileNavController = UINavigationController(rootViewController: profileViewController)
        let tweetsNavController = UINavigationController(rootViewController: tweetsViewController)

        Utils.configureDefaultNavigationBar(profileNavController.navigationBar)
        Utils.configureDefaultNavigationBar(tweetsNavController.navigationBar)
        Utils.configureDefaultNavigationBar(mentionsNavController.navigationBar)
        viewControllers.append(profileNavController)
        viewControllers.append(tweetsNavController)
        viewControllers.append(mentionsNavController)
        
        hamburgerViewController.contentViewController = tweetsNavController
    }
    
    func setupNavIcon(){
        let image = UIImage(named: "Twitter_logo_white_32")
        self.navigationItem.titleView = UIImageView(image: image)
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
