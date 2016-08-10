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

class MainViewController: BaseViewController, ViewModelProtocol, UINavigationControllerDelegate {

    var mainViewModel : MainViewModel!
    
    @IBOutlet var twoFingerTapGestureRecognizer: UITapGestureRecognizer!
    
    @IBOutlet var doubleTapGestureRecognizer: UITapGestureRecognizer!
    
    @IBOutlet weak var processCollection: UICollectionView!

    @IBOutlet var imageScrollView: ImageScrollView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var processViews = [BaseProcessView]()
        
    var currentProcessView : BaseProcessView?
    
    let imagePicker = UIImagePickerController()

    var addBarButton : UIBarButtonItem!
    
    let collectionCellID = "ProcessCellID"
    let collectionNibName = "ProcessCell"
    
    let processViewClasses : [String] = ["ProcessViewLevel", "ProcessViewCustom"]

    var processViewCount : Int!
    
    //MARK: init
    func initUI()
    {
        
        self.view.backgroundColor = UIColor.whiteColor()
        
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
    
    func bindViewModel() {
        
        mainViewModel = AppDelegate.viewModelLocator.getViewModel("Main")  as! MainViewModel
    
        self.processViewCount = mainViewModel.processViewModels.count

        
        RACObserve(mainViewModel, keyPath: "imageViewModel").skip(1)
            .subscribeNextAs {
                (imageViewModel:ImageViewModel) -> () in
                    self.imageView.image = imageViewModel.image

        }
 
    }
    
    func initNotification() {
        
        NotificationHelper.observeNotification("PushAddPhoto", object: nil, owner: self) {
            _ in //passed in NSNotification
            self.viewService?.pushViewController(AddPhotoViewController(), animated: true)
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
            imageScrollView.minimumZoomScale = minScale;
            
            imageScrollView.maximumZoomScale = 1.0;
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