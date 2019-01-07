//
//  FindPasswordViewController.swift
//  CMIOTBase
//
//  Created by Apple on 2018/9/29.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import Foundation
import UIKit
import CryptoSwift
import SwiftyUserDefaults
import SnapKit
import SVProgressHUD
import SkyFloatingLabelTextField
import IQKeyboardManagerSwift


class FindPasswordViewController: UIViewController,UITextFieldDelegate,NavBarTitleChangeable {
    var bgView: UIView!
    var nameField: SkyFloatingLabelTextField!
    var passwordField: SkyFloatingLabelTextField!
    var newpasswordField: SkyFloatingLabelTextField!
    var newpasswordField1: SkyFloatingLabelTextField!
    
    var commitBtn: UIButton!
    var countDown:TCCountDown!

    public var dismissingBlock: ((Bool) -> Void)?
    
    // MARK: life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = kBackgroundColor
        self.title = "修改密码"
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let delegate = appDelegate {
            delegate.changeNavigationBarDefaultInVC(rootVC: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.countDown != nil {
            self.countDown.isCounting = false
        }
    }
    
    // MARK: UI
    func configureUI() {
        
        bgView = UIView()
        bgView.backgroundColor = UIColor.white
        bgView.layer.cornerRadius = 10
        view.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(406)
        }
        
        
        setTextfield1()
        setTextField2()
        setTextField3()
        setTextField4()
    
        commitBtn = UIButton(type: .custom)
        let buttonTitle = "确认"
        commitBtn.setTitle(buttonTitle, for: .normal)
        commitBtn.setTitleColor(UIColor.white, for: .normal)
        //commitBtn.backgroundColor = RGB(25, g: 81, b: 255)
        commitBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        commitBtn.setCornerRadius(radius: 6)
        commitBtn.addTarget(self, action: #selector(ForgotPasswordVC.clickButton(_:)), for: UIControlEvents.touchUpInside)
        bgView.addSubview(commitBtn)
        commitBtn.snp.makeConstraints { (make) -> Void in
            make.bottom.equalToSuperview().offset(-27)
            make.height.equalTo(45)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
        commitBtn.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "MineCommitBG")!)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.viewtap(_:)))
        self.view.addGestureRecognizer(gesture)
    }
    
    func setTextfield1(){
        
        nameField = SkyFloatingLabelTextField()
        nameField.keyboardDistanceFromTextField = 180
        nameField.tag = 80
        nameField.keyboardType = UIKeyboardType.numberPad
        nameField.isUserInteractionEnabled = false
        //nameField.placeholder = "手机号"
        
        self.configBaseACFloatingTextfield(TField: nameField)
        
        bgView.addSubview(nameField)
        nameField.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(11)
            make.height.equalTo(60)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
        nameField.text = (UserModel.read()?.cellphone)!
    }
    
    func setTextField2() {
        
        passwordField = SkyFloatingLabelTextField()
        passwordField.keyboardDistanceFromTextField = 140
        passwordField.tag = 81
        self.configBaseACFloatingTextfield(TField: passwordField)
        passwordField.placeholder = "短信验证码"
        
        bgView.addSubview(passwordField)
        passwordField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(nameField.snp.bottom).offset(12)
            make.height.equalTo(60)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
        
        let accRightView :UIButton
        passwordField.keyboardType = UIKeyboardType.numberPad
        countDown = TCCountDown()
        countDown.isCounting = false
        accRightView = countDown.codeBtn
        accRightView.layer.cornerRadius = 2
        accRightView.layer.masksToBounds = true
        accRightView.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        accRightView.addTarget(self, action: #selector(ForgotPasswordVC.getCheckMessage(btn:)), for: UIControlEvents.touchUpInside)
        accRightView.contentMode = .center
        accRightView.contentHorizontalAlignment = .right
        accRightView.w = 100
        accRightView.h = 20
        passwordField.isSecureTextEntry = false
        
        //        tfBgView.addSubview(accRightView)
        //        accRightView.snp.makeConstraints { (make) in
        //            make.top.equalToSuperview().offset(2)
        //            make.height.equalTo(20)
        //            make.width.equalTo(100)
        //            make.right.equalToSuperview()
        //        }
        accRightView.tag = 90
        passwordField.rightView = accRightView
        passwordField.rightViewMode = .always
    }
    
    func setTextField3(){
        
        newpasswordField = SkyFloatingLabelTextField()
        newpasswordField?.keyboardDistanceFromTextField = 100
        newpasswordField?.tag = 82
        newpasswordField?.isSecureTextEntry = true
        newpasswordField?.keyboardType = UIKeyboardType.namePhonePad
        self.configBaseACFloatingTextfield(TField: newpasswordField)
        newpasswordField?.placeholder = "新密码"
        
        bgView.addSubview(newpasswordField!)
        newpasswordField?.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(passwordField.snp.bottom).offset(12)
            make.height.equalTo(60)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
        
        //            let accRightView = UIButton()
        //            self.configTextfieldRightButtonView(accRightView: accRightView)
        //            newpasswordField?.rightView = accRightView
        //            newpasswordField?.rightViewMode = .always
        //            accRightView.tag = 91
    }
    
    func setTextField4(){
        
        newpasswordField1 = SkyFloatingLabelTextField()
        newpasswordField1?.keyboardDistanceFromTextField = 100
        newpasswordField1?.tag = 83
        newpasswordField1?.isSecureTextEntry = true
        newpasswordField1?.keyboardType = UIKeyboardType.namePhonePad
        newpasswordField1?.placeholder = "确认密码"
        self.configBaseACFloatingTextfield(TField: newpasswordField1)
        bgView.addSubview(newpasswordField1!)
        newpasswordField1?.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(newpasswordField.snp.bottom).offset(12)
            make.height.equalTo(60)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
        
        //        let accRightView = UIButton()
        //        self.configTextfieldRightButtonView(accRightView: accRightView)
        //        accRightView.tag = 92
        //        newpasswordField1?.rightView = accRightView
        //        newpasswordField1?.rightViewMode = .always
    }
    
    @objc func clickButton(_ button:UIButton){
        self.view.endEditing(true)
        completeBtnClick()
    }
    
    @objc func passwordShow(_ button:UIButton){
        button.isSelected = !button.isSelected
        if button.tag == 90 {
            passwordField.isSecureTextEntry = !button.isSelected
        }
        else if button.tag == 91{
            newpasswordField?.isSecureTextEntry = !button.isSelected
        }
        else{
            newpasswordField1?.isSecureTextEntry = !button.isSelected
        }
    }
    
    @objc func viewtap(_ recog:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    // MARK: textField delegate
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let nsString = textField.text as NSString?
        let newString = nsString?.replacingCharacters(in: range, with: string)
        let StringSet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz" //不允许输入其他字符
        
        if textField == nameField {
            if (newString?.length)! > 11 {
                return false
            }
        }
        else if textField == passwordField {
            if (newString?.length)! > 18 {
                return false
            }
            for c in string.characters {
                if !StringSet.contains(String(c)){
                    return false
                }
            }
        }
        else{
            if (newString?.length)! > 18 {
                return false
            }
            for c in string.characters {
                if !StringSet.contains(String(c)){
                    return false
                }
            }
        }
        return true
    }
    
    // MARK:network methods
    @objc func getCheckMessage(btn:UIButton) {
        if btn.isSelected { return }
        let result = self.verifyPhoneNumber(phoneStr: self.nameField.text)
        guard result else { return } // 手机号码不正确
        
        let nam = self.nameField.text ?? ""
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.show()
        ApiLoadingProvider.request(PAPI.getMessageCode(loginName: nam), model: BaseModel.self) { (result, resultInfo) in
            if let codeError = resultInfo.2 {
                self.noNetwork = codeError.code == 2
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                self.countDown.isCounting = true
                SVProgressHUD.showSuccess(withStatus: resultInfo.1)
            }
        }
    }
    
    // 完成
    func completeBtnClick() {
        findPassword()
    }
    
    
    func findPassword() {
        let result = self.verifyPhoneNumber(phoneStr: self.nameField.text)
        guard result else { return } // 电话号码格式不正确
        
        let codeResult = self.verifyCode(codeStr: self.passwordField.text)
        guard codeResult else { return } // 验证码不正确
        
        let pwdResult =  self.verifyPassward(pwdStr: self.newpasswordField?.text, newType: 1)
        guard pwdResult else { return } // 密码格式不正确
        
        let npsw = self.newpasswordField?.text ?? ""
        
        guard let npsw1 = self.newpasswordField1?.text, npsw == npsw1 else{
            SVProgressHUD.showError(withStatus: "密码和确认密码不一致")
            return
        }
        let cd = self.newpasswordField.text ?? ""
        let fullPwd = cd.md5()
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.show()

        ApiLoadingProvider.request(PAPI.resetPassword(loginName: self.nameField.text!, messageCode: (self.passwordField.text)!, passworrd: fullPwd), model: BaseModel.self) { (result, info) in
            if let codeError = info.2 {
                self.noNetwork = codeError.code == 2
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                SVProgressHUD.showSuccess(withStatus: "密码修改成功，请重新登录")
                let loginVC = LoginViewController()
                let login = UINavigationController.init(rootViewController: loginVC)
                self.present(login, animated: false) { }
            }
        }
    }
    
    //MARK: - Function
    /// SkyFloatingLabelTextField 基本配置
    func configBaseACFloatingTextfield(TField: SkyFloatingLabelTextField){
        TField.delegate = self
        TField.borderStyle = UITextBorderStyle.none
        TField.textColor = .black
        TField.font = UIFont.systemFont(ofSize: 13 * kRatioToIP6W)
        TField.adjustsFontSizeToFitWidth = true
        TField.minimumFontSize = 13  //最小可缩小的字号
        TField.tintColor = UIColor.colorWithHexString(hex: "#55b7f9",alpha:1)
        TField.contentVerticalAlignment = .center  //垂直居中对齐
        TField.clearButtonMode = .whileEditing //编辑时出现清除按钮
        TField.returnKeyType = UIReturnKeyType.done //表示完成输入
        TField.placeholderFont = UIFont.boldSystemFont(ofSize: 18)
        TField.selectedLineHeight = 0.5
        TField.lineColor = RGB(216, g: 216, b: 216)
        TField.selectedLineColor = RGB(0, g: 121, b: 255)
        TField.placeholderColor = RGB(39, g: 39, b: 39)
        TField.selectedTitleColor = RGB(39, g: 39, b: 39)
        TField.titleColor = RGB(39, g: 39, b: 39)
    }
    
    func configTextfieldRightButtonView(accRightView:UIButton){
        accRightView.setImage(UIImage(named:"password_n"), for: .normal)
        accRightView.setImage(UIImage(named:"password_p"), for: .selected)
        accRightView.addTarget(self, action: #selector(ForgotPasswordVC.passwordShow(_:)), for: UIControlEvents.touchUpInside)
        accRightView.contentMode = .right
        accRightView.w = 40
        accRightView.h = 40
    }
    
    /// 验证手机号长度和格式
    func verifyPhoneNumber(phoneStr: String?) -> Bool {
        guard let nam = phoneStr, nam.length > 0 else {
            SVProgressHUD.showError(withStatus: "手机号码不能为空")
            return false
        }
        guard nam =~ phonePattern else {
            SVProgressHUD.showError(withStatus: "请输入正确的手机号码")
            return false
        }
        return true
    }
    
    /// 验证密码长度和格式 newType:0 数字、字母大写或小写 1：数字、字母大写和小写
    func verifyPassward(pwdStr: String?, newType: Int = 0) -> Bool {
        guard  let psw:String = pwdStr, psw.length > 0 else {
            SVProgressHUD.showError(withStatus: "密码不能为空")
            return false
        }
        if newType == 0 {
            if !psw.containNumberAndAlphaB(minLen: 8){
                SVProgressHUD.showError(withStatus: "请输入正确8-18位数字字母组合密码")
                return false
            }
        }
        else if newType == 1 {
            if !psw.containNumberAndAlphaBAndCapitalAlpha(minLen: 8){
                SVProgressHUD.showError(withStatus: "请输入8~18位大、小写字母和数字组合新密码")
                return false
            }
        }
        return true
    }
    
    /// 验证 验证码格式
    func verifyCode(codeStr: String?) -> Bool {
        guard let code = codeStr,code.length > 0 else {
            SVProgressHUD.showError(withStatus: "验证码不能为空")
            return false
        }
        if code.length != 6 {
            SVProgressHUD.showError(withStatus: "请输入正确的验证码")
            return false
        }
        return true
    }
}

//MARK: - NavBarTitleChangeable
extension FindPasswordViewController {
    var preferredTextAttributes: [NSAttributedStringKey : AnyObject] {
        let item = FunNavTitleTextAttributesItem(color: UIColor.black, font:nil)
        return getNavgationBarTitleTextAttributes(with: item)
    }
}

