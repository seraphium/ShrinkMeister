//
//  ProcessViewModelLevel.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/9.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import Foundation
import UIKit

class ProcessViewModelLevel : BaseProcessViewModel {
    
    override init() {
        super.init()
        self.title = "Level"
        self.image = UIImage(named: "sample")
    }
    
}