//
//  NotificationHelper.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/4.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import Foundation
import ReactiveCocoa

class NotificationHelper {
    
    static func postNotification(name: String, objects : AnyObject?) {
        NSNotificationCenter.defaultCenter().postNotificationName(name, object: objects)

    }
    
    static func observeNotification(name: String, object: AnyObject?, owner: AnyObject, handleBlock: ((AnyObject!) -> Void)!) {
        NSNotificationCenter.defaultCenter()
            .rac_addObserverForName("PushAddPhoto", object: object)
            .takeUntil(owner.rac_willDeallocSignal())
            .subscribeNext(handleBlock)
    }
    
}