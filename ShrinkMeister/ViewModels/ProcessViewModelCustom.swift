//
//  ProcessViewModelLevel.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/9.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import Foundation
import UIKit

class ProcessViewModelCustom : BaseProcessViewModel {
    
    override init() {
        super.init()
        self.title = "Custom"
        self.image = UIImage(named: "sample")
    }
}