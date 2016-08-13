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
    
    dynamic var width : Int
    dynamic var height : Int

    var lockAspect : Bool = false
    
    var lockAspectCommand : RACCommand!

     init() {
        width = defaultWidth
        height = defaultHeight
        
        super.init(title: "Custom", image: UIImage(named: "sample"))
        
        self.lockAspectCommand = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            //toggle lock height according to width
            
            self.lockAspect = !self.lockAspect
            
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
        }

    }
}