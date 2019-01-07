//
//  StringExtention.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/9/18.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import Foundation
import UIKit
import SwiftyUserDefaults

extension String {
    func size(_ font: UIFont) -> CGSize {
        let attribute = [ NSAttributedStringKey.font: font ]
        let conten = NSString(string: self)
        return conten.boundingRect(
            with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)),
            options: .usesLineFragmentOrigin,
            attributes: attribute,
            context: nil
            ).size
    }
}

extension String {
    /// 判断版本 是否需要更新
    ///
    /// - Parameters:
    ///   - localVersion: 本地版本号
    ///   - shotVersion: 平台最新版本号
    /// - Returns: 是否需要更新
    static func compareVersion(localVersion:String, latestVersion:String) -> Bool{
        
        let currentVersionStrings = localVersion.components(separatedBy: ".")
        let storeVersionStrings = latestVersion.components(separatedBy: ".")
        
        if currentVersionStrings.count == storeVersionStrings.count{
            for index in 0..<storeVersionStrings.count {
                let storeSubVersion = storeVersionStrings[index].toFloat()
                let currentSubVersion = currentVersionStrings[index].toFloat()
                
                if storeSubVersion != nil && currentSubVersion != nil {
                    if storeSubVersion! < currentSubVersion! {
                        // 当前手机应用版本高
                        return false
                    }
                    else if storeSubVersion! > currentSubVersion!{
                        // 平台上应用的版本高
                        return true
                    }
                }
            }
        }
        return false
    }
}

// 拼接产品图片链接
//imageType 1:缩略图 0: 原图
extension String {
    func creatProdcutFullUrlString(imageType:Int) -> String{
        /*
          http://172.16.5.40:4003/app/product/load-image?token=33fad591-5970-4286-92a6-d274375e2ece&imageName=5617772624860255.jpg&imageType=1
         */
        let token = Defaults[.token] ?? ""
        return CHBaseUrl + "product/load-image?token=" + token + "&imageName=" + self + "&imageType=" + String(imageType)
    }
}

//MARK: 验证判断密码
extension String {
    // 只包含数字
    func onlyContainNumber(minLen: Int = 0, maxLen: Int) -> Bool {
        var containNumber = true
        let length = self.length
        if length < minLen {
            return false
        }
        if length > maxLen {
            return false
        }
        
        for char in self.utf8 {
            if (char > 47  && char < 58)  {
                continue
            }
            else{
                containNumber = false
                return false
            }
        }
        return containNumber
    }
    
    /// 包含数字 字母小写/大写
    func containNumberAndAlphaB(minLen: Int = 0) -> Bool {
        var containAlphaB = false
        var containNumber = false
        let length = self.length
        if length < minLen{
            return false
        }
        // 大小写
        for char in self.utf8  {
            if (char > 64 && char < 91) || (char > 96 && char < 123) {
                containAlphaB = true
                break
            }
        }
        for char in self.utf8  {
            if (char > 47  && char < 58)  {
                containNumber = true
                break
            }
        }
        
        return containNumber && containAlphaB
    }
    
    /// 包含 数字、字母大写、小写
    func containNumberAndAlphaBAndCapitalAlpha(minLen: Int = 0) -> Bool{
        var containAlphaB = false
        var containCapitalAlphaB = false
        var containNumber = false
        
        let length = self.length
        if length < minLen {
            return false
        }
        
        for char in self.utf8  {
            if (char > 96 && char < 123) {
                containAlphaB = true
                break
            }
        }
        // 大写
        for char in self.utf8  {
            if (char > 64 && char < 91) {
                containCapitalAlphaB = true
                break
            }
        }
        
        
        for char in self.utf8  {
            if (char > 47  && char < 58)  {
                containNumber = true
                break
            }
        }
        
        return containNumber && containAlphaB && containCapitalAlphaB
    }
}
