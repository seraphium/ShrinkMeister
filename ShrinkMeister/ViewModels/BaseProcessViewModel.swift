
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
    
    var processService: ProcessImageService?

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
        fatalError("imageDidSet has not been implemented")

    
    }
    
    func imageDidSet() {
        fatalError("imageDidSet has not been implemented")

    }
}