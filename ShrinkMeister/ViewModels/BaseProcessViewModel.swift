
//
//  ProcessViewModel.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/6.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit
import ReactiveCocoa

class BaseProcessViewModel : ViewModel {
    
    var title : String?
    
    var image : UIImage?
    
    var confirmCommand : RACCommand!
    
    init(title: String?, image: UIImage?)
    {
        self.title = title
        self.image = image
    }
    
}