//
//  ViewController.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/2.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit
import ReactiveCocoa

class MainViewController: BaseViewController, ViewModelProtocol, UINavigationControllerDelegate {

    var mainViewModel : MainViewModel!
    
    @IBOutlet weak var processCollection: UICollectionView!

    @IBOutlet var imageScrollView: ImageScrollView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()

    var addBarButton : UIBarButtonItem!
    
    let collectionCellID = "ProcessCellID"
    let collectionNibName = "ProcessCell"
    
    func initUI()
    {
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        initNavigationBar()
        
        initCollection()

    }
    
    func initNavigationBar()
    {
        viewService?.setNavigationControllerTitle("test")

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
    
        RACObserve(mainViewModel, keyPath: "imageViewModel").skip(1)
            .subscribeNextAs {
                (imageViewModel:ImageViewModel) -> () in
                    self.imageView.image = imageViewModel.image

        }
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        
        bindViewModel()

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

    func initNotification() {
    
        NotificationHelper.observeNotification("PushAddPhoto", object: nil, owner: self) {
            _ in //passed in NSNotification
            self.viewService?.pushViewController(AddPhotoViewController(), animated: true)
        }

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionCellID, forIndexPath: indexPath) as! ProcessCell

        return cell
    }
    
// MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
       
    
    }
    

// MARK: UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(90, 90)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 2.5, 5, 2.5)
    }

}

//MARK: Scrollview delegate
extension MainViewController : UIScrollViewDelegate {
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        
    }
}

//MARK: Image picker delegate
extension MainViewController : UIImagePickerControllerDelegate {
    
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

