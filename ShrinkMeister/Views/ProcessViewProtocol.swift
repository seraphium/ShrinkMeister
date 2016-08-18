//
//  ProcessViewProtocol.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/10.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import Foundation

protocol ProcessViewProtocol {
    
    func afterShow() -> Void
    func afterDisappear() -> Void
    func bindViewModel() -> Void
}
