//
//  ProcessViewModelLevel.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/9.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa


class ProcessViewModelCrop : BaseProcessViewModel {

    var toggleCommand : RACCommand!
    
    dynamic var cropMode: Bool = false
    
    var cropRect: CGRect!
    
    init() {
        
        super.init(title: "Crop", image: UIImage(named: "sample"))
        
        self.toggleCommand = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            
            NotificationHelper.postNotification("EnterCrop", objects: self, userInfo: nil)
            self.cropMode = !self.cropMode
            
            return RACSignal.empty()
        }


    }

    override func beforeProcess() {
        self.parameters = [cropRect]
    }
    
    override func imageDidSet() {

        
    }

    func executeCropSignal() -> RACSignal {
        
        
        
        return RACSignal.empty()
    }
    
}