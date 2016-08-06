//
//  ProcessViewController.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/6.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import Foundation
import UIKit

class ProcessViewController : BaseViewController  {
    
    @IBOutlet var doneButton: UIButton!
 
    @IBOutlet var innerView: UIView!
    
    override func viewDidLoad() {
        self.innerView.backgroundColor = UIColor.whiteColor()
    }
    
    @IBAction func doneButtonClicked(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}