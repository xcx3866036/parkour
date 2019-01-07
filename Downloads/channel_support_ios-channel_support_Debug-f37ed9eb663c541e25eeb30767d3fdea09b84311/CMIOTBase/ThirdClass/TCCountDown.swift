//
//  TCCountDown.swift
//  EntranceGuardV2.0
//
//  Created by 杜鹏 on 17/5/4.
//  Copyright © 2017年 gh. All rights reserved.
//

import Foundation
import UIKit
class TCCountDown {
    private var countdownTimer: Timer?
    var codeBtn = UIButton()
    var type:Int = 0
    
//    public var finshBlock: (() -> Void)?

    private var remainingSeconds: Int = 0 {
        willSet {
            codeBtn.setTitle("\(newValue)秒后重发", for: .selected)
            codeBtn.setTitle("\(newValue)秒后重发", for: .normal)

            if newValue <= 0 {
                isCounting = false
//                 finshBlock?()
            }
        }
    }
    var isCounting = false {
        willSet {
            codeBtn.isSelected = newValue
            if newValue {
                if remainingSeconds <= 0 {
                    countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
                    remainingSeconds = 60
                }
//                codeBtn.setBackgroundColor(UIColor.colorWithHexString(hex: "#a9aeb1"), forState: .normal)
//                codeBtn.setBackgroundColor(UIColor.colorWithHexString(hex: "#a9aeb1"), forState: .selected)
                codeBtn.setTitleColor(RGB(187, g: 187, b: 187), for: .normal)
//                codeBtn.setBackgroundColor(.white, forState: .normal)
//                codeBtn.setBackgroundColor(.white, forState: .selected)
                codeBtn.isUserInteractionEnabled = false
            }
            else {
                countdownTimer?.invalidate()
                countdownTimer = nil
                codeBtn.setTitle("获取验证码", for: .normal)
                if(type == 1){
                    codeBtn.setTitle("重新发送", for: .normal)
                }
//                codeBtn.setBackgroundColor(UIColor.colorWithHexString(hex: "#3f89f2"), forState: .normal)
//                codeBtn.setBackgroundColor(UIColor.colorWithHexString(hex: "#3f89f2"), forState: .selected)
                codeBtn.setTitleColor(RGB(33, g: 91, b: 255), for: .normal)
//                codeBtn.setBackgroundColor(.white, forState: .normal)
//                codeBtn.setBackgroundColor(.white, forState: .selected)
                codeBtn.isUserInteractionEnabled = true
            }
        }
    }
      @objc func updateTime() {
        remainingSeconds -= 1
    }
}
