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


class ProcessViewModelBasic : BaseProcessViewModel {

    dynamic var imageLevel : Int = 0 {
        didSet {
            print ("imageLevel:\(imageLevel)")
        }
    }
    
    init() {
        
        super.init(title: "Basic", image: UIImage(named: "sample"))
        
    }

    override func beforeProcess() {
        self.parameters = [imageLevel]
    }

    
    override func imageDidSet() {

        
    }

    
}