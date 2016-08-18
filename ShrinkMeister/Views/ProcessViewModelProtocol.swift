//
//  ProcessViewProtocol.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/7.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import ReactiveCocoa

protocol ProcessViewModelProtocol {
    
    func imageDidSet() -> Void
    
    func executeProcessSignal() -> RACSignal
    
    func beforeProcess() -> Void
    
    func afterProcess() -> Void

}
