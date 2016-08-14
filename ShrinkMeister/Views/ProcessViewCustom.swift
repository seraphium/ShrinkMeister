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
    
    
    var viewModel : ProcessViewModelCustom!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bindViewModel()
        
        widthField.backgroundColor = UIColor.clearColor()
        heightField.backgroundColor = UIColor.clearColor()
        
        widthField.placeholder = "width"
        heightField.placeholder = "height"
        confirmButton.setTitle("Confirm", forState: .Normal)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel = mainViewModel.processViewModels[1] as! ProcessViewModelCustom
        
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
        
        NotificationHelper.observeNotification("lock", object: nil, owner: self) {
             notify in //passed in NSNotification
            let locked = notify.userInfo["lock"] as! Bool
            if locked {
                self.lockAspectButton.backgroundColor = UIColor.redColor()
            } else {
                self.lockAspectButton.backgroundColor = UIColor.clearColor()

            }
            
        }
        
        widthField.rac_textSignal() ~> RAC(viewModel, "width")
        heightField.rac_textSignal() ~> RAC(viewModel, "height")
        
        confirmButton.rac_command = viewModel.confirmCommand
        
        lockAspectButton.rac_command = viewModel.lockAspectCommand
    }
}
