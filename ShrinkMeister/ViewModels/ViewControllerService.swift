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
protocol ViewControllerService {
  
  // pushes the given ViewModel onto the stack, this causes the UI to navigate from
  // one view to the next
    func pushViewController(viewController:BaseViewController, animated: Bool)
  
    func getNavigationController() -> UINavigationController

    func setNavigationControllerTitle(title: String)
}