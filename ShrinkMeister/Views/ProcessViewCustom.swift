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
    
    @IBOutlet var xLabel: UILabel!
    
    @IBOutlet var lockAspectButton: UIButton!
    
    @IBOutlet var sizeField: UITextField!
    
    @IBOutlet var kbLabel: UILabel!
    
    
    @IBOutlet var toggleSizeControl: UISegmentedControl!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bindViewModel()
        
        toggleSizeControl.tintColor = UIColor.blackColor()
        
        widthField.backgroundColor = UIColor.clearColor()
        heightField.backgroundColor = UIColor.clearColor()
        
        widthField.placeholder = "width"
        heightField.placeholder = "height"
        
        sizeField.backgroundColor = UIColor.clearColor()
        sizeField.placeholder = "size"
        sizeField.hidden = true
        
        kbLabel.hidden = true
        
        self.lockAspectButton.setBackgroundImage(UIImage(named: "locked"), forState: .Normal)
    }
    
    override func bindViewModel() {
        
        self.viewModel = mainViewModel.processViewModels[2] as! ProcessViewModelCustom

        super.bindViewModel()
        
        
        RACObserve(viewModel, keyPath: "toggleSize")
            .subscribeNextAs {
                (toggle: Bool) -> () in
                if toggle {
                    self.toggleSizeControl.selectedSegmentIndex = 1
                } else {
                    self.toggleSizeControl.selectedSegmentIndex = 0
                }
            }
        
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
        
        NotificationHelper.observeNotification("toggleSize", object: nil, owner: self) {
            notify in //passed in NSNotification
            let toggleSize = notify.userInfo["value"] as! Bool
            self.updateToggleSize(toggleSize)
            
        }
        
        widthField.rac_textSignal() ~> RAC(viewModel, "width")
        heightField.rac_textSignal() ~> RAC(viewModel, "height")
        sizeField.rac_textSignal() ~> RAC(viewModel, "size")
        toggleSizeControl.rac_newSelectedSegmentIndexChannelWithNilValue(0) ~> RAC(viewModel, "toggleSize")
        
        
        lockAspectButton.rac_command = (viewModel as! ProcessViewModelCustom).lockAspectCommand
    }
    
    func updateToggleSize(toggleSize : Bool)
    {
       
        self.sizeField.hidden = !toggleSize
        self.kbLabel.hidden = !toggleSize
        
        self.widthField.hidden = toggleSize
        self.heightField.hidden = toggleSize
        self.xLabel.hidden = toggleSize
        self.lockAspectButton.hidden = toggleSize

     
    }
}
