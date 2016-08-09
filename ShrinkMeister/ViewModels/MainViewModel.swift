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
    
    dynamic var imageViewModel : ImageViewModel?  
    
    var imageStore : ImageStore!
    
    var addPhotoCommand: RACCommand?
    
    var processViewModels = [BaseProcessViewModel]()
    
    //TODO: should include viewmodel for each cell
    
    func initProcessViewModel() {
        processViewModels.append(ProcessViewModelLevel())
        processViewModels.append(ProcessViewModelCustom())
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
    }

    
    //MARK: private methods
    

    func addPhotoToStore(image: UIImage, forKey key: String)
    {
        self.imageViewModel = ImageViewModel(image: image, key: key)
        
        imageStore.setImage(image, forKey: key)

    }
}
