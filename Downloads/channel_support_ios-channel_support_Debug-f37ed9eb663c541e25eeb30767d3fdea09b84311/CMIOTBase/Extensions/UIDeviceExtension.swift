//
//  UIDeviceExtention.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/9/18.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import Foundation
import UIKit

// MARK: UIDevice - 机型判断
extension UIDevice {
    public func isX() -> Bool {
        if UIScreen.main.bounds.height == 812 {
            return true
        }
        return false
    }
    
    public func is5Series() -> Bool {
        if UIScreen.main.bounds.height == 568 {
            return true
        }
        return false
    }
}
