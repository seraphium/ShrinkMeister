//
//  ProcessViewModelLevel.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/9.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ProcessViewModelExport : BaseProcessViewModel {
    
     init() {
        
        super.init(title: "Export", image: UIImage(named: "sample"))
        
     }
    
    override func beforeProcess() {
    }
    
    override func imageDidSet() {
       
    }
}