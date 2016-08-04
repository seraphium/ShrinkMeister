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
    
    var label : UILabel!

    var addPhotoViewModel : AddPhotoViewModel!
    
    
    func initUI()
    {
        label = UILabel()
        view.addSubview(label)
        label.snp_makeConstraints { make -> Void in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(20)
        }
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
