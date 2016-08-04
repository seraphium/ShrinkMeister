//
//  ViewModelServices.swift
//  ReactiveSwiftFlickrSearch
//
//  Created by Colin Eberhardt on 15/07/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation
import UIKit

// provides common services to view models
class ViewControllerServicesImp: ViewControllerService {
  
    private let navigationController : UINavigationController!
    
    init(navigationController : UINavigationController)
    {
        self.navigationController = navigationController
    }
    
  // pushes the given ViewController onto the stack, this causes the UI to navigate from
  // one view to the next
    func pushViewController(viewController:BaseViewController, animated: Bool)
    {
        navigationController.pushViewController(viewController, animated: animated)

    }
  

  
}