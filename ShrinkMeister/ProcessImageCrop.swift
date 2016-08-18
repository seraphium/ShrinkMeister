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
        var rect = options![0] as! CGRect
        let sourceImageFrame = options![1] as! CGRect
        print ("process image for crop \(rect) in frame \(sourceImageFrame)")
        print ("image scale : \(image.scale)")
        
        let x = rect.origin.x - sourceImageFrame.origin.x
        let y = rect.origin.y - sourceImageFrame.origin.y
        let factor = min(sourceImageFrame.width / image.size.width, sourceImageFrame.height / image.size.height)
        let width = rect.width / factor
        let height = rect.height / factor
        var cropRect = CGRectMake(x, y, width, height)
        if (image.scale > 1.0) {
            cropRect = CGRectMake(cropRect.origin.x * image.scale,
                              cropRect.origin.y * image.scale,
                              cropRect.size.width * image.scale,
                              cropRect.size.height * image.scale);
        }
        
        let imageRef = CGImageCreateWithImageInRect(image.CGImage, cropRect);
        let result = UIImage(CGImage: imageRef!, scale: image.scale, orientation: image.imageOrientation)
     
      /*  UIGraphicsBeginImageContextWithOptions(cropRect.size, true, 1)
        image.drawInRect(sourceImageFrame)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        */
        return result

    }

}