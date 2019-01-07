//
//  ZSScrollView.swift
//  EntranceGuardV2.0
//
//  Created by junzhang on 2017/12/28.
//  Copyright © 2017年 gh. All rights reserved.
//

import UIKit

class ZSScrollView: UIScrollView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func touchesShouldCancel(in view: UIView) -> Bool {
        super.touchesShouldCancel(in: view)
        return true
    }

}
