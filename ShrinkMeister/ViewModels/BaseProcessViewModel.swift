
//
//  ProcessViewModel.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/6.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit
import ReactiveCocoa

class BaseProcessViewModel : ViewModel, ProcessViewModelProtocol {
    
    var title : String?
    
    var image : UIImage?
    
    var processService: ProcessServiceProtocol!

    var parameters : [AnyObject]?
    
    var confirmCommand : RACCommand!
    
    let processError = NSError(domain: "zezhang.process", code: 1, userInfo: nil)

    
    dynamic var sourceImageViewModel : ImageViewModel? {
        didSet {
            self.imageDidSet()
        }
    }

    init(title: String?, image: UIImage?)
    {
        self.title = title
        self.image = image
        super.init()
        
        self.confirmCommand = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            return self.executeProcessSignal()
        }

    }
    
    func beforeProcess() {
        fatalError("beforeProcess has not been implemented")

    }
    
    func executeProcessSignal() -> RACSignal {
        //actual processing logic
        if let sourceImage = self.sourceImageViewModel?.image {
            
            //set parameters in this delegate
            self.beforeProcess()
            
            if let destImage = processService.processImage(sourceImage, options: parameters) {
                //send result to mainviewmodel
                NotificationHelper.postNotification("FinishProcess", objects: self,
                                                    userInfo: ["image": destImage])
                
            } else {
                return RACSignal.error(processError)
            }
            
            
        } else {
            print ("no image")
        }
        
        return RACSignal.empty()
   
    }
    
    func imageDidSet() {
        fatalError("imageDidSet has not been implemented")

    }
}