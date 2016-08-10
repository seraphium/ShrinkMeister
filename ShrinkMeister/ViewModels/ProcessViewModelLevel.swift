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
        
        self.confirmCommand = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            self.confirm()
            return RACSignal.empty()
        }
        
        
    }
    
    override func confirm() {
      
        //actual processing logic
        if let sourceImage = self.sourceImageViewModel?.image {
            print ("processing image \(sourceImage) with level:\(imageLevel)")

        } else {
            print ("no image")
        }
        
        
    }

    
}