//
//  ProcessView.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/7.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit

class ProcessViewCustom : BaseProcessView {
    
    @IBOutlet var widthField: UITextField!
    
    @IBOutlet var heightField: UITextField!
    
    @IBOutlet var lockAspectButton: UIButton!
    
    @IBOutlet var sizeField: UITextField!
    
    @IBOutlet var toggleSizeButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bindViewModel()
        
        widthField.backgroundColor = UIColor.clearColor()
        heightField.backgroundColor = UIColor.clearColor()
        
        widthField.placeholder = "width"
        heightField.placeholder = "height"
        
        sizeField.backgroundColor = UIColor.clearColor()
        sizeField.placeholder = "size"
        
        self.lockAspectButton.setBackgroundImage(UIImage(named: "locked"), forState: .Normal)
    }
    
    override func bindViewModel() {
        
        self.viewModel = mainViewModel.processViewModels[2] as! ProcessViewModelCustom

        super.bindViewModel()
        
        
        RACObserve(viewModel, keyPath: "width")
            .subscribeNextAs {
                (width: Int) -> () in
                self.widthField.text = String(width)
        }

        RACObserve(viewModel, keyPath: "height")
            .subscribeNextAs {
                (height: Int) -> () in
                self.heightField.text = String(height)
        }
        
        
        RACObserve(viewModel, keyPath: "size")
            .subscribeNextAs {
                (size: Int) -> () in
                self.sizeField.text = String(size)
        }
        
        NotificationHelper.observeNotification("lock", object: nil, owner: self) {
             notify in //passed in NSNotification
            let locked = notify.userInfo["lock"] as! Bool
            if locked {
                self.lockAspectButton.setBackgroundImage(UIImage(named: "locked"), forState: .Normal)
            } else {
                self.lockAspectButton.setBackgroundImage(UIImage(named: "unlock"), forState: .Normal)

            }
            
        }
        
        widthField.rac_textSignal() ~> RAC(viewModel, "width")
        heightField.rac_textSignal() ~> RAC(viewModel, "height")
        sizeField.rac_textSignal() ~> RAC(viewModel, "size")
        
        lockAspectButton.rac_command = (viewModel as! ProcessViewModelCustom).lockAspectCommand
    }
}
