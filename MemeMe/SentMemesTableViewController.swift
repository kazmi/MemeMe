//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Sulaiman Azhar on 5/17/15.
//  Copyright (c) 2015 kazmi. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UIViewController {

    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var memesTableView: UITableView!
    
    var memes: [Meme]!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        /*
            Comment by Sulaiman Azhar on 5/17/15.
        
            The memes are maintained by the AppDelegate.
        
            From Swift 1.2 onwards, downcasts must be either optional (as?) or
            "forced failable" (as!). Since there is no doubt about the type, the
            cast is forced with as!
        
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
            The same could be achieved with optional binding,
        
            if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                ...
            }
        
        */

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memes = appDelegate.memes // shared model

        // check for empty state
        if (memes.count == 0) {
            memesTableView.hidden = true
            emptyLabel.hidden = false
        } else {
            memesTableView.hidden = false
            emptyLabel.hidden = true
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
