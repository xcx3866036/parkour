//
//  UserInfoViewController.swift
//  EntranceGuardV2.0
//
//  Created by 杜鹏 on 2017/7/14.
//  Copyright © 2017年 gh. All rights reserved.
//

import UIKit
import SVProgressHUD
import PermissionScope
import MediaPickerController
import SwiftyUserDefaults

class UserInfoViewController: UIViewController {
   var tableView:UITableView!
    
//    fileprivate let  user = UserModel.read()
    fileprivate let identifier: String = "UserInfoCell"
    fileprivate let identifier1: String = "UserInfoHeadCell"
    fileprivate let titles = [["头像","姓名","手机号","性别"],["公司","部门","职位","工号","邮箱"],["办公电话","办公地址","身份证号","一卡通卡号","支付宝账号","微信号","银行卡号"]]
    fileprivate  var mediaPickerController: MediaPickerController!
    fileprivate  var  headIcon:UIImage?
    fileprivate var sexTextFiled:UITextField?
    fileprivate var nameTextFiled:UITextField?
    fileprivate var pickerView:UIPickerView!
    
    open var headUpdateBlock: (() -> Void)?
    
    let pscope = PermissionScope()
    
    var  saveBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人信息"
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: kNavigationBarH, w: SCREEN_WIDTH, h: SCREEN_HEIGHT - kNavigationBarH))
        tableView.separatorInset = UIEdgeInsetsMake(0, 30, 0, 0)
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = RGB(221, g: 221, b: 221)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserInfoCell.self, forCellReuseIdentifier: identifier)
        tableView.register(UserInfoHeadCell.self, forCellReuseIdentifier: identifier1)

        self.view.addSubview(tableView)
        self.mediaPickerController = MediaPickerController(type: .imageOnly, presentingViewController: self)
        self.mediaPickerController.delegate = self
 
        saveBtn = UIButton.init(x: SCREEN_WIDTH - 55, y: 16, w: 50, h: 50, target: self, action: #selector(commit))
        saveBtn.setTitle("保存", for: .normal)
        saveBtn.setTitleColor(.white, for: .normal)
        saveBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
//        self.navigationView.addSubview(saveBtn)
        saveBtn.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: 网络请求
    @objc func commit(){
        view.endEditing(true)
        
//        if let emailStr = user?.email, emailStr.length > 0{
//            guard let emialStr = user?.email, emialStr =~ emailPattern else{
//                SVProgressHUD.showError(withStatus: "请输入正确1-64位邮箱地址")
//                return
//            }
//        }
//
//        if let IDStr = user?.identityNumber, IDStr.length > 0 {
//            if IDStr.length < 15 {
//                SVProgressHUD.showError(withStatus: "请输入正确15-18位身份证号")
//                return
//            }
//            else{
//                let isID = IDStr =~ IDPattern
//                let isIDOld  = IDStr =~ IDPatternOld
//                if !isID && !isIDOld{
//                    SVProgressHUD.showError(withStatus: "请输入正确15-18位身份证号")
//                    return
//                }
//            }
//        }
//
//            let params = user?.toJSON()
//            SVProgressHUD.setDefaultMaskType(.clear)
//            SVProgressHUD.show()
//
//            alRequestGetDataFormServers(url:"user/modify-user", params: params, keyPath: nil, successBlock: { (result:shortResponse) in
//                if(result.returnCode! == 1){
//                    UserModel.save(model: self.user!)
//                    SVProgressHUD.showSuccess(withStatus: result.returnMsg)
//                    _ = self.navigationController?.popViewController(animated: true)
//                    self.headUpdateBlock!()
//                    self.tableView.reloadData()
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: LoginStateChangeNotifition), object: nil, userInfo: nil)
//                }
//                else{
//                    SVProgressHUD.showError(withStatus: result.returnMsg)
//                }
//            }, errorBlock: { (err) in
//                SVProgressHUD.showError(withStatus: "网络连接响应失败")
//            })
    }
    
    func upLoadimageWithPath(path:String){
//        let params = ["id":user?.id ?? 0] as [String : Any]
//        alRequestUpLoadDataToServers(url: "user/save-photo", params:params, filePath: path, successBlock: { (result:oneWordResponse) in
//            if(result.returnCode! == 1){
//                self.user?.photo = result.photoUrl
//                UserModel.save(model: self.user!)
//                SVProgressHUD.showSuccess(withStatus: result.returnMsg)
//                self.tableView.reloadData()
//                self.headUpdateBlock!()
//            }
//            else{
//                SVProgressHUD.showError(withStatus: result.returnMsg)
//            }
//        }) { (error) in
//           SVProgressHUD.showError(withStatus: "网络连接响应失败")
//        }
    }
    
    //MARK: 图片处理
    func saveImage(img:UIImage) -> String?{
        //修正图片的位置
        var image = fixOrientation(aImage: (img))
        if image.cgImage == nil {
            guard let ciImage = image.ciImage, let cgImage = CIContext(options: nil).createCGImage(ciImage, from: ciImage.extent) else { return nil }
            image = UIImage.init(cgImage: cgImage)
        }
        //先把图片转成NSData
        image = UIImage.scaleTo(image: image, w: 320, h: 320)
        // 这里裁剪了图片，不裁剪会出现太大不能上传
        var data = UIImageJPEGRepresentation(image, 0.1)
        
        if data == nil {
            data = UIImagePNGRepresentation(image)
        }
        if data == nil{
            return nil
        }
        else{
            headIcon = image
        }
        //Home目录
        let homeDirectory = NSHomeDirectory()
        let documentPath = homeDirectory + "/Documents"
        //文件管理器
        let fileManager: FileManager = FileManager.default
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        do {
            try fileManager.createDirectory(atPath: documentPath, withIntermediateDirectories: true, attributes: nil)
        }
        catch let error {
            print(error.localizedDescription)
        }
        let dateS:String = (String(describing: Date()) as NSString).substring(to: 19)
        let filePath: String = documentPath.appending("/\(dateS).png")
        fileManager.createFile(atPath: filePath, contents: data, attributes: nil)
        if fileManager.fileExists(atPath: filePath){
            return filePath
        }
        //得到选择后沙盒中图片的完整路径
        return nil
    }
    
    func fixOrientation(aImage: UIImage) -> UIImage {
        // No-op if the orientation is already correct
        if aImage.imageOrientation == .up {
            return aImage
        }
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform: CGAffineTransform = CGAffineTransform.identity
        switch aImage.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: aImage.size.width, y: aImage.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: aImage.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi/2.0))
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: aImage.size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi/2.0))
        default:
            break
        }
        
        switch aImage.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: aImage.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: aImage.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        
        //这里需要注意下CGImageGetBitmapInfo，它的类型是Int32的，CGImageGetBitmapInfo(aImage.CGImage).rawValue，这样写才不会报错
        let ctx: CGContext = CGContext(data: nil, width: Int(aImage.size.width), height: Int(aImage.size.height), bitsPerComponent: aImage.cgImage!.bitsPerComponent, bytesPerRow: 0, space: aImage.cgImage!.colorSpace!, bitmapInfo: aImage.cgImage!.bitmapInfo.rawValue)!
        ctx.concatenate(transform)
        switch aImage.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(aImage.cgImage!, in: CGRect.init(x: 0, y: 0, w:  aImage.size.height, h: aImage.size.width))
        default:
            ctx.draw(aImage.cgImage!, in: CGRect.init(x: 0, y: 0, w:  aImage.size.width, h: aImage.size.height))
        }
        
        // And now we just create a new UIImage from the drawing context
        let cgimg: CGImage = ctx.makeImage()!
        let img: UIImage = UIImage.init(cgImage: cgimg)
        return img
    }
}

//MARK: UITableViewDelegate - UITableViewDataSource
extension UserInfoViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int{
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: identifier1, for: indexPath) 
//        let arr = titles[indexPath.section]
//
//        if indexPath.section == 0{
//            if indexPath.row == 0 {
//                let cell = tableView.dequeueReusableCell(withIdentifier: identifier1, for: indexPath) as! UserInfoHeadCell
//                 cell.textLabel?.text = arr[indexPath.row]
//                if let length = user?.photo?.length,length > 1 {
//                    let str = baseUrl + "/common/load-photo?imageName=" + (user?.photo)! + "&token=" + Defaults[.token]!
//                    if user?.photo != "1" {
//                        cell.imageV.kf.setImage(with: URL(string:str), placeholder: #imageLiteral(resourceName: "head"))
//                        cell.imageV.layer.borderWidth = 0
//                    }
//                }
//                else{
//                    cell.imageV.layer.borderWidth = 4.0
//                    cell.imageV.layer.borderColor = RGBA(r:255,g:255,b:255,a:0.33).cgColor
//                    cell.imageV.image = #imageLiteral(resourceName: "head")
//                }
//
//                if let icon  = headIcon{
//                     cell.imageV.image = icon
//                }
//
//                cell.headClick = {
//                    switch self.pscope.statusCamera() {
//                    case .unknown:
//                        self.pscope.requestCamera()
//                    case .unauthorized, .disabled:
//                        self.presentAlertWithTitle(title: "提示", message: "该功能需要开启相机,请到设置中开启相机", buttonTitle: "是")
//                    case .authorized:
//                        self.mediaPickerController.show()
//                    }
//                }
//                return cell
//            }
//            else{
//                let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! UserInfoCell
//                cell.textLabel?.text = arr[indexPath.row]
//                cell.textField.tag = indexPath.row + indexPath.section
//                cell.textField.isEnabled = true
//                cell.textField.inputView = nil
//                cell.textField.placeholder = "请输入\(arr[indexPath.row])"
//                cell.textField.keyboardType = UIKeyboardType.default
//
//                switch indexPath.row {
//                case 1:
//                    cell.textField.text = user?.userName
//                    nameTextFiled = cell.textField
//                    cell.endEditBlock = { [weak self] (text:String) -> Void in
//                        self?.user?.userName = text
//                        self?.saveBtn.isHidden = false
//                    }
//                case 2:
//                    cell.textField.text = user?.cellphone ?? "--"
//                    cell.textField.isEnabled = false
//                    cell.textField.keyboardType = UIKeyboardType.phonePad
//                case 3:
//                    if user?.sex == 1 || user?.sex == nil{
//                        cell.textField.text = "男"
//                    }
//                    else{
//                        cell.textField.text = "女"
//                    }
//                    sexTextFiled = cell.textField
//                    sexTextFiled?.inputView = pickerView
//                    cell.textField.placeholder = "请选择\(arr[indexPath.row])"
//                    cell.endEditBlock = { [weak self] (text:String) -> Void in
//                        self?.saveBtn.isHidden = false
//                    }
//                default:
//                    break
//                }
//                return cell
//            }
//        }
//        else if indexPath.section == 1{
//            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! UserInfoCell
//            cell.textLabel?.text = arr[indexPath.row]
//            cell.textField.tag = indexPath.row + 4
//            cell.textField.isEnabled = true
//            cell.textField.inputView = nil
//            cell.textField.placeholder = "请输入\(arr[indexPath.row])"
//            cell.textField.keyboardType = UIKeyboardType.default
//
//            switch indexPath.row {
//            case 0:
//                if let len = user?.companyName?.length,len > 0 {
//                    cell.textField.text = user?.companyName
//                }
//                else{
//                    cell.textField.text = "--"
//                }
//                cell.textField.isEnabled = false
//                cell.accessoryView = nil
//            case 1:
//                if let len = user?.departmentName?.length,len > 0 {
//                    cell.textField.text = user?.departmentName
//                }
//                else{
//                    cell.textField.text = "---"
//                }
//                cell.textField.isEnabled = false
//                cell.accessoryView = nil
//            case 2:
//                // 职位
//                if let len = user?.position?.length,len > 0 {
//                    cell.textField.text = user?.position
//                }
//                else{
//                    cell.textField.text = "无"
//                }
//                cell.textField.isEnabled = false
//                cell.accessoryView = nil
////                cell.textField.text = user?.position
////                cell.endEditBlock = { [weak self] (text:String) -> Void in
////                    self?.user?.position = text
////                    self?.saveBtn.isHidden = false
////                }
//            case 3:
//                if let len = user?.eid?.length,len > 0 {
//                    cell.textField.text = user?.eid
//                }
//                else{
//                    cell.textField.text = "--"
//                }
//                cell.textField.isEnabled = false
//                cell.accessoryView = nil
//            case 4:
//                cell.textField.text = user?.email
//                cell.textField.keyboardType = UIKeyboardType.emailAddress
//                cell.endEditBlock = { [weak self] (text:String) -> Void in
//                    self?.user?.email = text
//                    self?.saveBtn.isHidden = false
//                }
//            case 9:
//                cell.textField.text = user?.telephone
//                cell.textField.keyboardType = UIKeyboardType.phonePad
//                cell.endEditBlock = { [weak self] (text:String) -> Void in
//                    self?.user?.telephone = text
//                    self?.saveBtn.isHidden = false
//                }
//            case 10:
//                cell.textField.text = user?.workAddress
//                cell.endEditBlock = { [weak self] (text:String) -> Void in
//                    self?.user?.workAddress = text
//                    self?.saveBtn.isHidden = false
//                }
//            case 11:
//                cell.textField.text = user?.identityNumber
//                cell.textField.keyboardType = UIKeyboardType.default
//                cell.endEditBlock = { [weak self] (text:String) -> Void in
//                    self?.user?.identityNumber = text
//                    self?.saveBtn.isHidden = false
//                }
//            case 12:
//                cell.textField.text = user?.cardNumber
//                if let len = user?.cardNumber?.length,len > 0 {
//                    cell.textField.text = user?.cardNumber
//                }
//                else{
//                    cell.textField.text = "--"
//                }
//                cell.textField.isEnabled = false
//            case 13:
//                cell.textField.text = user?.alipayId
//                cell.endEditBlock = { [weak self] (text:String) -> Void in
//                    self?.user?.alipayId = text
//                    self?.saveBtn.isHidden = false
//                }
//            case 14:
//                cell.textField.text = user?.wechatId
//                cell.endEditBlock = { [weak self] (text:String) -> Void in
//                    self?.user?.wechatId = text
//                    self?.saveBtn.isHidden = false
//                }
//            case 15:
//                cell.textField.text = user?.bankCardNumber
//                cell.textField.keyboardType = UIKeyboardType.numberPad
//                cell.endEditBlock = { [weak self] (text:String) -> Void in
//                    self?.user?.bankCardNumber = text
//                    self?.saveBtn.isHidden = false
//                }
//            default:
//                break
//            }
//
//            return cell
//        }
//        else{
//            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! UserInfoCell
//            cell.textLabel?.text = arr[indexPath.row]
//            cell.textField.tag = indexPath.row + 9
//            cell.textField.isEnabled = true
//            cell.textField.inputView = nil
//            cell.textField.placeholder = "请输入\(arr[indexPath.row])"
//            cell.textField.keyboardType = UIKeyboardType.default
//
//            switch indexPath.row {
//            case 0:
//                cell.textField.text = user?.telephone
//                cell.textField.keyboardType = UIKeyboardType.phonePad
//                cell.endEditBlock = { [weak self] (text:String) -> Void in
//                    self?.user?.telephone = text
//                    self?.saveBtn.isHidden = false
//                }
//            case 1:
//                cell.textField.text = user?.workAddress
//                cell.endEditBlock = { [weak self] (text:String) -> Void in
//                    self?.user?.workAddress = text
//                    self?.saveBtn.isHidden = false
//                }
//            case 2:
//                cell.textField.text = user?.identityNumber
//                cell.textField.keyboardType = UIKeyboardType.default
//                cell.endEditBlock = { [weak self] (text:String) -> Void in
//                    self?.user?.identityNumber = text
//                    self?.saveBtn.isHidden = false
//                }
//            case 3:
//                cell.textField.text = user?.cardNumber
//                if let len = user?.cardNumber?.length,len > 0 {
//                    cell.textField.text = user?.cardNumber
//                }
//                else{
//                    cell.textField.text = "--"
//                }
//                cell.textField.isEnabled = false
//                cell.accessoryView = nil
//
//            case 4:
//                cell.textField.text = user?.alipayId
//                cell.endEditBlock = { [weak self] (text:String) -> Void in
//                    self?.user?.alipayId = text
//                    self?.saveBtn.isHidden = false
//                }
//            case 5:
//                cell.textField.text = user?.wechatId
//                cell.endEditBlock = { [weak self] (text:String) -> Void in
//                    self?.user?.wechatId = text
//                    self?.saveBtn.isHidden = false
//                }
//            case 6:
//                cell.textField.text = user?.bankCardNumber
//                cell.textField.keyboardType = UIKeyboardType.numberPad
//                cell.endEditBlock = { [weak self] (text:String) -> Void in
//                    self?.user?.bankCardNumber = text
//                    self?.saveBtn.isHidden = false
//                }
//            default:
//                break
//            }
            return cell
//         }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0{
            return 75
        }
        return 54
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 15 * kRatioToIP6H
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vi = UIView()
        vi.backgroundColor = RGB(245, g: 245, b: 245)
        return vi
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return CGFloat.leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if indexPath.row == 2 && indexPath.section == 0 {
//            let resetPhoneVC = ResetPhoneViewController()
//            self.navigationController?.pushViewController(resetPhoneVC, animated: true)
        }
    }
}

//MARK: MediaPickerControllerDelegate
extension UserInfoViewController: MediaPickerControllerDelegate {
    func mediaPickerControllerDidPickImage(_ image: UIImage) {
        let path = self.saveImage(img: image)
        if let pt = path{
            self.upLoadimageWithPath(path: pt)
        }
    }
    
    func mediaPickerControllerDidPickVideo(url: URL, data: Data, thumbnail: UIImage) {
//        self.statusLabel.text = "Picked Video\nURL in device: \(url.absoluteString)\nThumbnail Preview:"
//        self.imageView.image = thumbnail
    }
}

//MARK: UIPickerViewDelegate - UIPickerViewDataSource
extension UserInfoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 1{
            return "男"
        }
        else{
            return "女"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return self.view.frame.width
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 1 {
            sexTextFiled?.text = "男"
//            user?.sex = 1
        }else{
            sexTextFiled?.text = "女"
//            user?.sex = 2
        }
    }
}



