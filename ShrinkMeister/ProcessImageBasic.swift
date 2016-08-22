//
//  ProcessImageLevel.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/11.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit

class ProcessImageBasic : ProcessServiceProtocol {
    
    func processRotateImage(image: UIImage, options: [Any]?) -> UIImage? {
        let left = options![0] as! Bool
        return image.rotateTo(left)
    }
    
    // process logic here
    func processImage(image: UIImage, options: [Any]?) -> UIImage? {
        print ("process image level for options: \(options)")
        guard let op = options else {
            return nil
        }
        let level = op[0] as! Int
        
        return image.resizeImageByLevel(level)
    }

}

