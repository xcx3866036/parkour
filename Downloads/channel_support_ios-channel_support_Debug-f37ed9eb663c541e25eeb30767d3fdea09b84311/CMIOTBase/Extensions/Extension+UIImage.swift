//
//  UIImage+Extension.swift
//  FastSwiftKit
//
//  Created by XiaoFeng on 2017/10/19.
//  Copyright © 2017年 亚信智创. All rights reserved.
//

import UIKit

extension UIImage {
    /// 压缩图片大小
    ///
    /// - Parameters:
    ///   - maxLength: 最大尺寸(比特)
    ///   - compress: 压缩系数(0~1)
    /// - Returns:
    func compress(maxLength: Int, compress: CGFloat = 0.90) -> Data? {
        let data = UIImageJPEGRepresentation(self, compress)
        if (data?.count)! < maxLength || compress < 0{
            return data
        }
        return self.compress(maxLength: maxLength, compress: compress-0.05)
    }
    
    /// 颜色转换图片
    public static func color(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setFillColor(color.cgColor)
        ctx?.fill(rect)
        var image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let imageData = UIImageJPEGRepresentation(image, 1.0)!
        image = UIImage(data: imageData)!
        return image
    }
    
    /// 获得圆图
    ///
    /// - Returns: cicleImage
    /// 获得圆图
    ///
    /// - Returns: cicleImage
    public var cicleImage: UIImage {
        
        // 开启图形上下文 false代表透明
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        // 获取上下文
        let ctx = UIGraphicsGetCurrentContext()
        // 添加一个圆
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        ctx?.addEllipse(in: rect)
        // 裁剪
        ctx?.clip()
        // 将图片画上去
        draw(in: rect)
        // 获取图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}
