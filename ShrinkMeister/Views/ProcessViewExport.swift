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
    
    @IBOutlet var otherButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewModel = mainViewModel.processViewModels[3] as! ProcessViewModelExport
        
        self.exportButton.tintColor = UIColor.blackColor()
        self.exportButton.setTitle(NSLocalizedString("ProcessViewExportButtonTitle", comment: ""), forState: .Normal)
        self.otherButton.setBackgroundImage(UIImage(named: "other"), forState: .Normal)
        
        bindViewModel()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        exportButton.rac_command = (self.viewModel as! ProcessViewModelExport).exportCommand
     
        otherButton.rac_command = (self.viewModel as! ProcessViewModelExport).otherCommand
        
        RACObserve(mainViewModel, keyPath: "processEnabled")
            .subscribeNextAs {
                (enabled : Bool) -> () in
                if !enabled {
                    self.exportButton.enabled = false
                    self.otherButton.enabled = false
                } else {
                    self.exportButton.enabled = true
                    self.otherButton.enabled = true
                }
        }


    }
}
