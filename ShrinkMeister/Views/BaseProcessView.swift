//
//  BaseProcessView.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/7.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit

class BaseProcessView : UIView, ProcessViewProtocol {
    
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
      
    }
    
    func didConfirm() {
        
    }
}
