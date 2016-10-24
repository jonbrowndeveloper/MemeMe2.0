//
//  CustomMemeTVCell.swift
//  MemeMe
//
//  Created by Jon on 9/29/16.
//  Copyright © 2016 jonbrown. All rights reserved.
//

import UIKit

class CustomMemeTVCell: UITableViewCell {

    @IBOutlet weak var tvImageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellProperties (topText: String, bottomText: String)
    {
        topTextField.text = topText
        bottomTextField.text = bottomText
        
        // set texfield attributes
        
        MemeHelperClass().setTextFieldAttributes(topTextField, size: 28.0)
        MemeHelperClass().setTextFieldAttributes(bottomTextField, size: 28.0)
        
        // trying to force the size of the imageview
        
        imageView!.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
    }

}
