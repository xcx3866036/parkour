//
//  Extension+UIImageView.swift
//  FastSwiftKit
//
//  Created by XiaoFeng on 2017/11/16.
//  Copyright © 2017年 亚信智创. All rights reserved.
//  分离Kingfisher

import UIKit
import Kingfisher

extension UIImageView {
    
    /// 为imageView安全赋图
    ///
    /// - Parameter imageUrl: 图片链接: string
    func setHeaderImage(_ imageUrl: String) -> Void {
        guard let url =  URL(string: imageUrl)  else {
            return
        }
        kf.setImage(with: url, placeholder: UIImage.color(UIColor.init(red: 214.0/255.0, green: 214.0/255.0, blue: 214.0/255.0, alpha: 0.6)))
        
    }
    
    /// 为imageView安全赋图
    ///
    /// - Parameter imageUrl: 图片链接: string
    func setImageUrl(_ imageUrl: String,placeholder: Placeholder? = UIImage.color(UIColor.init(red: 214.0/255.0, green: 214.0/255.0, blue: 214.0/255.0, alpha: 0.6))) -> Void {
        guard let url =  URL(string: imageUrl)  else {
            return
        }
        kf.setImage(with: url, placeholder: placeholder)
    }
}

//MARK: Kingfisher
extension Kingfisher where Base: ImageView {
    @discardableResult
    public func setImage(urlString: String?, placeholder: Placeholder? = UIImage.color(UIColor.init(red: 214.0/255.0, green: 214.0/255.0, blue: 214.0/255.0, alpha: 0.6))) -> RetrieveImageTask {
        return setImage(with: URL(string: urlString ?? ""),
                        placeholder: placeholder,
                        options:[.transition(.fade(0.5))])
    }
}

extension Kingfisher where Base: UIButton {
    @discardableResult
    public func setImage(urlString: String?, for state: UIControlState, placeholder: UIImage? = UIImage.color(UIColor.init(red: 214.0/255.0, green: 214.0/255.0, blue: 214.0/255.0, alpha: 0.6))) -> RetrieveImageTask {
        return setImage(with: URL(string: urlString ?? ""),
                        for: state,
                        placeholder: placeholder,
                        options: [.transition(.fade(0.5))])
    }
    @discardableResult
    public func setBackgroundImage(urlString: String?, for state: UIControlState, placeholder: UIImage? = UIImage.color(UIColor.init(red: 214.0/255.0, green: 214.0/255.0, blue: 214.0/255.0, alpha: 0.6))) -> RetrieveImageTask {
        return setBackgroundImage(with: URL(string: urlString ?? ""),
                        for: state,
                        placeholder: placeholder,
                        options: [.transition(.fade(0.5))])
    }
}
