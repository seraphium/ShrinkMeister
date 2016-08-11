//
//  ProcessImageService.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/11.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit

class  ProcessImageService  {
    
    private var processMethod : ProcessServiceProtocol
    
    init(method: ProcessServiceProtocol)
    {
        self.processMethod = method
    }
    
    func processImage(image: UIImage, options: [AnyObject]?)
    {
        processMethod.ProcessImage(image, options: options)
    }
    
}