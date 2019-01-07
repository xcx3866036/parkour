//
//  GeneralUIFactory.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/8.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import Foundation
import UIKit

func UIFactoryGenerateLab(fontSize:CGFloat, color:UIColor, placeText: String) -> UILabel {
    let lab = UILabel()
    lab.textColor = color
    lab.font = UIFont.systemFont(ofSize: fontSize)
    lab.text = placeText
    lab.textAlignment = .left
    return lab
}

func UIFactoryGenerateImgView(imageName: String) -> UIImageView {
    let imageView = UIImageView()
    imageView.image = UIImage.init(named: imageName)
    return imageView
}

func UIFactoryGenerateBtn(fontSize:CGFloat, color:UIColor, placeText: String, imageName: String) -> UIButton {
    let btn = UIButton()
    btn.setTitleColor(color, for: .normal)
    btn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
    if placeText.length > 0 {
      btn.setTitle(placeText, for: .normal)
    }
    if imageName.length > 0 {
        btn.setImage(UIImage.init(named: imageName), for: .normal)
    }
    return btn
}

func UIFactoryGenerateTextField(fontSize:CGFloat, color:UIColor, placeText: String) -> UITextField {
    let tfView = UITextField()
    tfView.font = UIFont.systemFont(ofSize: fontSize)
    tfView.textColor = color
    tfView.placeholder = placeText
    return tfView
}

func UIFactoryGenerateStepIndicatorView() ->  StepIndicatorView {
    let stepIndicatorView = StepIndicatorView()
    stepIndicatorView.backgroundColor = UIColor.clear
    stepIndicatorView.circleStrokeWidth = 1.0
    stepIndicatorView.circleRadius = 4
    stepIndicatorView.circleColor = UIColor.white
    stepIndicatorView.circleTintColor = UIColor.white
    stepIndicatorView.lineColor = RGBA(r: 0, g: 0, b: 0, a: 0.2)
    stepIndicatorView.lineTintColor = RGBA(r: 0, g: 0, b: 0, a: 0.2)
    stepIndicatorView.lineMargin = 0
    stepIndicatorView.lineStrokeWidth = 2
    stepIndicatorView.displayNumbers = false//圆圈中间是否显示数字
    return stepIndicatorView
}


