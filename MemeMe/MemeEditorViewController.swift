//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Sulaiman Azhar on 5/18/15.
//  Copyright (c) 2015 kazmi. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController,
    UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    
    // store generated memed image
    var memedImage: UIImage?
    
    let topTextFieldDefaultText: String = "TOP"
    let bottomTextFieldDefaultText: String = "BOTTOM"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let alignment: NSTextAlignment = NSTextAlignment.Center
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -3.0
        ]
        
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = alignment
        topTextField.text = topTextFieldDefaultText

        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = alignment
        bottomTextField.text = bottomTextFieldDefaultText
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Subscribe to the keyboard notifications, to allow the view to raise when necessary
        self.subscribeToKeyboardNotification()
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.Camera)
        
        self.tabBarController?.tabBar.hidden = true;
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unsubscribe from the keyboard notifications.
        self.unsubscribeFromKeyboardNotification()
        
        self.tabBarController?.tabBar.hidden = false;
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.navigationController!.popViewControllerAnimated(true)
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
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.memeImageView.image = image
            
            // enable share button since the Meme Editor's imageView has an image.
            shareButton.enabled = true
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
    }
    
    func unsubscribeFromKeyboardNotification() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
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
            memedImage: memedImage!)
        
        // shared model
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.memes.append(meme)
        
    }


}
