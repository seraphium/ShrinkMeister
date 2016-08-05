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


class MainViewController: BaseViewController, ViewModelProtocol {

    var mainViewModel : MainViewModel!
    
    @IBOutlet weak var processCollection: UICollectionView!

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

        addBarButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(AddPhoto))
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
    
        /*RACObserve(mainViewModel, keyPath: "vara").subscribeNextAs {
            (value:String) -> () in
           
        }*/
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        
        bindViewModel()

        initNotification()
        
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
    
    //MARK: UI Command
    func AddPhoto() {
        mainViewModel.executeCommand?.execute(nil)
    }
    
    

}

//MARK: collection delegate
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionCellID, forIndexPath: indexPath) as! ProcessCell

        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
       
    
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(90, 90)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 2.5, 5, 2.5)
    }

}

