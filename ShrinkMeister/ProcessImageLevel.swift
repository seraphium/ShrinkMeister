//
//  ProcessImageLevel.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/11.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit

class ProcessImageLevel : ProcessServiceProtocol {
    
    func processImage(image: UIImage, options: [AnyObject]?) -> UIImage {
        print ("process image for level")
        return image
    }

}