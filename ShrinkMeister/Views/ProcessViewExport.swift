//
//  ProcessView.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/7.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit

class ProcessViewExport : BaseProcessView {
    
    @IBOutlet var exportButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewModel = mainViewModel.processViewModels[3] as! ProcessViewModelExport

        bindViewModel()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        exportButton.rac_command = (self.viewModel as! ProcessViewModelExport).exportCommand
     
        

    }
}
