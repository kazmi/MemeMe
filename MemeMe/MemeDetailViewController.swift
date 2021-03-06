//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Sulaiman Azhar on 5/17/15.
//  Copyright (c) 2015 kazmi. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var memedImageView: UIImageView!
    
    var memeIndex: Int!
    
    let tapGesture = UITapGestureRecognizer()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.hidden = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: "edit")

        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var meme = appDelegate.memes[memeIndex]
        
        memedImageView.image = meme.memedImage
        
        tapGesture.addTarget(self, action: "imageTap")
        tapGesture.numberOfTapsRequired = 1
        memedImageView.addGestureRecognizer(tapGesture)
        memedImageView.userInteractionEnabled = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.hidden = false
        self.navigationController?.navigationBar.hidden = false
    }
    
    func edit() {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let editAction = UIAlertAction(title: "Edit", style: .Default) { (action) in
            
            self.performSegueWithIdentifier("editMeme", sender: self.memeIndex)
        }
        alertController.addAction(editAction)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .Destructive) { (action) in

            // remove meme from shared model
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.memes.removeAtIndex(self.memeIndex)
            
            self.navigationController?.popViewControllerAnimated(true)
        }
        alertController.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
        }
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func imageTap() {
        
        if navigationController?.navigationBarHidden == false {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let memeEditorViewController = segue.destinationViewController as! MemeEditorViewController
        memeEditorViewController.editMode = true
        memeEditorViewController.editMemeIndex = memeIndex
    }

}
