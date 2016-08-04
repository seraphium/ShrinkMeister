//
//  ViewControllerExtension.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/3.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController : UIViewController{
    internal var viewService : ViewControllerService?
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, WithViewService vs : ViewControllerService) {
        self.viewService = vs
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    }
    
    required init(withViewService vs: ViewControllerService? = nil) {
        self.viewService = vs
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}