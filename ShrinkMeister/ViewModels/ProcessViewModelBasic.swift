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


class ProcessViewModelBasic : BaseProcessViewModel {

    dynamic var imageLevel : Int = 0 {
        didSet {
            print ("imageLevel:\(imageLevel)")
        }
    }
    
    var rotateLeftCommand : RACCommand!
    var rotateRightCommand : RACCommand!
    
    
    init() {
        
        super.init(title: "Basic", image: UIImage(named: "sample"))
        rotateLeftCommand = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            self.rotate(true)
            
            return RACSignal.empty()
        }

        rotateRightCommand = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            self.rotate(false)
            
            return RACSignal.empty()
        }
        
    }

    func rotate(left: Bool){
        print("rotate left: \(left)")
    }
    
    override func beforeProcess() {
        self.parameters = [imageLevel]
    }

    
    override func imageDidSet() {

        
    }

    
}