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
    let titles = ["Profile", "Home Timeline"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupMenu()
        self.title = "Menu"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell") as! MenuCell
        
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
        tweetsViewController = storyboard.instantiateViewControllerWithIdentifier("TweetsViewController")
        let profileNavController = UINavigationController(rootViewController: profileViewController)
        let tweetsNavController = UINavigationController(rootViewController: tweetsViewController)
        Utils.configureDefaultNavigationBar(profileNavController.navigationBar)
        Utils.configureDefaultNavigationBar(tweetsNavController.navigationBar)
        viewControllers.append(profileNavController)
        viewControllers.append(tweetsNavController)
        hamburgerViewController.contentViewController = tweetsNavController
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
