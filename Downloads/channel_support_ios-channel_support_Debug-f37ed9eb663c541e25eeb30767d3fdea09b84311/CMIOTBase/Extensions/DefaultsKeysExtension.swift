//
//  DefaultsKeys.extention.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/9/21.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    
    static let userName = DefaultsKey<String?>("username")
    static let token = DefaultsKey<String?>("token")
    static let lastAppVersion = DefaultsKey<String?>("lastAppVersion")
}
