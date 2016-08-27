//
//  ProcessView.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/7.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit

class ProcessViewBasic : BaseProcessView {
    
    
    @IBOutlet weak var levelSelector: UISegmentedControl!
    
    @IBOutlet weak var rotateLeftButton: UIButton!

    @IBOutlet weak var rotateRightButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bindViewModel()
    
        initUI()
    }
    
    func initUI() {
        levelSelector.tintColor = UIColor.blackColor()
        
        levelSelector.setTitle(NSLocalizedString("ProcessLevelLargeButtonTitle", comment: ""), forSegmentAtIndex: 0)
        levelSelector.setTitle(NSLocalizedString("ProcessLevelMediumButtonTitle", comment: ""), forSegmentAtIndex: 1)
        levelSelector.setTitle(NSLocalizedString("ProcessLevelSmallButtonTitle", comment: ""), forSegmentAtIndex: 2)
        levelSelector.selectedSegmentIndex = 0
        
        rotateLeftButton.setBackgroundImage(UIImage(named: "rotate-left"), forState: .Normal)
        rotateRightButton.setBackgroundImage(UIImage(named: "rotate-right"), forState: .Normal)
    }
    
    
    override func bindViewModel() {
        
        self.viewModel = mainViewModel.processViewModels[0] as! ProcessViewModelBasic

        super.bindViewModel()
        
        
        levelSelector.rac_newSelectedSegmentIndexChannelWithNilValue(0) ~> RAC(viewModel, "imageLevel")
        
        rotateLeftButton.rac_command = (viewModel as! ProcessViewModelBasic).rotateLeftCommand
        rotateRightButton.rac_command = (viewModel as! ProcessViewModelBasic).rotateRightCommand
        
        RACObserve(mainViewModel, keyPath: "processEnabled")
            .subscribeNextAs {
                (enabled : Bool) -> () in
                if !enabled {
                    self.rotateLeftButton.enabled = false
                    self.rotateRightButton.enabled = false
                } else {
                    self.rotateLeftButton.enabled = true
                    self.rotateRightButton.enabled = true
                }
        }
        


    }
    
}
