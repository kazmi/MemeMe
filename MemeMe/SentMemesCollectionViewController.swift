//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Sulaiman Azhar on 5/17/15.
//  Copyright (c) 2015 kazmi. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var memesCollectionView: UICollectionView!
    
    var memes: [Meme]!
    
    let cellIdentifier: String = "MemeCollectionViewCell"

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // see comment in SentMemesTableViewController.swift's viewWillAppear()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memes = appDelegate.memes // shared model
        
        // check for empty state
        if (memes.count == 0) {
            memesCollectionView.hidden = true
            emptyLabel.hidden = false
        } else {
            memesCollectionView.hidden = false
            emptyLabel.hidden = true
        }

    }
    
    // MARK: - Collection View Data Source Delegate
    
    // The delegate property is linked in the storyboard.
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath)
        -> UICollectionViewCell {
        
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier,
                forIndexPath: indexPath) as! UICollectionViewCell
            
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
