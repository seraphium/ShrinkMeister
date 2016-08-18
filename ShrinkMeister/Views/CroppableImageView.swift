//
//  CroppableImageView.swift
//  CropImg
//
//  Created by Duncan Champney on 3/24/15.
//  Copyright (c) 2015 Duncan Champney. All rights reserved.
//

import UIKit

//---------------------------------------------------------------------------------------------------------

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

//----------------------------------------------------------------------------------------------------------
class CroppableImageView: UIView, CornerpointClientProtocol
{
  // MARK: - properties -

  var sourceImageFrame: CGRect!
  var  imageRect: CGRect?
  var aspect: CGFloat
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

    aspect = 1
    
    dragger = UIPanGestureRecognizer()

    super.init(coder: aDecoder)
    
    self.userInteractionEnabled = false
    
    dragger.addTarget(self, action: #selector(CroppableImageView.handleDragInView(_:)))

    self.addGestureRecognizer(dragger)

    let tapper = UITapGestureRecognizer(target: self,
      action: #selector(CroppableImageView.handleViewTap(_:)));
    self.addGestureRecognizer(tapper)
    
    for aCornerpoint in cornerpoints
    {
      tapper.requireGestureRecognizerToFail(aCornerpoint.dragger)
    }
    
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
  
  override func layoutSubviews()
  {
    super.layoutSubviews()
    cropRect = nil;

  }
  
//--------------------------------------------------------------------------------------------------------
  
 override func drawRect(rect: CGRect)
  {
    //Drawing the image in drawRect is too slow. 
    //Switched to installing the image bitmap into a view layer's content
    //myImage?.drawInRect(imageRect!)
    
    if let realCropRect = internalCropRect
    { 
      let path = UIBezierPath(rect: realCropRect)
      path.lineWidth = 3.0
      UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).set()
      path.stroke()
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
    let newPoint = thePanner.locationInView(self)
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
  func handleViewTap(theTapper: UITapGestureRecognizer)
  {
    if CGRectContainsPoint(imageRect!, theTapper.locationInView(self))
    {
      self.cropRect = nil
    }
  }
  
  //-------------------------------------------------------------------------------------------------------
  // MARK: - CornerpointClientProtocol methods
  //-------------------------------------------------------------------------------------------------------

  //This method is called when the user has dragged one of the corners of the crop rectangle
  func cornerHasChanged(newCornerPoint: CornerpointView)
  {
    var pointIndex: Int?

    //Find the cornerpoint the user dragged in the array.
    for (index, aCornerpoint) in cornerpoints.enumerate()
    {
      if newCornerPoint == aCornerpoint
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
    
    //Calculate a new cropRect using those 2 corners
    cropRect = rectFromStartAndEnd(newCornerPoint.centerPoint!, endPoint: cornerpoints[otherIndex].centerPoint!)
    }
    
    func cornerChangeFinished() {

            if let delegate = cropDelegate, let rect = cropRect {
                delegate.updateCropRect(rect, inFrame: self.sourceImageFrame)
            }
        
    }
  }
