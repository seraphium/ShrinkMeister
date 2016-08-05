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
    
    
    var executeCommand: RACCommand?

    override init() {
        super.init()
        executeCommand = RACCommand() {
            (any: AnyObject!) -> RACSignal in
            return self.executeProcessSignal()
        }
        
    }
    
    //MARK: private methods
    
    private func executeProcessSignal() -> RACSignal {
        return RACSignal.createSignal({
            (subscriber: RACSubscriber!) -> RACDisposable! in
            print ("execute process")
            


        //    let addPhotoVM = AppDelegate.viewModelLocator.getViewModel("AddPhoto") as! AddPhotoViewModel
            
            NotificationHelper.postNotification("PushAddPhoto", objects: nil, userInfo: nil)
            
            subscriber.sendCompleted()
            return RACDisposable(){
                
            }
        })
    }
}
