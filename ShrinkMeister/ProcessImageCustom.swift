//
//  ProcessImageLevel.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/11.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit

class ProcessImageCustom : ProcessServiceProtocol {
    
    // process logic here
    func processImage(image: UIImage, options: [Any]?) -> UIImage? {
        guard let op = options else {
            return nil
        } 
        print ("process image custom for \(options):")
        let width = op[0] as! Int
        let height = op[1] as! Int
        
        let destImage = ResizeImage(image, targetSize: CGSizeMake(CGFloat(width), CGFloat(height)))
        
        print ("finished process ,dest image: \(destImage.size.width): \(destImage.size.height)")
        return destImage
    }
    
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        
        let rect = CGRectMake(0, 0, targetSize.width, targetSize.height)
        
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

}