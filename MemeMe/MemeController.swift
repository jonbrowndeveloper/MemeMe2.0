//
//  ViewController.swift
//  MemeMe
//
//  Created by Jon on 5/6/16.
//  Copyright © 2016 jonbrown. All rights reserved.
//

import UIKit

class MemeController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var topToolbar: UIToolbar!
    
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    let imagePicker = UIImagePickerController()
    
    let memedImage = UIImage()

    @IBOutlet weak var actionButton: UIBarButtonItem!
    // added active text field to find out which text field is being edited. Making sure to not move screen if top text field is being edited
    
    var activeTextField: UITextField!
    
    // Meme Struct
    
    struct Meme
    {
        var topText: String!
        var bottomText: String!
        var image: UIImage!
        var memedImage: UIImage!
        
    }
    
    var meme: Meme!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // tags for text fields, later used to identify them
        
        topTextField.tag = 1;
        bottomTextField.tag = 0;
        
        // set image picker delegate
        
        imagePicker.delegate = self
        
        // disable camera if the device does not have a camera
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        // set textfield attributes
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0,
        ]
    
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        // center text
        
        topTextField.textAlignment = .Center
        bottomTextField.textAlignment = .Center
                
        // set textfields' delegates to self
        
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        // disable action button if there is no image
        
        if (imageView.image == nil)
        {
            actionButton.enabled = false;
        }
    }

    @IBAction func startCamera(sender: AnyObject)
    {
        // create image picker to start up camera
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)

    }
    
    @IBAction func openPhotoAlbumn(sender: AnyObject)
    {
        // create image picker to open photo library
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
        
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.contentMode = .ScaleAspectFit
            self.imageView.image = pickedImage
            
            actionButton.enabled = true
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // MARK: Keyboard Notification
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
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
            view.frame.origin.y -= getKeyboardHeight(notification)

        }
    }
    
    func keybaordWillHide(notification: NSNotification)
    {
        // slide view down by adding keyboard height to y origin
        
        if (view.frame.origin.y != 0.0)
        {
            view.frame.origin.y += getKeyboardHeight(notification)
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
    }
    
    // MARK: Meme Object
    
    func save()
    {
        // Create the Meme Object
        
        if (imageView.image != nil)
        {
            self.meme = Meme( topText: topTextField.text!, bottomText: bottomTextField.text!, image:imageView.image, memedImage: generateMemedImage())
        }
        else
        {
            print("there is no image");
        }
        
    }
    
    func generateMemedImage() -> UIImage
    {
        // hide toolbars and navbar
        
        topToolbar.hidden = true
        bottomToolbar.hidden = true
        UIApplication.sharedApplication().statusBarHidden = true
        
        // Render view to an image
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // show toolbars and navbar
        
        topToolbar.hidden = false
        bottomToolbar.hidden = false
        UIApplication.sharedApplication().statusBarHidden = false
        
        return memedImage
    }
    
    @IBAction func shareButton(sender: AnyObject)
    {
        // call save function
        
        save()
        
        // sharing parameters and initializing activity view controller
        
        let textToShare = "Sent from MemeMe!"
        
        let objectsToShare = [textToShare, meme.memedImage]
        
        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        // display activity view controller
        
        activityViewController.popoverPresentationController?.sourceView = sender as! UIButton
        self.presentViewController(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func cancelButton(sender: AnyObject)
    {
        // reset all values to the screen's original state
        
        imageView.image = nil
        
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
    }
    
}
