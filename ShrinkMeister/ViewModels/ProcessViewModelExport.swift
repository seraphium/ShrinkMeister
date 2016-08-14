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
    
    var exportCommand : RACCommand!
    
     init() {
        
        super.init(title: "Export", image: UIImage(named: "sample"))
        
        exportCommand  = RACCommand() {
                (any:AnyObject!) -> RACSignal in
                return self.executeExportSignal()
        }

        
     }
    
    override func beforeProcess() {
    }
    
    override func imageDidSet() {
       
    }
    
    func executeExportSignal() -> RACSignal {
        
        print ("export image")
        return RACSignal.empty()
    }
}