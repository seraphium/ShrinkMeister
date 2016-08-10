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
    
    dynamic var width : Int
    dynamic var height : Int
    
     init() {
        width = 50
        height = 50
        super.init(title: "Custom", image: UIImage(named: "sample"))
    }
    
    override func confirm() {
        
        //actual processing logic
        if let sourceImage = self.sourceImageViewModel?.image {
            print("custom confirmed on image \(sourceImage) with \(width) : \(height)")

        }
        

    }
}