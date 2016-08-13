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
    
    
     init() {
        width = defaultWidth
        height = defaultHeight
        
        super.init(title: "Custom", image: UIImage(named: "sample"))
        
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