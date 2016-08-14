//
//  ProcessView.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/7.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit

class ProcessViewCrop : BaseProcessView {
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewModel = mainViewModel.processViewModels[0] as! ProcessViewModelCrop

        bindViewModel()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        
     
        

    }
}
