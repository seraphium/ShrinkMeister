//
//  BaseProcessView.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/7.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit

class BaseProcessView : UIView, ProcessViewProtocol {
    
    var mainViewModel : MainViewModel!
    
    var viewModel : BaseProcessViewModel!

    @IBOutlet weak var confirmButton: UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clearColor()
        
        let blurEffect = UIBlurEffect(style: .ExtraLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        self.insertSubview(blurView, atIndex: 0)
        blurView.snp_makeConstraints {
            make in
            make.edges.equalTo(self)
        }
      
        self.confirmButton?.setBackgroundImage(UIImage(named: "confirm"), forState: .Normal)

      //  self.confirmButton?.setTitle(NSLocalizedString("ProcessViewConfirmButtonTitle", comment: ""), forState: .Normal)
        mainViewModel = AppDelegate.viewModelLocator.getViewModel("Main") as! MainViewModel

    }
    
    func afterShow() {
        
    }
    
    func afterDisappear() {
        
    }
    
    func bindViewModel()
    {
        
        confirmButton?.rac_command = viewModel.confirmCommand

        RACObserve(mainViewModel, keyPath: "processEnabled")
            .subscribeNextAs {
                (enabled : Bool) -> () in
                if !enabled {
                    self.confirmButton?.alpha = 0.3
                    self.confirmButton?.userInteractionEnabled = false
                } else {
                    self.confirmButton?.alpha = 1.0
                    self.confirmButton?.userInteractionEnabled = true
                    
                }
        }


    }
    
    func show()
    {
        self.hidden = false
        self.afterShow()
    }
    
    func hide() {
        
        self.hidden = true
        self.afterDisappear()
    }

}
