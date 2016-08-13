//
//  ProcessImageLevel.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/11.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit

class ProcessImageCustom : ProcessServiceProtocol {
    
    func processImage(image: UIImage, options: [AnyObject]?) -> UIImage {
        print ("process image custom for \(options):")
        return image
    }

}