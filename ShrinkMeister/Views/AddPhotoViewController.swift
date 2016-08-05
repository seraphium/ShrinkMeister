//
//  AddPhotoViewController.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/3.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa

class AddPhotoViewController : BaseViewController, ViewModelProtocol {
    
    var addPhotoViewModel : AddPhotoViewModel!
    
    
    func initUI()
    {
        view.backgroundColor = UIColor.whiteColor()

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()

        bindViewModel()

    }
    
    func bindViewModel() {
        
        addPhotoViewModel = AppDelegate.viewModelLocator.getViewModel("AddPhoto") as! AddPhotoViewModel
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
}
