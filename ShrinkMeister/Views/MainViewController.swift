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
    
    func initUI()
    {
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        viewService?.setNavigationControllerTitle("test")
        
        
    }
    
    
    func bindViewModel() {
        
        mainViewModel = AppDelegate.viewModelLocator.getViewModel("Main")  as! MainViewModel
        
/*        processBtn.rac_command = mainViewModel.executeCommand
        
        textField.rac_textSignal() ~> RAC(mainViewModel, "vara")
        
        RACObserve(mainViewModel, keyPath: "vara").subscribeNextAs {
            (value:String) -> () in
            self.label.text = value
        }
        
        RACObserve(mainViewModel, keyPath: "result").subscribeNextAs {
            (value:String) -> () in
            self.resultLabel.text = value
        }
*/
        
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


}

