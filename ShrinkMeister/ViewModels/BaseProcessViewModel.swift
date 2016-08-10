
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
    
    var confirmCommand : RACCommand!
    
    dynamic var sourceImageViewModel : ImageViewModel?

    init(title: String?, image: UIImage?)
    {
        self.title = title
        self.image = image
        
        super.init()
        
        self.confirmCommand = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            self.confirm()
            return RACSignal.empty()
        }
        

    }
    
    
    func confirm() {
        fatalError("confirm has not been implemented")

    }
}