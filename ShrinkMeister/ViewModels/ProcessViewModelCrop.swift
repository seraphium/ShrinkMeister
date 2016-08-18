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

    var cropCommand : RACCommand!
    var toggleCommand : RACCommand!
    
    dynamic var cropMode: Bool = false
    
    init() {
        
        super.init(title: "Crop", image: UIImage(named: "sample"))
        
        self.cropCommand = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            
            NotificationHelper.postNotification("Crop", objects: self, userInfo: nil)
            
            return RACSignal.empty()
        }
        
        
        self.toggleCommand = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            
            NotificationHelper.postNotification("EnterCrop", objects: self, userInfo: nil)
            self.cropMode = !self.cropMode
            
            return RACSignal.empty()
        }


    }

    override func beforeProcess() {
        
    }
    
    override func imageDidSet() {

        
    }

    func executeCropSignal() -> RACSignal {
        
        
        
        return RACSignal.empty()
    }
    
}