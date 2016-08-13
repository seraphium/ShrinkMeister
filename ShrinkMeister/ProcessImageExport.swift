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
        print ("process image for options: \(options)")
        guard let op = options else {
            return nil
        }
        
        return image
    }

}