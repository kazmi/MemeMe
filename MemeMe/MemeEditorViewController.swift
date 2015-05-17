//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Sulaiman Azhar on 5/18/15.
//  Copyright (c) 2015 kazmi. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController {

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true;
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false;
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.navigationController!.popViewControllerAnimated(true)
    }

}
