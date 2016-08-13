//
//  ProcessServiceProtocol.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/11.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit


protocol ProcessServiceProtocol {
    

    func processImage(image: UIImage, options: [AnyObject]?) -> UIImage
}