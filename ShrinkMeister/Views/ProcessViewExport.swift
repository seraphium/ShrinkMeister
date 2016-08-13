//
//  ProcessView.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/7.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit

class ProcessViewExport : BaseProcessView {
    
    var viewModel : ProcessViewModelExport!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bindViewModel()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel = mainViewModel.processViewModels[2] as! ProcessViewModelExport
        
     
        

    }
}
