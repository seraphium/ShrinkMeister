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
        if !toggleSize {
            let width = op[1] as! Int
            let height = op[2] as! Int
            print("custom pixel:\(width):\(height)")

            if let destImage = image.resizeImageByPixel(CGSizeMake(CGFloat(width), CGFloat(height))){
               return destImage
            } else {
                return nil
            }
            
        } else {
            let size = op[1] as! Int
            print("Size:\(size)")
            return image.resizeBySize(size)
        
        }
        
    }
    
   

}
