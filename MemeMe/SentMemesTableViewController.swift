//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Sulaiman Azhar on 5/17/15.
//  Copyright (c) 2015 kazmi. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var memesTableView: UITableView!
    
    var memes: [Meme]!
    
    let cellIdentifier: String = "MemeTableViewCell"
    
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
    
    // MARK: - Table View and Data Source Delegates
    
    // The delegate properties are linked in the storyboard.
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! UITableViewCell
        let meme = memes[indexPath.row]
        
        cell.textLabel?.text = meme.topText + "..." + meme.bottomText
        
        return cell
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
