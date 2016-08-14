//
//  ProcessImageLevel.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/11.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit

class ProcessImageExport : ProcessServiceProtocol {
    
    // process logic here
    func processImage(image: UIImage, options: [AnyObject]?) -> UIImage? {
        print ("exporting photo for image:\(image.size.width) : \(image.size.height)")
       
        return image
    }

}