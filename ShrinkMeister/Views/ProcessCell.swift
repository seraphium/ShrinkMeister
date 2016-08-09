//
//  ProcessCell.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/5.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit


class ProcessCell : UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!

    @IBOutlet weak var image: UIImageView!
    
    var viewModel : BaseProcessViewModel!
    
    func bind(vm : BaseProcessViewModel) {
        
        self.viewModel = vm
        
        bindViewModel()
    }
    
    
    
    func bindViewModel() {
        
        RACObserve(self.viewModel, keyPath: "title")
            .subscribeNextAs {
                (title:String) -> () in
                self.label.text = title
                
        }
        
        RACObserve(self.viewModel, keyPath: "image")
            .subscribeNextAs {
                (image:UIImage) -> () in
                self.image.image = image
                
        }
        
        
    }
}
