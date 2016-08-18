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

    var toggleCommand : RACCommand!
    
    dynamic var cropMode: Bool = false
    
    
    dynamic var aspectLevel : Int = 0 {
        didSet {
            startCrop()
            
        }
    }

    
    var cropRect: CGRect!
    var sourceImageFrame: CGRect!
    
    func getAspect(level: Int) -> Double {
        var aspect : Double = 0.0
        switch level {
        case 0: //1:1
            aspect = 1 / 1
        case 1: // 3:2
            aspect = Double(3.0)/Double(2.0)
        case 2: //4:3
            aspect = Double(4.0)/Double(3.0)
        case 3: //16:9
            aspect = Double(16.0)/Double(9.0)
        default:
            aspect = 1.0
            break;
        }
        
        return aspect

    }
    init() {
        
        super.init(title: "Crop", image: UIImage(named: "sample"))
        
        aspectLevel = 0

    }

    func startCrop() {
        
        let aspect = self.getAspect(self.aspectLevel)
        
        NotificationHelper.postNotification("EnterCrop", objects: self, userInfo:
            ["aspect":aspect])
        
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