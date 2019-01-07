//
//  UploadPhoto.swift
//  LoveHome
//
//  Created by Apple on 2018/9/29.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

public class UploadPhoto: NSObject{
    
    fileprivate var isEdit = false
    
    public var didSelectImage: ((_ didSelectImage:UIImage) -> Swift.Void)?
    
    fileprivate lazy var sheetView = SheetAlertUtil(frame:UIScreen.main.bounds,titles: ["从相册获取","拍照"])
}

extension UploadPhoto{
    public func showUploadPhoto(_ tarage:UIViewController,isEditing:Bool = false) {
        isEdit = isEditing
        //使用示例
        sheetView.selectIndex = { index in
            //拍照
            if index == 1 {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let picker = UIImagePickerController()
                    picker.sourceType = .camera
                    picker.delegate = self
                    picker.allowsEditing = true
                    picker.setEditing(true, animated: true)
                    tarage.present(picker, animated: true, completion: nil)
                }
                else{
                    print("模拟其中无法打开照相机,请在真机中使用");
                }
            }else{
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                picker.allowsEditing = true
                picker.setEditing(true, animated: true)
                tarage.present(picker, animated: true, completion: nil)
            }
        }
        tarage.view.window?.addSubview(sheetView)
    }
}


// MARK: -- UIImagePickerControllerDelegate/UINavigationControllerDelegate
extension UploadPhoto:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let dic = info as NSDictionary
        
        guard let select_image = isEdit ? dic.object(forKey: UIImagePickerControllerOriginalImage) : dic.object(forKey: UIImagePickerControllerEditedImage) else { return }
        
        didSelectImage?(UIImage(data: UIImageJPEGRepresentation(select_image as! UIImage, 0.5)!)!)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let item:UIBarButtonItem = UIBarButtonItem.init(customView: UIView.init(frame: CGRect(x: 0, y: 0, w: 0, h: 0)))
        viewController.navigationItem.setLeftBarButton(item, animated: false)
    }
}

