//
//  ViewControllerExtension.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/3.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController : UIViewController {
    internal var viewModel : ViewModel!
    
    internal func setViewModel(vm : ViewModel)
    {
        viewModel = vm
    }
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, withViewModel vm: ViewModel) {
        self.viewModel = vm
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init(withViewModel vm: ViewModel? = nil) {
        self.viewModel = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}