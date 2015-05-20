//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Sulaiman Azhar on 5/17/15.
//  Copyright (c) 2015 kazmi. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var memesCollectionView: UICollectionView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var actionButton: UIBarButtonItem!
    
    var memes: [Meme]!

    var editMode: Bool = false
    
    let cellIdentifier: String = "MemeCollectionViewCell"

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // see comment in SentMemesTableViewController.swift's viewWillAppear()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memes = appDelegate.memes // shared model
        
        // check for empty state
        hideMemeCollectionIfEmptyOtherwiseReloadData()

    }
    
    func hideMemeCollectionIfEmptyOtherwiseReloadData() {
        
        if (memes.count == 0) {
            memesCollectionView.hidden = true
            emptyLabel.hidden = false
            
            editButton.enabled = false
            editButton.title = "Edit"
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add,
                target: self, action: "action:")
            
        } else {
            memesCollectionView.hidden = false
            emptyLabel.hidden = true
            
            editButton.enabled = true
            
            memesCollectionView.reloadData()
            memesCollectionView.allowsMultipleSelection = true
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
                forIndexPath: indexPath) as! MemeCollectionViewCell
            let meme = memes[indexPath.row]
            
            cell.memedImageView!.image = meme.memedImage
            
            return cell
    }
    
    @IBAction func edit(sender: AnyObject) {

        editMode = !editMode
        
        if editMode {
            editButton.title = "Clear"
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Trash,
                target: self, action: "clear")
            
        } else {
            editButton.title = "Edit"
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add,
                target: self, action: "action:")
            
            for indexPath in memesCollectionView.indexPathsForSelectedItems() as! [NSIndexPath] {
                self.memesCollectionView.deselectItemAtIndexPath(indexPath, animated: true)
                let cell = memesCollectionView.cellForItemAtIndexPath(indexPath) as! MemeCollectionViewCell
                cell.selectedImageView.hidden = true
            }
        }
    }
    
    // MARK: - Collection View Delegate
    
    // The delegate property is linked in the storyboard.
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if !editMode {
            let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController")
                as! MemeDetailViewController
            
            detailController.meme = memes[indexPath.row]
            self.navigationController!.pushViewController(detailController, animated: true)
        } else {
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MemeCollectionViewCell
            cell.selectedImageView.hidden = false
        }
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MemeCollectionViewCell
        cell.selectedImageView.hidden = true
        
    }
    
    func clear() {
        
        // remove meme from shared model
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var indexPathForSelectedItems = memesCollectionView.indexPathsForSelectedItems() as! [NSIndexPath]
        indexPathForSelectedItems = sorted(indexPathForSelectedItems, { a, b in a.row > b.row })
        
        for indexPath in indexPathForSelectedItems {
            appDelegate.memes.removeAtIndex(indexPath.row)
            memes.removeAtIndex(indexPath.row)
        }
        
        memesCollectionView.deleteItemsAtIndexPaths(memesCollectionView.indexPathsForSelectedItems())
        
        // check for empty state
        hideMemeCollectionIfEmptyOtherwiseReloadData()
        
    }
    
    // MARK: - Navigation
    
    @IBAction func action(sender: AnyObject) {
        performSegueWithIdentifier("showMemeEditor", sender: nil)
    }

}
