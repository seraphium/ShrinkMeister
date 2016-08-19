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

    var transAspectCommand : RACCommand!
    
    var aspect : Double {
        var aspectValue : Double
        switch aspectLevel {
        case 0: //1:1
            aspectValue = 1 / 1
        case 1: // 3:2
            aspectValue = Double(3.0)/Double(2.0)
        case 2: //4:3
            aspectValue = Double(4.0)/Double(3.0)
        case 3: //16:9
            aspectValue = Double(16.0)/Double(9.0)
        default:
            aspectValue = 1.0
            break;
        }
        
        if !horizontal && aspectValue != 0 {
            aspectValue = 1 / aspectValue
        }
        return aspectValue
        
    }
    
    var horizontal : Bool = true
    
    dynamic var cropMode: Bool = false
    
    
    dynamic var aspectLevel : Int = 0 {
        didSet {
            horizontal = true
            startCrop(aspect)
            
        }
    }

    
    var cropRect: CGRect!
    var sourceImageFrame: CGRect!
    

    init() {
        
        super.init(title: "Crop", image: UIImage(named: "sample"))
        
        aspectLevel = 0
        
         transAspectCommand   = RACCommand() {
                (any:AnyObject!) -> RACSignal in
                self.horizontal = !self.horizontal
                self.startCrop(self.aspect)
                return RACSignal.empty()
        }


    }

    func startCrop(aspectValue : Double) {
        
        NotificationHelper.postNotification("EnterCrop", objects: self, userInfo:
            ["aspect":aspectValue])
        
        self.cropMode = true
        
    }
    override func beforeProcess() {
        self.parameters = [cropRect, sourceImageFrame]
    }
    
    override func afterProcess() {
        
        self.cropMode = false

        NotificationHelper.postNotification("ExitCrop", objects: self, userInfo: nil)

        
    }
    
    override func imageDidSet() {

        
    }


}