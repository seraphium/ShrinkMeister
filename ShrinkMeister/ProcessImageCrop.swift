//
//  ProcessImageLevel.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/11.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit

class ProcessImageCrop : ProcessServiceProtocol {
    
    // process logic here
    func processImage(image: UIImage, options: [Any]?) -> UIImage? {
        let rect = options![0] as! CGRect
        let sourceImageFrame = options![1] as! CGRect
        print ("process image for crop \(rect) in frame \(sourceImageFrame)")

        return image
    }

}