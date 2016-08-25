//
//  ViewController.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/2.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit
import ReactiveCocoa
import SnapKit
import MBProgressHUD

class MainViewController: BaseViewController, ViewModelProtocol,UINavigationControllerDelegate {

    var mainViewModel : MainViewModel!
    
    @IBOutlet var twoFingerTapGestureRecognizer: UITapGestureRecognizer!
    
    @IBOutlet var doubleTapGestureRecognizer: UITapGestureRecognizer!
    
    @IBOutlet weak var processCollection: UICollectionView!

    
    @IBOutlet var cropView: CroppableImageView!
    
    //visible image rect used for cropping
    var visibleImageRect: CGRect!
    
    @IBOutlet weak var imageScrollView: ImageScrollView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var photoResolutionLabel: UILabel!

    @IBOutlet weak var photoSizeLabel: UILabel!
    
    @IBOutlet var resolutionView: UIView!
    
    @IBOutlet var sizeView: UIView!
    
    var processViews = [BaseProcessView]()
    
    var processViewContraintOffset : CGFloat = 0.0
    
    var currentProcessView : BaseProcessView?
    
    let imagePicker = UIImagePickerController()

    var addBarButton : UIBarButtonItem!
    
    var reloadBarButton : UIBarButtonItem!
        
    let collectionCellID = "ProcessCellID"
    let collectionNibName = "ProcessCell"
    
    let processViewClasses : [String] = ["ProcessViewBasic", "ProcessViewCrop", "ProcessViewCustom", "ProcessViewExport"]

    var processViewCount : Int!
    
    //MARK: init
    func initUI()
    {
        
        self.view.backgroundColor = UIColor.whiteColor()
        photoResolutionLabel.textColor = UIColor.blackColor()
        photoResolutionLabel.layer.zPosition = 1000
        photoSizeLabel.textColor = UIColor.blackColor()
        photoSizeLabel.layer.zPosition = 1000
        
        resolutionView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
        resolutionView.layer.zPosition = 800
        sizeView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
        sizeView.layer.zPosition = 800
        
        resolutionView.hidden = true
        
        sizeView.hidden = true
        
        
        self.imageScrollView.layer.zPosition = -1000
        
        initNavigationBar()
        
        initCollection()
                
        initProcessViews()
       
    }
    

    func initProcessViews(){
        
        for index in 0 ..< processViewCount{
            let processView = NSBundle.mainBundle().loadNibNamed(processViewClasses[index], owner: nil, options: nil).first as! BaseProcessView
            
            processViews.append(processView)
            
            self.view.addSubview(processView)
            processView.snp_makeConstraints() {
                make in
                make.centerX.equalTo(self.view)
                make.bottom.equalTo(self.processCollection.snp_top)
                make.width.equalTo(self.view)
                make.height.equalTo(CGFloat(50))
            }
            processView.hidden = true
            
        }
        
        cropView.cropDelegate = processViews[1] as! ProcessViewCrop

    }
    
    override func updateViewConstraints() {
        if let currentView = self.currentProcessView {
            currentView.snp_updateConstraints {
                make in
                make.centerX.equalTo(self.view)
                make.bottom.equalTo(self.processCollection.snp_top).offset(CGFloat(processViewContraintOffset))
                make.width.equalTo(self.view)
                make.height.equalTo(CGFloat(50))
            }

        }
        
        // according to apple super should be called at end of method
        super.updateViewConstraints()
    }
    
    func initNavigationBar()
    {
        let title = NSLocalizedString("NavigationTitle", comment: "")
        viewService?.setNavigationControllerTitle(title)
        
        let addButton = UIButton(frame: CGRectMake(0, 0, 22, 22))
        addButton.setBackgroundImage(UIImage(named: "camera"), forState: .Normal)
        addButton.addTarget(self, action: #selector(AddPhoto), forControlEvents: .TouchUpInside)

        addBarButton = UIBarButtonItem(customView: addButton)
        navigationItem.rightBarButtonItem = addBarButton

        let reloadButton = UIButton(frame: CGRectMake(0, 0, 22, 22))
        reloadButton.setBackgroundImage(UIImage(named: "revert"), forState: .Normal)
        reloadButton.addTarget(self, action: #selector(ReloadPhoto), forControlEvents: .TouchUpInside)
        
        reloadBarButton = UIBarButtonItem(customView: reloadButton)
        navigationItem.leftBarButtonItem = reloadBarButton

    }
    
    func initCollection()
    {
        processCollection.delegate = self
        processCollection.dataSource = self
        processCollection.showsHorizontalScrollIndicator = false
        processCollection.backgroundColor = AppDelegate.collectionBackColor
        let cellNib = UINib(nibName: String(collectionNibName), bundle: nil)
        processCollection.registerNib(cellNib, forCellWithReuseIdentifier: collectionCellID)

    }
    
    func resetImageWithViewModel(imageViewModel : ImageViewModel) {
        
        self.imageView.image = imageViewModel.image
        let width = Int(imageViewModel.image.size.width)
        let height = Int(imageViewModel.image.size.height)
        self.photoResolutionLabel.text = String("\(width)X\(height)")
        
        
        let size = imageViewModel.image.imageSizeByte / 1024
        self.photoSizeLabel.text = String("\(size) KB")
      

        let rect = self.view.convertRect(imageView.frame, fromView: self.imageScrollView)
        self.cropView.sourceImageFrame = rect
    }
    
    func bindViewModel() {
        
        mainViewModel = AppDelegate.viewModelLocator.getViewModel("Main")  as! MainViewModel
    
        self.processViewCount = mainViewModel.processViewModels.count

        RACObserve(mainViewModel, keyPath: "imageViewModel").filter {
            (next: AnyObject?) -> Bool in
                return next != nil
            } .subscribeNextAs {
                (imageViewModel:ImageViewModel) -> () in
                
                self.resetImageWithViewModel(imageViewModel)
        }
        
        //if processed image , show processed image instead
        RACObserve(mainViewModel, keyPath: "processedImageViewModel").filter {
            (next: AnyObject?) -> Bool in
            return next != nil
            } .subscribeNextAs {
                (imageViewModel:ImageViewModel) -> () in
                
                self.resetImageWithViewModel(imageViewModel)

        }
        
   
 
    }
    
    func initNotification() {
        
        NotificationHelper.observeNotification(UIKeyboardWillChangeFrameNotification, object: nil, owner: self, handleBlock: {
            obj -> Void in
            self.keyboardNotification(obj as! NSNotification)
        })
        
        NotificationHelper.observeNotification("loaded", object: nil, owner: self) {
            _ in //passed in NSNotification
            self.resolutionView.hidden = false
            self.sizeView.hidden = false
        }
        
        
        
        NotificationHelper.observeNotification("PushAddPhoto", object: nil, owner: self) {
            _ in //passed in NSNotification
            self.viewService?.pushViewController(AddPhotoViewController(), animated: true)
        }
        
        NotificationHelper.observeNotification("ExportPhotoSucceed", object: nil, owner: self) {
            _ in //passed in NSNotification
            
            let alertController = UIAlertController(title: NSLocalizedString("ExportAlertControllerTitle", comment: ""), message:
                NSLocalizedString("ExportAlertControllerMessage", comment: "")  , preferredStyle:.ActionSheet)
            let OKAction = UIAlertAction(title: NSLocalizedString("ExportAlertControllerConfirm", comment: ""), style: .Default) { (action) in
                // ...
            }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        
        }
        
        NotificationHelper.observeNotification("EnterCrop", object: nil, owner: self) {
            notify in //passed in NSNotification
            
            let aspect = notify.userInfo["aspect"] as! Double
            
            print("entering crop mode: \(aspect)")
            self.cropView.aspect = aspect
            self.cropView.hidden = false
            self.cropView.userInteractionEnabled = true
            self.imageScrollView.userInteractionEnabled = false
            
            
        }
        
        NotificationHelper.observeNotification("ExitCrop", object: nil, owner: self) {
            _ in //passed in NSNotification
            
            print("exit crop mode")
            self.cropView.hidden = true
            self.cropView.userInteractionEnabled = false
            self.imageScrollView.userInteractionEnabled = true
            self.currentProcessView?.hidden = true
            self.currentProcessView = nil
        }

        NotificationHelper.observeNotification("toggleLock", object: nil, owner: self) {
            _ in
            
            print ("toggle lock aspect")
            self.cropView.lockAspect = !self.cropView.lockAspect
            if  self.cropView.lockAspect  {
                self.cropView.resetRectFromAspect()

            }
        }
        
        
        NotificationHelper.observeNotification("beforeProcess", object: nil, owner: self) {
            _ in
           let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.color = UIColor.whiteColor().colorWithAlphaComponent(0.7)
            hud.activityIndicatorColor = UIColor.blackColor()
            hud.labelText = NSLocalizedString("MainViewProgressTitle", comment: "")
            hud.labelColor = UIColor.blackColor()
            
        }

        NotificationHelper.observeNotification("afterProcess", object: nil, owner: self) {
            _ in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
        
    }
    
    
    
    //MARK: view delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        

        bindViewModel()

        initUI()

        initNotification()
        
        if (!mainViewModel.loadImage()) {
            AddPhoto()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        //need to put code to use scrollview frame here due to it will be 600x600 in viewwillappear
        if imageView.image != nil {
            imageScrollView.contentSize = imageView.image!.size
            let scrollViewFrame = imageScrollView.frame
            let scaleWidth = scrollViewFrame.size.width / imageScrollView.contentSize.width
            let scaleHeight = scrollViewFrame.size.height / imageScrollView.contentSize.height;
            let minScale = min(scaleWidth, scaleHeight);
            //if image smaller than screen, set max scale to fit-screen
            imageScrollView.minimumZoomScale = minScale > 1.0 ? 1 : minScale;
            
            imageScrollView.maximumZoomScale = minScale > 1.0 ? minScale : 1.0;
            imageScrollView.setZoomScale(minScale, animated: true)
            
         
        }
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        imageScrollView.imageView = imageView

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: UICollectionViewDelegate

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return processViewCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionCellID, forIndexPath: indexPath) as! ProcessCell
        
        //cell initialize
        let index = indexPath.row
        if index < processViewCount {
            
            cell.bind(mainViewModel.processViewModels[index])

        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //trigger process view showing
        let index = indexPath.row

        if index < processViews.count {
            //if already have one opened
            if let current = currentProcessView {
                //close current openned
                current.hide()
                currentProcessView = nil
                currentProcessView?.hide()
                
                if current != processViews[index] { //if selected a new
                    currentProcessView = processViews[index]
                    currentProcessView?.show()

                }
            } else { //if no one opened
                currentProcessView = processViews[index]
                currentProcessView?.show()
            }
            

        }

        
    }
    


// MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = UIScreen.mainScreen().bounds.width
        
        return CGSizeMake(width / 4, width / 4)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 2.5, 5, 2.5)
    }

}

extension MainViewController : UIScrollViewDelegate {
    
    //MARK: Scrollview delegate

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func updateCropViewRect() {
        let imageFrame = imageScrollView.convertRect(imageView.frame, toView: self.view)
        visibleImageRect = CGRectIntersection(imageFrame, imageScrollView.frame)
        
        let translatedRect = self.view.convertRect(visibleImageRect, toView: self.cropView)
        self.cropView.imageRect = translatedRect
        
        let rect = self.view.convertRect(imageView.frame, fromView: imageScrollView)
        self.cropView.sourceImageFrame = rect
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
       updateCropViewRect()
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat)
    {
       updateCropViewRect()
    }
    

}

extension MainViewController : UIImagePickerControllerDelegate {
    
    //MARK: Image picker delegate

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
        //TODO: why popViewController doesn't work ?
        navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //get image from info directory
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        mainViewModel.addPhotoCommand?.execute(image)
        
        //take imagePicker off screen
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func chooseCamera(){
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        let cameraString = NSLocalizedString("ImagePickerCameraTitle", comment: "")
        if  UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let button = UIBarButtonItem(title: cameraString, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(chooseCamera))
            viewController.navigationItem.leftBarButtonItem = button
            viewController.navigationController?.navigationBarHidden = false
            viewController.navigationController?.navigationBar.translucent = true
        }
    }

    func AddPhoto() {

        imagePicker.sourceType = .PhotoLibrary
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func ReloadPhoto() {
        mainViewModel.reloadPhotoCommand?.execute(nil)
        
        ///close all opened process views
        for i in 0 ..< processViewCount {
            processViews[i].hide()
        }
        currentProcessView = nil
    }
    
    

}


extension MainViewController  {
    
    //MARK: handling keyboard overlap
    func keyboardNotification(notification : NSNotification!) -> Void {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
            let duration:NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if endFrame?.origin.y >= UIScreen.mainScreen().bounds.size.height {
                self.processViewContraintOffset = 0.0
            } else {
               self.processViewContraintOffset = -(endFrame!.size.height - self.processCollection.frame.height)
            }
            
            UIView.animateWithDuration(duration,
                                       delay: NSTimeInterval(0),
                                       options: animationCurve,
                                       animations: {
                                        self.view.setNeedsUpdateConstraints()
                                        self.view.layoutIfNeeded() },
                                       completion: nil)
        }
    }
    
    
}

extension MainViewController {
    
    //MARK: gesture recognizer

    @IBAction func twoFingerTapped(sender: UITapGestureRecognizer) {
        var newZoomScale = imageScrollView.zoomScale / 1.5
        newZoomScale = max(newZoomScale, imageScrollView.minimumZoomScale);
        //imageView.alpha = 0
        imageScrollView.setZoomScale(newZoomScale, animated: true)
        
    }

    @IBAction func doubleTapped(sender: UITapGestureRecognizer) {
        
        let pointInView = sender.locationInView(imageView)
        
        var newZoomScale = imageScrollView.zoomScale * 1.5;
        newZoomScale = min(newZoomScale, imageScrollView.maximumZoomScale);
        
        let scrollViewSize = imageScrollView.bounds.size;
        
        let w = scrollViewSize.width / newZoomScale;
        let h = scrollViewSize.height / newZoomScale;
        let x = pointInView.x - (w / 2.0);
        let y = pointInView.y - (h / 2.0);
        
        let rectToZoomTo = CGRectMake(x, y, w, h);
        
        //imageView.alpha = 0
        imageScrollView.zoomToRect(rectToZoomTo, animated: true)
        
    }
    
    
    
}