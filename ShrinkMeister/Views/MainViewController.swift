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

class MainViewController: BaseViewController {

    var processBtn : UIButton!
    
    func initUI()
    {
        
        self.view.backgroundColor = UIColor.whiteColor()
        processBtn = UIButton(type: .ContactAdd)
        processBtn.setTitle("Process", forState: .Normal)
        view.addSubview(processBtn)
        processBtn.snp_makeConstraints { make -> Void in
            make.center.equalTo(self.view)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initUI()
        let vm = viewModel as! MainViewModel
        print (vm.vara)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

