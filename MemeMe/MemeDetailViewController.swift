//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Jon on 10/6/16.
//  Copyright © 2016 jonbrown. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var bottomToolbarDV: UIToolbar!

    @IBOutlet weak var detailImageView: UIImageView!

    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextField: UITextField!
    
    var meme = Meme()
    
    var memePosition = 0
    
    var isDeleting = false
    
    // added active text field to find out which text field is being edited. Making sure to not move screen if top text field is being edited
    
    var activeTextField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // hide tab bar and unhide toolbar
        
        self.navigationController?.tabBarController?.tabBar.hidden = true
        
        // set textfield attributes
        
        MemeHelperClass().setTextFieldAttributes(topTextField, size: 40.0)
        MemeHelperClass().setTextFieldAttributes(bottomTextField, size: 40.0)
        
        // set textfields' delegates to self
        
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        // set text and imageview
        
        topTextField.text = meme.topText
        bottomTextField.text = meme.bottomText
        
        detailImageView.image = meme.image
        
        // tags for text fields, later used to identify them
        
        topTextField.tag = 1;
        bottomTextField.tag = 0;

    }
    
    override func viewWillAppear(animated: Bool)
    {
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        // unhide tab bar and hide toolbar
        
        self.navigationController?.tabBarController?.tabBar.hidden = false
        
        unsubscribeFromKeyboardNotifications()
        
        // method to detect when back button is pressed
        
        if (self.isMovingFromParentViewController())
        {
            // save if not deleting
            
            if (isDeleting == false)
            {
                // save
                
                if (detailImageView.image != nil)
                {
                    self.meme.topText = topTextField.text!
                    self.meme.bottomText = bottomTextField.text!
                    self.meme.image = detailImageView.image!
                    self.meme.memedImage = generateMemedImage()
                    
                    print(meme)
                    
                    // save meme to App Delegate meme array
                    
                    let object = UIApplication.sharedApplication().delegate
                    let appDelegate = object as! AppDelegate
                    appDelegate.memes[memePosition] = meme
                }
                else
                {
                    print("there is no image");
                }
            }
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TextField Methods
    
    // close keyboard when hitting return
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return false
    }
    
    // MARK: Moving View to Accommodate Keyboard
    
    func keyboardWillShow(notification: NSNotification)
    {
        // slide view up by subtracting keyboard height from y origin
        
        if (activeTextField.tag == 0)
        {
            view.frame.origin.y = getKeyboardHeight(notification) * (-1)
            
        }
    }
    
    func keybaordWillHide(notification: NSNotification)
    {
        // slide view down by adding keyboard height to y origin
        
        if (view.frame.origin.y != 0.0)
        {
            self.view.frame.origin.y = 0
        }
        
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat
    {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    // save current text field object
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        self.activeTextField = textField
        
        // clear out the text field
        
        if textField.text == "TOP" || textField.text == "BOTTOM"
        {
            textField.text = ""
        }
    }
    
    // keybaord notifications
    
    func subscribeToKeyboardNotifications()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeController.keyboardWillShow(_:))    , name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeController.keybaordWillHide(_:))    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self,
                                                            name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func generateMemedImage() -> UIImage
    {
        // hide toolbars and navbar
        
        navigationController?.navigationBar.hidden = true
        bottomToolbarDV.hidden = true
        UIApplication.sharedApplication().statusBarHidden = true
        
        // Render view to an image
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // show toolbars and navbar
        
        navigationController?.navigationBar.hidden = false
        bottomToolbarDV.hidden = false
        UIApplication.sharedApplication().statusBarHidden = false
        
        return memedImage
    }
    
    @IBAction func shareAction(sender: AnyObject)
    {
        // sharing parameters and initializing activity view controller
        
        let textToShare = "Sent from MemeMe!"
        
        let objectsToShare = [textToShare, generateMemedImage()]
        
        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        // display activity view controller
        
        activityViewController.popoverPresentationController?.sourceView = sender as! UIButton
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func deleteAction(sender: AnyObject)
    {
        // save meme to App Delegate meme array
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.removeAtIndex(memePosition)
        
        // push back button
        
        self.navigationController?.popViewControllerAnimated(true)
        
        isDeleting = true
    }
    
    
}
