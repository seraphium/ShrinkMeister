//
//  ProcessView.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/7.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit

class ProcessViewCrop : BaseProcessView {
        
    @IBOutlet weak var cropButton: UIButton!
    
    
    @IBOutlet weak var toggleCropButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewModel = mainViewModel.processViewModels[0] as! ProcessViewModelCrop

        bindViewModel()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        toggleCropButton.rac_command = (viewModel! as! ProcessViewModelCrop).toggleCommand
        
        cropButton.rac_command = (viewModel! as! ProcessViewModelCrop).cropCommand
        
        RACObserve(viewModel, keyPath: "cropMode").filter {
            (next: AnyObject?) -> Bool in
            return next != nil
            } .subscribeNextAs {
                (cropMode:Bool) -> () in
                
               self.cropButton.enabled = cropMode
                
        }

    }
}
