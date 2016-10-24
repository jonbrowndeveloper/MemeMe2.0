//
//  CustomMemeCell.swift
//  MemeMe
//
//  Created by Jon on 9/7/16.
//  Copyright © 2016 jonbrown. All rights reserved.
//

import UIKit

class CustomMemeCell: UICollectionViewCell
{
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextField: UITextField!

    func setText (topText: String, bottomText: String)
    {
        // set texfield attributes
        
        MemeHelperClass().setTextFieldAttributes(topTextField, size: 18)
        MemeHelperClass().setTextFieldAttributes(bottomTextField, size: 18)
        
        // set text
        
        topTextField.text = topText
        bottomTextField.text = bottomText
    }
}
