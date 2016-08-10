//
//  ProcessViewModelLevel.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/9.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ProcessViewModelCustom : BaseProcessViewModel, ProcessViewModelProtocol {
    
    dynamic var width : Int
    dynamic var height : Int
    
    override init() {
        width = 50
        height = 50
        super.init()
        self.title = "Custom"
        self.image = UIImage(named: "sample")
        self.confirmCommand = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            self.confirm()
            return RACSignal.empty()
        }

        
    }
    
    func confirm() {
        print("custom confirmed:\(width) : \(height)")

    }
}