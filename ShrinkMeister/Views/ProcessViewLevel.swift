//
//  ProcessView.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/7.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit

class ProcessViewLevel : BaseProcessView {
    
    var mainViewModel : MainViewModel!
    var viewModel : ProcessViewModelLevel!
    
    @IBOutlet var levelButton: UIButton!
    
    override func didConfirm() {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bindViewModel()
    }
    
    func bindViewModel() {
        mainViewModel = AppDelegate.viewModelLocator.getViewModel("Main") as! MainViewModel
        self.viewModel = mainViewModel.processViewModels[0] as! ProcessViewModelLevel
        
        
    }
    
}
