//
//  GeneralFunction.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/9/18.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import Foundation
import UIKit

let phonePattern = "^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0-6-8])\\d{8}$"
let MtoNnumber = "^[a-zA-Z0-9]{8,18}+$"

struct MyRegex {
    let regex: NSRegularExpression?
    
    init(_ pattern: String) {
        regex = try? NSRegularExpression(pattern: pattern,
                                         options: .caseInsensitive)
    }
    
    func match(input: String) -> Bool {
        if let matches = regex?.matches(in: input,
                                        options: [],
                                        range: NSMakeRange(0, (input as NSString).length)) {
            return matches.count > 0
        } else {
            return false
        }
    }
}

infix operator =~

func =~ (lhs: String, rhs: String) -> Bool {
    return MyRegex(rhs).match(input: lhs) //需要前面定义的MyRegex配合
}



func kIS_IOS7() -> Bool {
    return (UIDevice.current.systemVersion as NSString).doubleValue >= 7.0
}
func KIS_IOS8() -> Bool{
    return (UIDevice.current.systemVersion as NSString).doubleValue >= 8.0
}
func kIS_IOS9() -> Bool {
    return (UIDevice.current.systemVersion as NSString).doubleValue >= 9.0
}
func KIS_IOS10() -> Bool{
    return (UIDevice.current.systemVersion as NSString).doubleValue >= 10.0
}
func RGBA(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat)->UIColor{
    return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

func RGB(_ r:CGFloat,g:CGFloat,b:CGFloat)-> UIColor{
    return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
}

//MARK: - 密码验证
func containNumberAndAlphaB(text:String) -> Bool{
    
    
    return true
}

//MARK: 获取文字宽度
func getLabWidth(labelStr:String,font:UIFont,height:CGFloat) -> CGFloat {
    let statusLabelText: String = labelStr
    let size = CGSize(width: 900, height: height)
    let dic = NSDictionary(object: font, forKey: kCTFontAttributeName as! NSCopying)
    let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : Any], context: nil).size
    return strSize.width
}

//MARK: 文字高度
func getLabHeigh(labelStr:String,font:UIFont,width:CGFloat) -> CGFloat {
    let statusLabelText : String = labelStr
    let size = CGSize(width: width, height: 900)
    let dic = NSDictionary(object: font, forKey: kCTFontAttributeName as! NSCopying)
    let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : Any], context: nil).size
    return strSize.height
}


//MARK: 提示设置蓝牙权限
func RemindBlueToothAuthorized(){
    var alertController = UIAlertController()
    alertController = UIAlertController(title: "提醒事项", message: "您未开启“和门禁”蓝牙权限，立即设置？", preferredStyle: .alert)
    let cancerAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
        print("取消")
    }
    let certainAction = UIAlertAction(title: "设置", style: .default) { (action) in
        let urlObj = URL(string:UIApplicationOpenSettingsURLString)
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(urlObj! as URL, options: [ : ], completionHandler: { Success in
            })} else {
            UIApplication.shared.openURL(urlObj!)
        }
    }
    alertController.addAction(cancerAction)
    alertController.addAction(certainAction)
    UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: {
        
    })
}

/// 随机16String
func random16String() -> String {
    let array = ["a","b","c","d","e","f","g","h","i",
                 "j","k","l","m","n","o","p","q","r",
                 "s","t","u","v","w","x","y","z","0",
                 "1","2","3","4","5","6","7","8","9"]
    var randomString = ""
    for _ in 0..<16 {
        let index:Int = (Int(arc4random()) % 36) as Int
        randomString = randomString.appending(array[index])
    }
    return randomString
}

/// 跳转登录界面
func startGotoLogin(rootVC: UIViewController) -> () {
    let loginVC = LoginViewController()
    let login = UINavigationController.init(rootViewController: loginVC)
    rootVC.present(login, animated: false) { }
}

/// 重新登录
func relogin() {
    guard let window = UIApplication.shared.delegate?.window else { return }
    guard let naviVC = window?.rootViewController as? UINavigationController else { return }
    let alterController = UIAlertController.init(title: "提醒事项", message: "登录已过期，请重新登录", preferredStyle: .alert)
    let sureAction = UIAlertAction.init(title: "重新登录", style: .default) { (action) in
        // 重新登录的操作
        let vc = LoginViewController()
        let login = UINavigationController.init(rootViewController: vc)
        naviVC.present(login, animated: true, completion: {
            // 将所有界面都返回到根界面
            naviVC.viewControllers.last?.navigationController?.popToRootViewController(animated: true)
        })
    }
    alterController.addAction(sureAction)
    naviVC.present(alterController, animated: true)
}

func calNetWorkImageHeight(urlStr:String) -> (height:CGFloat,image: UIImage) {
    do {
        let data:Data = try Data.init(contentsOf: NSURL.init(string: urlStr)! as URL)
        let image:UIImage = UIImage.init(data: data)!
        var height = image.size.height
        let width = image.size.width
        let scale = height / width
        height = SCREEN_WIDTH * scale
        return (height,image)
    } catch {
        print("获取图片高度错误：" + urlStr)
    }
   return (0,UIImage.init(named: "img_placeholder")!)
}

// MARK: Debug
func debugOnly(_ body:() -> Void) {
    assert({body();return true}())
}

