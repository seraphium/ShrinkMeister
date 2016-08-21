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
        
        super.init(title: "Basic", image: UIImage(named: "shrink"))
        rotateLeftCommand = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            return self.executeRotateSignal(true)
            
        }

        rotateRightCommand = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            return self.executeRotateSignal(false)
        }
        
    }


    func executeRotateSignal(left: Bool) -> RACSignal {
        //actual processing logic
        if let sourceImage = self.sourceImageViewModel?.image {
            
            let service = processService as! ProcessImageBasic
            
            if let destImage = service.processRotateImage(sourceImage, options: [left]){
                //send result to mainviewmodel
                NotificationHelper.postNotification("FinishProcess", objects: self,
                                                    userInfo: ["image": destImage])
                
            } else {
                return RACSignal.error(processError)
            }
            
            
        } else {
            print ("no image")
        }
        
        self.afterProcess()
        
        return RACSignal.empty()
        
    }

    
    override func beforeProcess() {
        self.parameters = [imageLevel]
        
    }

    
    override func imageDidSet() {

        
    }

    
}