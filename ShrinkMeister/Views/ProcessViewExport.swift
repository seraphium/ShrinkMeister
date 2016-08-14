//
//  ProcessView.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/7.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit

class ProcessViewExport : BaseProcessView {
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewModel = mainViewModel.processViewModels[3] as! ProcessViewModelExport

        bindViewModel()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        
     
        

    }
}
