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
        let rotateSize = CGSize(width: image.size.height, height: image.size.width)
        var resultImage : UIImage?
        UIGraphicsBeginImageContextWithOptions(rotateSize, true, image.scale)
        if let context = UIGraphicsGetCurrentContext() {
            if !left {
                CGContextRotateCTM(context, 90.0 * CGFloat(M_PI) / 180.0)
                CGContextTranslateCTM(context, 0, -image.size.height)

            } else {
                CGContextRotateCTM(context, -90.0 * CGFloat(M_PI) / 180.0)
                CGContextTranslateCTM(context, -image.size.width, 0)

            }
            image.drawInRect(CGRectMake(0, 0, image.size.width, image.size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
    
        
        return resultImage
    }
    // process logic here
    func processImage(image: UIImage, options: [Any]?) -> UIImage? {
        print ("process image level for options: \(options)")
        guard let op = options else {
            return nil
        }
        let level = op[0] as! Int
        let sizeRate : CGFloat
        let rate : CGFloat
        switch level {
        case 0:
            rate = 0.2
            sizeRate = 1.5
        case 1:
            rate = 0.05
            sizeRate = 2
        case 2:
            rate = 0.0
            sizeRate = 4
        default:
            rate = 1.0
            sizeRate = 1
        }
        
        //scale down first
        let targetSize = CGSizeMake(image.size.width / sizeRate,image.size.height / sizeRate)
        let scaledImage = image.ResizeImage(targetSize)
        
        //compression
        if let resultImageData = UIImageJPEGRepresentation(scaledImage, rate) {
            return UIImage(data: resultImageData)

        } else {
            return nil
        }
        
    }

}

