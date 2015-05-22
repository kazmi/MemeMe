//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Sulaiman Azhar on 5/18/15.
//  Copyright (c) 2015 kazmi. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIScrollViewDelegate,
    UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    
    // store generated memed image
    var memedImage: UIImage?
    var memeImageView = UIImageView()
    
    var topTextFieldDefaultText: String = "TOP"
    var bottomTextFieldDefaultText: String = "BOTTOM"
    
    // default font
    var font: String = "Impact"
    
    var editMode: Bool = false
    var editMemeIndex: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Subscribe to the keyboard notifications, to allow the view to raise when necessary
        self.subscribeToKeyboardNotification()
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.Camera)
        
        self.tabBarController?.tabBar.hidden = true;
        
        scrollView.addSubview(memeImageView)
        
        if editMode {
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            var meme = appDelegate.memes[editMemeIndex!]
            
            topTextFieldDefaultText = meme.topText
            bottomTextFieldDefaultText = meme.bottomText
            memedImage = meme.image
            font = meme.font
            
            shareButton.enabled = true
        }
        
        configFont()

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unsubscribe from the keyboard notifications.
        self.unsubscribeFromKeyboardNotification()
        
        self.tabBarController?.tabBar.hidden = false;
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        adjustImage()
    }
    
    func orientationChanged() {
        adjustImage()
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    // MARK: - Font
    
    func configFont() {
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: self.font, size: 40)!,
            NSStrokeWidthAttributeName: -3.0
        ]
        
        self.topTextField.defaultTextAttributes = memeTextAttributes
        self.topTextField.textAlignment = NSTextAlignment.Center
        self.topTextField.text = topTextFieldDefaultText
            
        self.bottomTextField.defaultTextAttributes = memeTextAttributes
        self.bottomTextField.textAlignment = NSTextAlignment.Center
        self.bottomTextField.text = bottomTextFieldDefaultText
    }
    
    @IBAction func pickFont(sender: AnyObject) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let impactFontAction = UIAlertAction(title: "Impact", style: .Default) { (action) in
            
            self.font = "Impact"
            self.configFont()
            
        }
        alertController.addAction(impactFontAction)
        
        let HelveticaNeueAction = UIAlertAction(title: "HelveticaNeue", style: .Default) { (action) in
            
            self.font = "HelveticaNeue-CondensedBlack"
            self.configFont()

        }
        alertController.addAction(HelveticaNeueAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
        }
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Pick An Image
    
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        pickAnImageFromSourceType(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        pickAnImageFromSourceType(UIImagePickerControllerSourceType.Camera)
    }
    
    func pickAnImageFromSourceType(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - Image Picker Controller Delegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        memedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            
        adjustImage()
            
        // enable share button since the Meme Editor's imageView has an image.
        shareButton.enabled = true
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
        Comment by Sulaiman Azhar on 5/22/15.
    
        The adjustImage and centerScrollViewContents methods are implemented to be used
        along with a UIScrollView to provide panning and zooming proportionally inorder to
        exceed the specification, as opposed to simply using an UIImageView with content 
        mode set to AspectFil.
    
        In order to implement this feature, I took help from the following resources,
    
        [1] https://developer.apple.com/library/ios/samplecode/PhotoScroller/Introduction/Intro.html
        [2] http://stackoverflow.com/questions/794294/how-do-i-center-a-uiimageview-within-a-full-screen-uiscrollview
        [3] http://discussions.udacity.com/t/l6-looking-for-tips-on-usage-of-uiimageview-with-uiscrollview/14800/2
    
    */
    
    func adjustImage() {
        
        if let image = memedImage {
            
            memeImageView.removeFromSuperview()
            
            memeImageView = UIImageView()
            memeImageView.bounds = scrollView.bounds
            memeImageView.frame = CGRectMake(0, 0, scrollView.frame.width, scrollView.frame.height)
            
            scrollView.addSubview(memeImageView)
            
            memeImageView.image = image
            memeImageView.contentMode = UIViewContentMode.Center
            memeImageView.frame = CGRectMake(0, 0, image.size.width, image.size.height)
            
            scrollView.contentSize = image.size
            
            let scrollViewFrame = scrollView.frame
            let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
            let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
            let minScale = min(scaleHeight, scaleWidth)
            
            scrollView.minimumZoomScale = minScale
            scrollView.maximumZoomScale = 1
            scrollView.zoomScale = minScale
            
            centerScrollViewContents()
        }
    }
    
    func centerScrollViewContents() {
        let boundSize = scrollView.bounds.size
        
        var contentsFrame = memeImageView.frame
        if contentsFrame.size.width < boundSize.width {
            contentsFrame.origin.x = (boundSize.width - contentsFrame.size.width) / 2
        } else {
            contentsFrame.origin.x = 0
        }
        
        if contentsFrame.size.height < boundSize.height {
            contentsFrame.origin.y = (boundSize.height - contentsFrame.size.height) / 2
        } else {
            contentsFrame.origin.y = 0
        }
        
        memeImageView.frame = contentsFrame
    }
    
    // MARK: - Scroll View Delegate
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        centerScrollViewContents()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return memeImageView
    }
    
    // MARK: - Text Field Delegate and Notifications
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField.text == "") {
            if textField == topTextField {
                textField.text = topTextFieldDefaultText
            } else {
                textField.text = bottomTextFieldDefaultText
            }
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // clear the default text when the user taps inside a textfield.
        if (textField.text == topTextFieldDefaultText || textField.text == bottomTextFieldDefaultText) {
            textField.text = ""
        }
    }
    
    func subscribeToKeyboardNotification() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:",
            name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide",
            name: UIKeyboardWillHideNotification, object: nil)
        
        UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged",
            name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotification() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIDeviceOrientationDidChangeNotification,
            object: nil)
        UIDevice.currentDevice().endGeneratingDeviceOrientationNotifications()
    }
    
    // Move the view when the keyboard covers the text field
    func keyboardWillShow(notification: NSNotification) {
        
        if (self.bottomTextField.isFirstResponder()) {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillHide() {
        
        // reset frame position
        self.view.frame.origin.y = 0
    }
    
    // MARK: - Meme Generation and Sharing
    
    func saveMemeAfterSharing(activity: String!, completed: Bool, items: [AnyObject]!, error: NSError!) {
        if completed {
            self.save()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func share(sender: AnyObject) {
        
        self.memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage!], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = saveMemeAfterSharing
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar
        self.toolBar?.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar
        self.toolBar?.hidden = false
        
        return memedImage
    }
    
    func save() {

        var meme = Meme(topText: topTextField.text,
            bottomText: bottomTextField.text,
            image: memeImageView.image!,
            memedImage: memedImage!,
            font: font)
        
        // shared model
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if editMode {
            // update existing meme
            appDelegate.memes[editMemeIndex!] = meme
        } else {
            // save new meme
            appDelegate.memes.append(meme)
        }
    }

}
