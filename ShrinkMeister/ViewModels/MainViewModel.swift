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
    
    dynamic var imageViewModel : ImageViewModel? {
        didSet {
            if let _ = imageViewModel {
                self.processEnabled = true
            } else {
                self.processEnabled = false
            }
        }
    }
    
    dynamic var processedImageViewModel : ImageViewModel?
    
    var imageStore : ImageStore!
    
    dynamic var processEnabled : Bool = false
    
    var addPhotoCommand: RACCommand?
    
    var reloadPhotoCommand: RACCommand?
    
    var processViewModels = [BaseProcessViewModel]()
    
    var cropRect : CGRect?
    
    //TODO: should include viewmodel for each cell
    
    func initProcessViewModel() {
        
        
        let processViewModelBasic = ProcessViewModelBasic()
        processViewModelBasic.processService = ProcessImageBasic()
        
        let processViewModelCrop = ProcessViewModelCrop()
        processViewModelCrop.processService = ProcessImageCrop()
    
        let processViewModelCustom = ProcessViewModelCustom()
        processViewModelCustom.processService = ProcessImageCustom()
        
        
        let processViewModelExport = ProcessViewModelExport()    
        
        processViewModels.append(processViewModelBasic)
        processViewModels.append(processViewModelCrop)
        processViewModels.append(processViewModelCustom)
        processViewModels.append(processViewModelExport)
        
        RACObserve(self, keyPath: "imageViewModel").skip(1).subscribeNextAs {
            (imageViewModel:ImageViewModel) -> () in
            
            for vm in self.processViewModels {
                vm.sourceImageViewModel = imageViewModel
            }
            
            NSUserDefaults.standardUserDefaults().removeObjectForKey("latestImageKey")

            NotificationHelper.postNotification("loaded", objects: self, userInfo: nil)
        }
        
        RACObserve(self, keyPath: "processedImageViewModel")
            .filter {
                (next: AnyObject?) -> Bool in
                return next != nil
            } .subscribeNextAs {
            (imageViewModel:ImageViewModel) -> () in

            for vm in self.processViewModels {
                    vm.sourceImageViewModel = imageViewModel
            }
                
            self.imageStore.setImage(imageViewModel.image, forKey: imageViewModel.key)

        }
        
      
    }
    
    override init() {
        super.init()
        
        initProcessViewModel()
        
        imageStore = AppDelegate.imageStore
        
        addPhotoCommand = RACCommand() {
            (any: AnyObject!) -> RACSignal in

            let image = any as! UIImage
            //put image into viewmodel
            
            self.addPhotoToStore(image, forKey: NSUUID().UUIDString)
            
            return RACSignal.empty()
        }
        
        reloadPhotoCommand = RACCommand() {
            (any: AnyObject!) -> RACSignal in
            print("reload photo")

            //reset processimageviewmodel 
            self.processedImageViewModel = nil
            if let imageVM = self.imageViewModel {
                self.imageViewModel = ImageViewModel(image: imageVM.image, key: imageVM.key)
            }
     
            return RACSignal.empty()
        }
        
        NotificationHelper.observeNotification("FinishProcess", object: nil, owner: self) {
            notify in //passed in NSNotification
            let image = notify.userInfo["image"] as! UIImage
            self.processedImageViewModel = ImageViewModel(image: image, key: (self.imageViewModel?.key)!)
            
        }
        
    }

    //load last image from imageStore , if not exists, load default
    func loadImage() {
        if let latestImagekey = NSUserDefaults.standardUserDefaults().stringForKey("latestImageKey") {
            if let latestImage = imageStore.imageForKey(latestImagekey) {
                imageViewModel = ImageViewModel(image: latestImage, key: latestImagekey)

            }

        }
        
        
    }
    
    func addPhotoToStore(image: UIImage, forKey key: String)
    {
        imageViewModel = ImageViewModel(image: image, key: key)
        

    }
}

