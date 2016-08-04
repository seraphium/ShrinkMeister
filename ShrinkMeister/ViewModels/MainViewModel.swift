//
//  MainViewModel.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/3.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa

class MainViewModel : ViewModel {
    
    var vara = 3
    
    var executeProcess: RACCommand?

    override init() {
        super.init()
        executeProcess = RACCommand() {
            (any: AnyObject!) -> RACSignal in
            return self.executeProcessSignal()
        }
        
    }
    
    //MARK: private methods
    
    private func executeProcessSignal() -> RACSignal {
        return RACSignal.createSignal({
            (subscriber: RACSubscriber!) -> RACDisposable! in
            print ("execute process")
            
            
            subscriber.sendCompleted()
            return RACDisposable(){
                
            }
        })
    }
}
