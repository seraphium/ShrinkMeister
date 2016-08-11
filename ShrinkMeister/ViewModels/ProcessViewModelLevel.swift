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


class ProcessViewModelLevel : BaseProcessViewModel {

    dynamic var imageLevel : Int = 0 {
        didSet {
            print ("imageLevel:\(imageLevel)")
        }
    }
    
    init() {
        
        super.init(title: "Level", image: UIImage(named: "sample"))
        
    }
    
    
    override func executeProcessSignal() -> RACSignal {
        //actual processing logic
        if let sourceImage = self.sourceImageViewModel?.image {
            print ("processing image \(sourceImage) with level:\(imageLevel)")
            
            processService.processImage(sourceImage, options: nil)
            
        } else {
            print ("no image")
        }

        return RACSignal.empty()
        
    }
    

    
    override func imageDidSet() {

        
    }

    
}