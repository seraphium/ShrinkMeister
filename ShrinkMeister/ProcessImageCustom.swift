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
    func processImage(image: UIImage, options: [AnyObject]?) -> UIImage? {
        guard let op = options else {
            return nil
        }
        print ("process image custom for \(options):")
        let width = op[0]
        let height = op[1]
        
        
        return image
    }

}