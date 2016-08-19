//
//  CroppableImageView.swift
//  CropImg
//
//  Created by Duncan Champney on 3/24/15.
//  Copyright (c) 2015 Duncan Champney. All rights reserved.
//

import UIKit

//-------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------
class CroppableImageView: UIView, CornerpointClientProtocol
{
  // MARK: - properties -

    var sourceImageFrame: CGRect!
    var  imageRect: CGRect? {
        didSet {
            if let layer = imageLayer {
                layer.removeFromSuperlayer()
            }
            if let rect = imageRect {
                imageLayer = CALayer()
              //  imageLayer?.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.3).CGColor
                imageLayer!.frame = rect
                self.layer.addSublayer(imageLayer!)
                print("image layer added")
            }
        }
    }
    
    var imageLayer: CALayer?
    
    var aspect: Double = 0.0 {
        didSet {
            generateCropRect()
        }
    }
    
  var lockAspect : Bool = true
    
  var draggingRect: Bool = false

  @IBOutlet var  cropDelegate: CroppableImageViewDelegateProtocol?
  let dragger: UIPanGestureRecognizer
  var cornerpoints =  [CornerpointView]()
  

  var startPoint: CGPoint?
  private var internalCropRect: CGRect?
  var cropRect: CGRect?
    {
    set
    {
      if let realCropRect = newValue
      {
        let newRect:CGRect =  CGRectIntersection(realCropRect, imageRect!)
        internalCropRect = newRect
        cornerpoints[0].centerPoint = newRect.origin
        cornerpoints[1].centerPoint = CGPointMake(CGRectGetMaxX(newRect), newRect.origin.y)
        cornerpoints[3].centerPoint = CGPointMake(newRect.origin.x, CGRectGetMaxY(newRect))
        cornerpoints[2].centerPoint = CGPointMake(CGRectGetMaxX(newRect),CGRectGetMaxY(newRect))
      }
      else
      {
        internalCropRect = nil
        for aCornerpoint in cornerpoints
        {
          aCornerpoint.centerPoint = nil;
        }
      }
      if let cropDelegate = cropDelegate
      {
        let rectIsTooSmall: Bool = internalCropRect == nil ||
          internalCropRect!.size.width < 5 ||
          internalCropRect!.size.height < 5
        cropDelegate.haveValidCropRect(internalCropRect != nil && !rectIsTooSmall)
        
        if let rect = cropRect {
            cropDelegate.updateCropRect(rect, inFrame: self.sourceImageFrame)
        }
      }
      
      
      self.setNeedsDisplay()
    }
    get
    {
      return internalCropRect
    }

  }
  //-------------------------------------------------------------------------------------------------------
  // MARK: - Designated initializer(s)
  //-------------------------------------------------------------------------------------------------------

   required init?(coder aDecoder: NSCoder)
  {
    for i in 1...4
    {
      let aCornerpointView = CornerpointView()
       cornerpoints.append(aCornerpointView)
      //cornerpoints += [CornerpointView()]
    }
    
    dragger = UIPanGestureRecognizer()

    super.init(coder: aDecoder)
    
    self.userInteractionEnabled = false
    
    dragger.addTarget(self, action: #selector(CroppableImageView.handleDragInView(_:)))

    self.addGestureRecognizer(dragger)

    self.hidden = true
  }
  
//---------------------------------------------------------------------------------------------------------
// MARK: - UIView methods
//---------------------------------------------------------------------------------------------------------

  override func awakeFromNib()
  {
    super.awakeFromNib()

    self.backgroundColor = UIColor.clearColor()
    
    for aCornerpoint in cornerpoints
    {
      self.addSubview(aCornerpoint)
      aCornerpoint.cornerpointDelegate = self;
    }
   
    cropRect = nil;
    
  }
  
  func generateCropRect() {
        if let rect = imageRect {
            let centerX = rect.midX
            let centerY = rect.midY
            
            //first try calculate from height
            var height = CGFloat(sourceImageFrame.height * 2/3)
            var width = CGFloat(Double(height) * aspect)
            
            //calculated width exceed image frame, change to calculate from width
            if width > sourceImageFrame.width {
                width = CGFloat(sourceImageFrame.width * 2/3)
                height = CGFloat(Double(width) * (1 / aspect))
            }
        
            cropRect = CGRectMake(CGFloat(centerX - width/2), CGFloat(centerY-height/2), width, height)
        }
    }

    func resetRectFromAspect() {
        if let rect = cropRect {
            cropRect = CGRectMake(rect.origin.x , rect.origin.y, rect.height * CGFloat(aspect), rect.width)
        }
   
    }
    
  override func layoutSubviews()
  {
    super.layoutSubviews()
    cropRect = nil;

  }
  
//--------------------------------------------------------------------------------------------------------
  
    func rectFromStartAndEnd(var startPoint:CGPoint, endPoint: CGPoint) -> CGRect
    {
        var  top, left, bottom, right: CGFloat;
        top = min(startPoint.y, endPoint.y)
        bottom = max(startPoint.y, endPoint.y)
        
        left = min(startPoint.x, endPoint.x)
        right = max(startPoint.x, endPoint.x)
        
        let result = CGRectMake(left, top, right-left, bottom-top)
        return result
    }
    
 override func drawRect(rect: CGRect)
  {
    //Drawing the image in drawRect is too slow. 
    //Switched to installing the image bitmap into a view layer's content
    //myImage?.drawInRect(imageRect!)
    
    if let realCropRect = internalCropRect
    { 
      let path = UIBezierPath(rect: realCropRect)
     // path.lineWidth = 3.0
     // UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).set()
     // path.stroke()
      path.lineWidth = 1.0
      UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5).set()
      path.stroke()
    }
  }

//---------------------------------------------------------------------------------------------------------
// MARK: - custom instance methods -
//-------------------------------------------------------------------------------------------------------
  
  func handleDragInView(thePanner: UIPanGestureRecognizer)
  {
    var newPoint = thePanner.locationInView(self)
    switch thePanner.state
    {
    case UIGestureRecognizerState.Began:
      
      //if we have a crop rect and the touch is inside it, drag the entire rect.
      if let requiredCropRect = internalCropRect
      {
        if CGRectContainsPoint(requiredCropRect, newPoint)
        {
          startPoint = requiredCropRect.origin
          draggingRect = true;
          thePanner.setTranslation(CGPointZero, inView: self)
        }
      }
      if !draggingRect
      {
        //Start definining a new cropRect
        startPoint = newPoint
        draggingRect = false;
      }
      
    case UIGestureRecognizerState.Changed:
      
      //If the user is dragging the entire rect, don't let it be draggged out-of-bounds
      if draggingRect
      {
        
        let newX = max(startPoint!.x + thePanner.translationInView(self).x,0)
        let newY = max(startPoint!.y + thePanner.translationInView(self).y,0)
        let newRect = CGRectMake(newX, newY, cropRect!.width, cropRect!.height)
        
        if CGRectIntersection(imageRect!, newRect) == newRect {
            //not out of bound
            self.cropRect!.origin = CGPointMake(newX, newY)
        } else {
            print ("out of bounds")
        }
      }
      else
      {
        //The user is creating a new rect, so just create it from
        //start and end points
        self.cropRect = rectFromStartAndEnd(startPoint!, endPoint: newPoint)
      }
    case UIGestureRecognizerState.Ended:

            if let delegate = cropDelegate, let rect = cropRect {
                
                delegate.updateCropRect(rect, inFrame: sourceImageFrame)
            }

        break;
    default:
      draggingRect = false;
      break
    }
  }

  //The user tapped outside of the crop rect. Cancel the current crop rect.
 /* func handleViewTap(theTapper: UITapGestureRecognizer)
  {
    if CGRectContainsPoint(imageRect!, theTapper.locationInView(self))
    {
      self.cropRect = nil
    }
  }*/
    
  
  //-------------------------------------------------------------------------------------------------------
  // MARK: - CornerpointClientProtocol methods
  //-------------------------------------------------------------------------------------------------------

  //This method is called when the user has dragged one of the corners of the crop rectangle
  func cornerHasChanged(newCornerPoint: CornerpointView)
  {
    var pointIndex: Int?
    var newPoint = newCornerPoint
    
    //Find the cornerpoint the user dragged in the array.
    for (index, aCornerpoint) in cornerpoints.enumerate()
    {
      if newPoint == aCornerpoint
      {
        pointIndex = index
        break
      }
    }
    if (pointIndex == nil)
    {
      return;
    }
    
    //Find the index of the opposite corner.
    let otherIndex:Int = (pointIndex! + 2) % 4
    let otherPoint = cornerpoints[otherIndex]

    
    if lockAspect {
        //change newpoint x according to calculate from lock aspect
        //a*(x1 - x0)/ b* (y1-y0) = aspect
        let factorA : CGFloat = newPoint.centerPoint!.x > otherPoint.centerPoint!.x ? 1: -1
        let factorB : CGFloat = newPoint.centerPoint!.y > otherPoint.centerPoint!.y ? 1: -1
        newPoint.centerPoint!.x =
            (newPoint.centerPoint!.y - otherPoint.centerPoint!.y) * CGFloat(aspect) * (factorB / factorA)
            + otherPoint.centerPoint!.x
    }
    
    //Calculate a new cropRect using those 2 corners
    cropRect = rectFromStartAndEnd(newPoint.centerPoint!, endPoint: otherPoint.centerPoint!)
    
    }
    
    func cornerChangeFinished() {

            if let delegate = cropDelegate, let rect = cropRect {
                delegate.updateCropRect(rect, inFrame: self.sourceImageFrame)
            }
        
    }
  }
