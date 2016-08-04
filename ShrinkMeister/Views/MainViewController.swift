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
    
    func initUI()
    {
        
        self.view.backgroundColor = UIColor.whiteColor()
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
    }
    
    
    func bindViewModel() {
        label.text = String(mainViewModel.vara)
        processBtn.rac_command = mainViewModel.executeProcess
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainViewModel = viewModel as! MainViewModel

        initUI()
        bindViewModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

