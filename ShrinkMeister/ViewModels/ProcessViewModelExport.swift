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
    var otherCommand : RACCommand!
    
     init() {
        
        super.init(title: "Export", image: UIImage(named: "export"))
        
        exportCommand  = RACCommand() {
                (any:AnyObject!) -> RACSignal in
                return self.executeExportSignal()
        }
        
        otherCommand = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            
            NotificationHelper.postNotification("OpenShare", objects: self, userInfo: nil)
            
            return RACSignal.empty()
            
        }

        
     }
    
    override func beforeProcess() {
    }
    
    override func imageDidSet() {
       
    }
    
    func image(image: UIImage!, didFinishSavingWithError error: NSError!, contextInfo: AnyObject!) {
        if (error != nil) {
            print ("photo saving to album failed")
        } else {
            print ("photo saved to album")

            NotificationHelper.postNotification("ExportPhotoSucceed", objects: self, userInfo: nil)
        }
    }
    
    func executeExportSignal() -> RACSignal {
        
        let mainViewModel = AppDelegate.viewModelLocator.getViewModel("Main") as! MainViewModel

        if let image = mainViewModel.currentImage {
            
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(ProcessViewModelExport.image(_:didFinishSavingWithError:contextInfo:)), nil)

        }
        
        return RACSignal.empty()
    }
}