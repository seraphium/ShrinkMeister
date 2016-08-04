//
//  ViewModelLocator.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/3.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import Foundation
import UIKit

class ViewModelLocator {
    
    private var viewModels = [String : ViewModel]()
    
    internal func addViewModel(name: String, withViewModel vm: ViewModel)
    {
        viewModels[name] = vm
    }
    
    internal func getViewModel(name: String) -> ViewModel? {
        if let model = viewModels[name] {
            return model
        } else {
            return nil
        }
    }
    
    init()
    {
        self.addViewModel("Main", withViewModel: MainViewModel())
        self.addViewModel("AddPhoto", withViewModel: AddPhotoViewModel())

    }
}