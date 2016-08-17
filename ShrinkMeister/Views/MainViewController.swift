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

class MainViewController: BaseViewController, ViewModelProtocol,UINavigationControllerDelegate {

    var mainViewModel : MainViewModel!
    
    @IBOutlet var twoFingerTapGestureRecognizer: UITapGestureRecognizer!
    
    @IBOutlet var doubleTapGestureRecognizer: UITapGestureRecognizer!
    
    @IBOutlet weak var processCollection: UICollectionView!

    
    @IBOutlet var cropView: CroppableImageView!
    
    @IBOutlet var imageScrollView: ImageScrollView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet var photoResolutionLabel: UILabel!     
    
    var processViews = [BaseProcessView]()
        
    var currentProcessView : BaseProcessView?
    
    let imagePicker = UIImagePickerController()

    var addBarButton : UIBarButtonItem!
    
    var reloadBarButton : UIBarButtonItem!
    
    let collectionCellID = "ProcessCellID"
    let collectionNibName = "ProcessCell"
    
    let processViewClasses : [String] = ["ProcessViewCrop", "ProcessViewLevel", "ProcessViewCustom", "ProcessViewExport"]

    var processViewCount : Int!
    
    //MARK: init
    func initUI()
    {
        
        self.view.backgroundColor = UIColor.whiteColor()
        photoResolutionLabel.textColor = UIColor.blueColor()
        photoResolutionLabel.layer.zPosition = 1000
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
        

    }
    
    
    func initNavigationBar()
    {
        let title = NSLocalizedString("NavigationTitle", comment: "")
        viewService?.setNavigationControllerTitle(title)

        addBarButton = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: #selector(AddPhoto))
        navigationItem.rightBarButtonItem = addBarButton
        
        
        reloadBarButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: #selector(ReloadPhoto))
        navigationItem.leftBarButtonItem = reloadBarButton
    }
    
    func initCollection()
    {
        processCollection.delegate = self
        processCollection.dataSource = self
        processCollection.showsHorizontalScrollIndicator = false
        processCollection.backgroundColor = UIColor.whiteColor()
        let cellNib = UINib(nibName: String(collectionNibName), bundle: nil)
        processCollection.registerNib(cellNib, forCellWithReuseIdentifier: collectionCellID)

    }
    
    func resetImageWithViewModel(imageViewModel : ImageViewModel) {
        
        self.cropView.imageToCrop = imageViewModel.image
        self.imageView.image = imageViewModel.image
        let width = Int(imageViewModel.image.size.width)
        let height = Int(imageViewModel.image.size.height)
        self.photoResolutionLabel.text = String("\(width)X\(height)")

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
        
        NotificationHelper.observeNotification("PushAddPhoto", object: nil, owner: self) {
            _ in //passed in NSNotification
            self.viewService?.pushViewController(AddPhotoViewController(), animated: true)
        }
        
        NotificationHelper.observeNotification("ExportPhotoSucceed", object: nil, owner: self) {
            _ in //passed in NSNotification
            
            let alertController = UIAlertController(title: "Saved", message: "Saved to Album", preferredStyle:.ActionSheet)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                // ...
            }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        
        }
        
        NotificationHelper.observeNotification("EnterCrop", object: nil, owner: self) {
            _ in //passed in NSNotification
            
            print("entering/exiting crop mode")
            self.cropView.hidden = !self.cropView.hidden
            self.cropView.userInteractionEnabled = !self.cropView.userInteractionEnabled
            self.imageScrollView.userInteractionEnabled = !self.imageScrollView.userInteractionEnabled
        }
        

        
    }
    
    
    
    //MARK: view delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()

        initUI()

        initNotification()
        
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
                current.hidden = true
                currentProcessView = nil
                if current != processViews[index] { //if selected a new
                    currentProcessView = processViews[index]
                    currentProcessView!.hidden = false
                }
            } else { //if no one opened
                currentProcessView = processViews[index]
                currentProcessView!.hidden = false
                
            }
            

        }

        
    }
    


// MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(90, 90)
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
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        print ("Aa")
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
    
    
    func choosePicture(){
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        let choosePictureString = "Choose"
        if(imagePicker.sourceType == UIImagePickerControllerSourceType.Camera){
            let button = UIBarButtonItem(title: choosePictureString, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(choosePicture))
            viewController.navigationItem.rightBarButtonItem = button
            viewController.navigationController?.navigationBarHidden = false
            viewController.navigationController?.navigationBar.translucent = true
        }
    }

    func AddPhoto() {
        //see if camera supported, if not , pick from library
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            imagePicker.sourceType  = .Camera
        }
        else {
            imagePicker.sourceType = .PhotoLibrary
        }
        
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func ReloadPhoto() {
        mainViewModel.reloadPhotoCommand?.execute(nil)
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