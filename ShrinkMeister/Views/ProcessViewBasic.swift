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
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        bindViewModel()
    
        initUI()
    }
    
    func initUI() {

        levelSelector.setTitle(NSLocalizedString("ProcessLevelLargeButtonTitle", comment: ""), forSegmentAtIndex: 0)
        levelSelector.setTitle(NSLocalizedString("ProcessLevelMediumButtonTitle", comment: ""), forSegmentAtIndex: 1)
        levelSelector.setTitle(NSLocalizedString("ProcessLevelSmallButtonTitle", comment: ""), forSegmentAtIndex: 2)
        levelSelector.selectedSegmentIndex = 0
        
    }
    
    
    override func bindViewModel() {
        
        self.viewModel = mainViewModel.processViewModels[0] as! ProcessViewModelBasic

        super.bindViewModel()
        
        
        levelSelector.rac_newSelectedSegmentIndexChannelWithNilValue(0) ~> RAC(viewModel, "imageLevel")
    }
    
}
