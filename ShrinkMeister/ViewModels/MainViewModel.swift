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
    
    var imageStore : ImageStore!
    
    dynamic var processEnabled : Bool = false
    
    var addPhotoCommand: RACCommand?
    
    var processViewModels = [BaseProcessViewModel]()
    
    //TODO: should include viewmodel for each cell
    
    func initProcessViewModel() {
        let processViewModelLevel = ProcessViewModelLevel()
        let processViewModelCustom = ProcessViewModelCustom()

        RACObserve(self, keyPath: "imageViewModel").skip(1).subscribeNextAs {
            (imageViewModel:ImageViewModel) -> () in
            processViewModelLevel.sourceImageViewModel = imageViewModel
            processViewModelCustom.sourceImageViewModel = imageViewModel
        }
        
        processViewModels.append(processViewModelLevel)
        processViewModels.append(processViewModelCustom)
    }
    
    override init() {
        super.init()
        
        initProcessViewModel()
        
        imageStore = AppDelegate.imageStore
        
        loadImage()
        
        addPhotoCommand = RACCommand() {
            (any: AnyObject!) -> RACSignal in

            let image = any as! UIImage
            //put image into viewmodel
            
            self.addPhotoToStore(image, forKey: NSUUID().UUIDString)
            
            return RACSignal.empty()
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
        
        imageStore.setImage(image, forKey: key)
        
        //set userdefault with image key
        NSUserDefaults.standardUserDefaults().setValue(key, forKey: "latestImageKey")
        

    }
}
