//
//  MemeHelperClass.swift
//  MemeMe
//
//  Created by Jon on 10/20/16.
//  Copyright © 2016 jonbrown. All rights reserved.
//

import UIKit

public class MemeHelperClass: NSObject
{
    public func setTextFieldAttributes(textfield: UITextField, size: CGFloat)
    {
        // set textfield attributes
        
        let memeTextAttributes =
            [
                NSStrokeColorAttributeName : UIColor.blackColor(),
                NSForegroundColorAttributeName : UIColor.whiteColor(),
                NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: size)!,
                NSStrokeWidthAttributeName : -3.0,
                ]
        
        textfield.defaultTextAttributes = memeTextAttributes
        
        // center text
        
        textfield.textAlignment = .Center
    }

}
