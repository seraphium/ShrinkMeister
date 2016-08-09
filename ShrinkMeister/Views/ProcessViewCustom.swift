//
//  ProcessView.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/7.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit

class ProcessViewCustom : BaseProcessView {
    
    @IBOutlet var widthField: UITextField!
    
    @IBOutlet var heightField: UITextField!
    @IBOutlet var confirmButton: UIButton!
    
    var mainViewModel : MainViewModel!
    var viewModel : ProcessViewModelCustom!
    
    override func didConfirm() {
        print("did confirm custom")
    }

    @IBAction func confirmClicked(sender: UIButton)
    {
        didConfirm()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bindViewModel()
        
        widthField.backgroundColor = UIColor.clearColor()
        heightField.backgroundColor = UIColor.clearColor()
        
        widthField.placeholder = "width"
        heightField.placeholder = "height"
        confirmButton.setTitle("Confirm", forState: .Normal)
    }
    
    func bindViewModel() {
        mainViewModel = AppDelegate.viewModelLocator.getViewModel("Main") as! MainViewModel
        self.viewModel = mainViewModel.processViewModels[1] as! ProcessViewModelCustom
        
        
    }
}
