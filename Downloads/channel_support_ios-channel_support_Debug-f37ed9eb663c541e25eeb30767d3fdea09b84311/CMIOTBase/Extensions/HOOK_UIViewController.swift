//
//  HOOK_UIViewController.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/9.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import Foundation
import DZNEmptyDataSet
import UIKit

var noNetworkKey = -400
private let onceToken = "Method Swizzling"

extension UIViewController {
    var noNetwork: Bool {
        set {
            objc_setAssociatedObject(self, &noNetworkKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            if let rs = objc_getAssociatedObject(self, &noNetworkKey) as? Bool {
                return rs
            }
            return false
        }
    }
    
    func backToSpecificVC(VCName:String) -> Bool{
        if VCName.length > 0 {
            let subVCs = self.navigationController?.viewControllers ?? []
            for vc in subVCs {
                if vc.className == VCName {
                    self.navigationController?.popToViewController(vc, animated: true)
                    return true
                }
            }
        }
        return false
    }
    
    public class func initializeMethod() {
        // Make sure This isn't a subclass of UIViewController, So that It applies to all UIViewController childs
        if self != UIViewController.self {
            return
        }
        //DispatchQueue函数保证代码只被执行一次，防止又被交换回去导致得不到想要的效果
        DispatchQueue.once(token: onceToken) {
            let originalSelector = #selector(UIViewController.viewDidLoad)
            let swizzledSelector = #selector(UIViewController.swizzled_viewDidLoad)
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            //在进行 Swizzling 的时候,需要用 class_addMethod 先进行判断一下原有类中是否有要替换方法的实现
            let didAddMethod: Bool = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
            //如果 class_addMethod 返回 yes,说明当前类中没有要替换方法的实现,所以需要在父类中查找,这时候就用到 method_getImplemetation 去获取 class_getInstanceMethod 里面的方法实现,然后再进行 class_replaceMethod 来实现 Swizzing
            
            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
            } else {
                method_exchangeImplementations(originalMethod!, swizzledMethod!)
            }
        }
    }
    
    @objc func swizzled_viewDidLoad() {
        let backItem = UIBarButtonItem.init(image: UIImage.init(named: "black_back_arrow"), style: .plain, target: self, action: #selector(backToUpVC))
        self.navigationItem.leftBarButtonItem = backItem
        
        self.swizzled_viewDidLoad()
        
        print("\(NSStringFromClass(classForCoder))--DidLoad")
    }

    
    @objc func backToUpVC() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension DispatchQueue {
    private static var _onceTracker = [String]()
    public class func once(token: String, block: () -> ()) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        if _onceTracker.contains(token) {
            return
        }
        _onceTracker.append(token)
        block()
    }
    
    func async(block: @escaping ()->()) {
        self.async(execute: block)
    }
    
    func after(time: DispatchTime, block: @escaping ()->()) {
        self.asyncAfter(deadline: time, execute: block)
    }
}

