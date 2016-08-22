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
    let defaultSize = 1024
    
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
    
    dynamic var size : Int
    
    dynamic var toggleSize : Bool {
        didSet {
            NotificationHelper.postNotification("toggleSize", objects: self, userInfo: ["value": toggleSize])
        }
    }

    var sourceAspect : Double
    
    dynamic var lockAspect : Bool = true
    
    var lockAspectCommand : RACCommand!

     init() {
        width = defaultWidth
        height = defaultHeight
        sourceAspect = Double(width) / Double(height)
        
        size = defaultSize
        
        toggleSize = false
        
        super.init(title: "Custom", image: UIImage(named: "ruler"))
        
        self.lockAspectCommand = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            //toggle lock height according to width
            
            self.lockAspect = !self.lockAspect
            if self.lockAspect {
                let w = self.width
                self.width = w
            }
            
            NotificationHelper.postNotification("lock", objects: self, userInfo: ["lock": self.lockAspect])
            return RACSignal.empty()
        }
        
        
     }
    
    override func beforeProcess() {
        if !toggleSize {
            self.parameters = [toggleSize, width, height]

        } else {
            self.parameters = [toggleSize, size]
        }
    }
    

    
    override func imageDidSet() {
        if let sourceImage = self.sourceImageViewModel?.image {
            autoSetting = true
            width = Int(sourceImage.size.width)
            height = Int(sourceImage.size.height)
            sourceAspect = Double(width) / Double(height)
            autoSetting = false
            
            let imageSize = sourceImage.imageSizeByte / 1024
            size = imageSize
            
        }

    }
}