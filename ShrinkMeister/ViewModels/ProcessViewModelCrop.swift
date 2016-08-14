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

    
    init() {
        
        super.init(title: "Crop", image: UIImage(named: "sample"))
        
    }

    override func beforeProcess() {
        
    }
    
    override func imageDidSet() {

        
    }

    
}