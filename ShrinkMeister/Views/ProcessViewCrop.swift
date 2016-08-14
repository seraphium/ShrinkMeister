//
//  ProcessView.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/7.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit

class ProcessViewCrop : BaseProcessView {
    
    var viewModel : ProcessViewModelCrop!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bindViewModel()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel = mainViewModel.processViewModels[0] as! ProcessViewModelCrop
        
     
        

    }
}
