//
//  UIImageExtension.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/22.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit

func rad(deg : Double) -> CGFloat {
    return CGFloat(deg / 180.0 * M_PI)
}

extension UIImage {
    
    //crop image by rect
    func cropTo(sourceImageFrame: CGRect, rect: CGRect) -> UIImage? {
        
        let factor = min(sourceImageFrame.width / self.size.width, sourceImageFrame.height / self.size.height)
        let x = (rect.origin.x - sourceImageFrame.origin.x) / factor
        let y = (rect.origin.y - sourceImageFrame.origin.y) / factor
        let width = rect.width / factor
        let height = rect.height / factor
        var cropRect = CGRectMake(x, y, width, height)
        if (self.scale > 1.0) {
            cropRect = CGRectMake(cropRect.origin.x * self.scale,
                                  cropRect.origin.y * self.scale,
                                  cropRect.size.width * self.scale,
                                  cropRect.size.height * self.scale);
        }
        
        var rectTransform : CGAffineTransform
        switch self.imageOrientation {
        case .Left:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(90)),
                                                       0, -self.size.height);
            break;
        case .Right:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-90)),
                                                       -self.size.width, 0);
            break;
        case .Down:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-180)),
                                                       -self.size.width, -self.size.height);
            break;
        default:
            rectTransform = CGAffineTransformIdentity;
        };
        
        rectTransform = CGAffineTransformScale(rectTransform, self.scale, self.scale);
        let translatedCropRect = CGRectApplyAffineTransform(cropRect, rectTransform)
        let imageRef = CGImageCreateWithImageInRect(self.CGImage, translatedCropRect);
        let result = UIImage(CGImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        
        return result
    }
    
    //rotate image
    func rotateTo(left: Bool) -> UIImage? {
        let rotateSize = CGSize(width: self.size.height, height: self.size.width)
        var resultImage : UIImage?
        UIGraphicsBeginImageContextWithOptions(rotateSize, true, self.scale)
        if let context = UIGraphicsGetCurrentContext() {
            if !left {
                CGContextRotateCTM(context, 90.0 * CGFloat(M_PI) / 180.0)
                CGContextTranslateCTM(context, 0, -self.size.height)
                
            } else {
                CGContextRotateCTM(context, -90.0 * CGFloat(M_PI) / 180.0)
                CGContextTranslateCTM(context, -self.size.width, 0)
                
            }
            self.drawInRect(CGRectMake(0, 0, self.size.width, self.size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        
        return resultImage
    }
    
    //resize image by pixel width x height
    func ResizeImageByPixel(targetSize: CGSize) -> UIImage? {
        
        let rect = CGRectMake(0, 0, targetSize.width, targetSize.height)
        
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
        self.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func ResizeImageByLevel(level : Int) -> UIImage? {
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
        let targetSize = CGSizeMake(self.size.width / sizeRate,self.size.height / sizeRate)
        let scaledImage = self.ResizeImageByPixel(targetSize)
        
        //compression
        if let scaled = scaledImage {
            if let resultImageData = UIImageJPEGRepresentation(scaled, rate) {
                return UIImage(data: resultImageData)
                
            } else {
                return nil
            }
        } else {
            return nil
        }
        

    }

}
