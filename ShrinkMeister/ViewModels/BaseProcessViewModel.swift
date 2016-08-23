
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

    var parameters : [Any]?
    
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
            NotificationHelper.postNotification("StartProcess", objects: self, userInfo: nil)
            return self.executeProcessSignal()
        }
        
    }
    
    func beforeProcess() {
        NotificationHelper.postNotification("beforeProcess", objects: self, userInfo: nil)


    }
    
    func afterProcess() {
        NotificationHelper.postNotification("afterProcess", objects: self, userInfo: nil)

    }
    
    func executeProcessSignal() -> RACSignal {
        //actual processing logic
        if let sourceImage = self.sourceImageViewModel?.image {
            //set parameters in this delegate
            self.beforeProcess()
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) {
                
                let destImage = self.processService.processImage(sourceImage, options: self.parameters)
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.afterProcess()

                    NotificationHelper.postNotification("FinishProcess", objects: self,
                                                        userInfo: ["image": destImage!])
                }
            }
            
            
        }
        
        return RACSignal.empty()

   
    }
    
    func imageDidSet() {
        fatalError("imageDidSet has not been implemented")

    }
}