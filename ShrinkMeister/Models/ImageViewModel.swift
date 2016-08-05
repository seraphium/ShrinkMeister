//
//  ImageViewModel.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/3.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit

class ImageViewModel : ViewModel {
    
    var image : UIImage!
    
    var key : String!
    
    override init() {
        super.init()
    }
    
    init(image: UIImage, key: String) {
        self.image = image
        self.key = key
        super.init()
    }
}