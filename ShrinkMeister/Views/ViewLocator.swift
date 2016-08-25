//
//  ViewLocator.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/3.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import Foundation
import UIKit

class ViewLocator {
    
    private var views = [String : UIViewController]()
    
    internal func addView(name: String, withViewController vc: UIViewController)
    {
        views[name] = vc
    }
    
    
    internal func getView(name: String) -> UIViewController? {
        if let view = views[name] {
            return view
        } else {
            return nil
        }
    }
    
    
    init()
    {
        self.addView("Navigation", withViewController: UINavigationController())
        self.addView("Main", withViewController: MainViewController(withViewService: AppDelegate.viewService))
        self.addView("AddPhoto", withViewController: AddPhotoViewController(withViewService: AppDelegate.viewService))
    }

}