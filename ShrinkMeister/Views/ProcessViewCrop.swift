//
//  ProcessView.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/7.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit

class ProcessViewCrop : BaseProcessView, CroppableImageViewDelegateProtocol {
    
    @IBOutlet weak var toggleCropButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewModel = mainViewModel.processViewModels[0] as! ProcessViewModelCrop

        bindViewModel()
    }
    
    
    func haveValidCropRect(valid: Bool) {
        
    }
        
    func updateCropRect(cropRect: CGRect) {
        
        print("cropRect update to: \(cropRect)")
        
        (viewModel as! ProcessViewModelCrop).cropRect = cropRect
    }

    
    override func bindViewModel() {
        super.bindViewModel()
        
        toggleCropButton.rac_command = (viewModel! as! ProcessViewModelCrop).toggleCommand
                
        RACObserve(viewModel, keyPath: "cropMode").filter {
            (next: AnyObject?) -> Bool in
            return next != nil
            } .subscribeNextAs {
                (cropMode:Bool) -> () in
                
               self.confirmButton!.enabled = cropMode
                
        }

    }
}
