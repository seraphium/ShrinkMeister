//
//  ProcessView.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/7.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit

class ProcessViewCrop : BaseProcessView, CroppableImageViewDelegateProtocol {
    
    
    @IBOutlet var aspectSelector: UISegmentedControl!
    
    @IBOutlet weak var transAspectButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewModel = mainViewModel.processViewModels[0] as! ProcessViewModelCrop

        bindViewModel()
        
        aspectSelector.setTitle("1:1", forSegmentAtIndex: 0)
        aspectSelector.setTitle("3:2", forSegmentAtIndex: 1)
        aspectSelector.setTitle("4:3", forSegmentAtIndex: 2)
        aspectSelector.setTitle("16:9", forSegmentAtIndex: 3)

        aspectSelector.selectedSegmentIndex = 0

    }
    
    func haveValidCropRect(valid: Bool) {
        
    }
        
    func updateCropRect(cropRect: CGRect, inFrame: CGRect) {
        
        print("cropRect update to: \(cropRect) in frame: \(inFrame)")
        
        (viewModel as! ProcessViewModelCrop).cropRect = cropRect
        (viewModel as! ProcessViewModelCrop).sourceImageFrame = inFrame
    }

   override func afterShow() {
        
        (viewModel as! ProcessViewModelCrop).aspectLevel = 0
    
    }
    
    override func afterDisappear() {
        NotificationHelper.postNotification("ExitCrop", objects: self, userInfo: nil)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        aspectSelector.rac_newSelectedSegmentIndexChannelWithNilValue(nil) ~> RAC(viewModel, "aspectLevel")
        
        transAspectButton.rac_command = (viewModel as! ProcessViewModelCrop).transAspectCommand
        
        RACObserve(viewModel, keyPath: "cropMode").filter {
            (next: AnyObject?) -> Bool in
            return next != nil
            } .subscribeNextAs {
                (cropMode:Bool) -> () in
                
                if cropMode {
                    self.confirmButton!.alpha = 1.0
                } else {
                    self.confirmButton!.alpha = 0.2

                }
                
        }

        RACObserve(viewModel, keyPath: "aspectLevel").filter {
            (next: AnyObject?) -> Bool in
            return next != nil
            } .subscribeNextAs {
                (level:Int) -> () in
                
               self.aspectSelector.selectedSegmentIndex = level
                
        }

    }
}
