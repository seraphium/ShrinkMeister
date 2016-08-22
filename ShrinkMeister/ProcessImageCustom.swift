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
        let toggleSize = op[0] as! Bool
        var destImage : UIImage
        if !toggleSize {
            let width = op[1] as! Int
            let height = op[2] as! Int
            print("custom pixel:\(width):\(height)")

            destImage = image.ResizeImage(CGSizeMake(CGFloat(width), CGFloat(height)))
        } else {
            let size = op[1] as! Int
            print("Size:\(size)")
            destImage = image
        }
        
        return destImage
    }
    
   

}

extension UIImage {
    func ResizeImage(targetSize: CGSize) -> UIImage {
        
        let rect = CGRectMake(0, 0, targetSize.width, targetSize.height)
        
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
        self.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}