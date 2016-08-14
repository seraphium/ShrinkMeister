//
//  ProcessViewModelLevel.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/9.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ProcessViewModelCustom : BaseProcessViewModel {
    
    let defaultWidth = 1024
    let defaultHeight = 768
    
    var autoSetting : Bool = false
    dynamic var width : Int {
        didSet {
            if lockAspect && autoSetting == false {
                autoSetting = true
                height = Int(Double(width) / sourceAspect)
                autoSetting = false
            }
        }
    }
    
    dynamic var height : Int  {
        didSet {
            if lockAspect && autoSetting == false {
                autoSetting = true
                width = Int(Double(height) * sourceAspect)
                autoSetting = false
            }
        }
    }

    var sourceAspect : Double
    
    var lockAspect : Bool = false
    
    var lockAspectCommand : RACCommand!

     init() {
        width = defaultWidth
        height = defaultHeight
        sourceAspect = Double(width) / Double(height)
        
        super.init(title: "Custom", image: UIImage(named: "sample"))
        
        self.lockAspectCommand = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            //toggle lock height according to width
            
            self.lockAspect = !self.lockAspect
            NotificationHelper.postNotification("lock", objects: self, userInfo: ["lock": self.lockAspect])
            return RACSignal.empty()
        }
        
        
     }
    
    override func beforeProcess() {
        self.parameters = [width, height]
    }
    
    override func imageDidSet() {
        if let sourceImage = self.sourceImageViewModel?.image {
            width = Int(sourceImage.size.width)
            height = Int(sourceImage.size.height)
            sourceAspect = Double(width) / Double(height)
        }

    }
}