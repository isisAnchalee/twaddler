//
//  HamburgerViewController.swift
//  twitter
//
//  Created by Isis Anchalee on 2/26/16.
//  Copyright © 2016 Isis Anchalee. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    
    var originalLeftMargin: CGFloat!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var menuView: UIView!
    
    var menuViewController: UINavigationController!{
        didSet(oldContentViewController){
            view.layoutIfNeeded()
            if oldContentViewController != nil{
                oldContentViewController.willMoveToParentViewController(nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMoveToParentViewController(nil)
                
            }
            menuView.addSubview(menuViewController.view)
        }
    }
    
    var contentViewController: UINavigationController!{
        didSet(oldContentViewController){
            view.layoutIfNeeded()
            if oldContentViewController != nil{
                oldContentViewController.willMoveToParentViewController(nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMoveToParentViewController(nil)
                
            }
            contentViewController.willMoveToParentViewController(self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMoveToParentViewController(self)
            closeMenu()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func closeMenu(){
        UIView.animateWithDuration(0.3) { () -> Void in
            self.leftMarginConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func onSwipe(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        if sender.state == UIGestureRecognizerState.Began{
            originalLeftMargin = leftMarginConstraint.constant
        } else if sender.state == UIGestureRecognizerState.Changed{
            leftMarginConstraint.constant = originalLeftMargin + translation.x
        } else if sender.state == UIGestureRecognizerState.Ended{
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                if velocity.x > 0{
                    self.leftMarginConstraint.constant = self.view.frame.size.width - 50
                } else {
                    self.leftMarginConstraint.constant = 0
                }
                self.view.layoutIfNeeded()
                
            })

        }
        
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
