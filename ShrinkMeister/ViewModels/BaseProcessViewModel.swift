
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

    var confirmCommand : RACCommand!
    
    
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
    
    
    func executeProcessSignal() -> RACSignal {
        //actual processing logic
        if let sourceImage = self.sourceImageViewModel?.image {
            
            let destImage = processService.processImage(sourceImage, options: nil)
            
            //send result to mainviewmodel
            NotificationHelper.postNotification("FinishProcess", objects: self,
                                                userInfo: ["image": destImage])
            
        } else {
            print ("no image")
        }
        
        return RACSignal.empty()
   
    }
    
    func imageDidSet() {
        fatalError("imageDidSet has not been implemented")

    }
}