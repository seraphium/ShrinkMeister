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
    
    var processBtn : UIButton!
    
    var label : UILabel!
    
    var textField: UITextField!
    
    var resultLabel: UILabel!
    
    func initUI()
    {
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        viewService?.setNavigationControllerTitle("test")
        
        processBtn = UIButton(type: .ContactAdd)
        processBtn.setTitle("Process", forState: .Normal)
        view.addSubview(processBtn)
        processBtn.snp_makeConstraints { make -> Void in
            make.center.equalTo(self.view)
        }
        
        label = UILabel()
        view.addSubview(label)
        label.snp_makeConstraints { make -> Void in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(20)
        }
        
        resultLabel = UILabel()
        view.addSubview(resultLabel)
        resultLabel.snp_makeConstraints { make -> Void in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(60)
        }
        
        textField = UITextField()
        textField.borderStyle = .RoundedRect
        view.addSubview(textField)
        textField.snp_makeConstraints() {
            make -> Void in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(100)
            make.width.equalTo(150.0)
        }
        
    }
    
    
    func bindViewModel() {
        
        mainViewModel = AppDelegate.viewModelLocator.getViewModel("Main")  as! MainViewModel
        label.text = String(mainViewModel.vara)
        
        processBtn.rac_command = mainViewModel.executeCommand
        
        textField.rac_textSignal() ~> RAC(mainViewModel, "vara")
        
        RACObserve(mainViewModel, keyPath: "vara").subscribeNextAs {
            (value:String) -> () in
            self.label.text = value
        }
        
        RACObserve(mainViewModel, keyPath: "result").subscribeNextAs {
            (value:String) -> () in
            self.resultLabel.text = value
        }

        
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

