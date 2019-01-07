//
//  LoginViewController.swift
//  EntranceGuardV2.0
//
//  Created by 杜鹏 on 17/4/27.
//  Copyright © 2017年 gh. All rights reserved.
//

import Foundation
import UIKit
import CryptoSwift
import SwiftyUserDefaults
import SnapKit
import SVProgressHUD
import SkyFloatingLabelTextField
import IQKeyboardManagerSwift

class ForgotPasswordVC: UIViewController,UITextFieldDelegate {
   
    var nameField: SkyFloatingLabelTextField!
    var codeField: SkyFloatingLabelTextField!
    var passwordField: SkyFloatingLabelTextField!
    var newpasswordField: SkyFloatingLabelTextField!
    var countDown:TCCountDown!
    var successFindCallBack: ((String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.title = "忘记密码"
        configureUI()
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
    lazy var bgView: UIImageView = {
        let imgView = UIFactoryGenerateImgView(imageName: "forgot_pwd_bg")
        return imgView
    }()
    
    lazy var commitBtn: UIButton = {
        let btn = UIButton(type: .custom)
        let buttonTitle = "确认"
        btn.setTitle(buttonTitle, for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = RGB(25, g: 81, b: 255)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.setCornerRadius(radius: 6)
        btn.addTarget(self,
                      action: #selector(ForgotPasswordVC.clickButton(_:)),
                      for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    func configureUI() {
        view.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(0)
            make.height.equalTo(200 * kDrawdownRatioH)
        }
        
        let backBtn = self.creatBackButton()
        view.addSubview(backBtn)
        
        setTextfield1()
        setTextField2()
        setTextField3()
        setTextField4()
        
        view.addSubview(commitBtn)
        commitBtn.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(45)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30 * kDrawdownRatioH)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-30 * kDrawdownRatioH)
            }
        }
//        commitBtn.addGradientLayerWithColors(bounds: CGRect.init(x: 0, y: 0, w: SCREEN_WIDTH - 48, h: 45))
        commitBtn.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "btn_bg")!)
        
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(ForgotPasswordVC.viewtap(_:)))
        self.view.addGestureRecognizer(gesture)
    }
    
    func setTextfield1(){
    
        nameField = SkyFloatingLabelTextField()
        nameField.keyboardDistanceFromTextField = 180
        nameField.tag = 80
        nameField.keyboardType = UIKeyboardType.numberPad
        nameField.placeholder = "手机号"
        self.configBaseACFloatingTextfield(TField: nameField)
        
        view.addSubview(nameField)
        nameField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(bgView.snp.bottom).offset(10)
            make.height.equalTo(60 * kDrawdownRatioH)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
         nameField.text = Defaults[.userName]
    }
    
    func setTextField2() {
        
        codeField = SkyFloatingLabelTextField()
        codeField.keyboardDistanceFromTextField = 140
        codeField.tag = 81
        self.configBaseACFloatingTextfield(TField: codeField)
        codeField.placeholder = "短信验证码"
        
        view.addSubview(codeField)
        codeField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(nameField.snp.bottom).offset(12)
            make.height.equalTo(60 * kDrawdownRatioH)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
        
        let accRightView :UIButton
        codeField.keyboardType = UIKeyboardType.numberPad
        countDown = TCCountDown()
        countDown.isCounting = false
        accRightView = countDown.codeBtn
        accRightView.layer.cornerRadius = 2
        accRightView.layer.masksToBounds = true
        accRightView.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        accRightView.addTarget(self,
                               action: #selector(ForgotPasswordVC.getCheckMessage(btn:)),
                               for: UIControlEvents.touchUpInside)
        accRightView.contentMode = .center
        accRightView.contentHorizontalAlignment = .right
        accRightView.w = 100
        accRightView.h = 20
        codeField.isSecureTextEntry = false
        
//        tfBgView.addSubview(accRightView)
//        accRightView.snp.makeConstraints { (make) in
//            make.top.equalToSuperview().offset(2)
//            make.height.equalTo(20)
//            make.width.equalTo(100)
//            make.right.equalToSuperview()
//        }
        accRightView.tag = 90
        codeField.rightView = accRightView
        codeField.rightViewMode = .always
    }
    
    func setTextField3(){
       
        passwordField = SkyFloatingLabelTextField()
        passwordField?.keyboardDistanceFromTextField = 100
        passwordField?.tag = 82
        passwordField?.isSecureTextEntry = true
        passwordField?.keyboardType = UIKeyboardType.namePhonePad
        self.configBaseACFloatingTextfield(TField: passwordField)
        passwordField?.placeholder = "新密码"
        
        view.addSubview(passwordField!)
        passwordField?.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(codeField.snp.bottom).offset(12)
            make.height.equalTo(60 * kDrawdownRatioH)
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

        newpasswordField = SkyFloatingLabelTextField()
        newpasswordField?.keyboardDistanceFromTextField = 100
        newpasswordField?.tag = 83
        newpasswordField?.isSecureTextEntry = true
        newpasswordField?.keyboardType = UIKeyboardType.namePhonePad
        newpasswordField?.placeholder = "确认密码"
        self.configBaseACFloatingTextfield(TField: newpasswordField)
        view.addSubview(newpasswordField!)
        newpasswordField?.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(passwordField.snp.bottom).offset(12)
            make.height.equalTo(60 * kDrawdownRatioH)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
        
//        let accRightView = UIButton()
//        self.configTextfieldRightButtonView(accRightView: accRightView)
//        accRightView.tag = 92
//        newpasswordField1?.rightView = accRightView
//        newpasswordField1?.rightViewMode = .always
    }
    
    
    // MARK: button actions
    @objc func backClick(_ button:UIButton){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc func clickButton(_ button:UIButton){
        self.view.endEditing(true)
        completeBtnClick()
    }
    
    @objc func passwordShow(_ button:UIButton){
        button.isSelected = !button.isSelected
        if button.tag == 90 {
            codeField.isSecureTextEntry = !button.isSelected
        }
        else if button.tag == 91{
            passwordField?.isSecureTextEntry = !button.isSelected
        }
        else{
            newpasswordField?.isSecureTextEntry = !button.isSelected
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
        else if textField == codeField {
            if (newString?.length)! > 6 {
                return false
            }
        }
        else{
            if (newString?.length)! > 16 {
                return false
            }
            for c in string {
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
        ApiLoadingProvider.request(PAPI.getMessageCode(loginName: nam),
                                   model: BaseModel.self) { (result, resultInfo) in
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
        let result = self.verifyPhoneNumber(phoneStr: self.nameField.text?.trimmed())
        guard result else { return } // 电话号码格式不正确
        
        let codeResult = self.verifyCode(codeStr: self.codeField.text?.trimmed())
        guard codeResult else { return } // 验证码不正确
        
        let pwdResult =  self.verifyPassward(pwdStr: self.passwordField?.text?.trimmed(), newType: 1)
        guard pwdResult else { return } // 密码格式不正确
        
        let npsw = self.passwordField?.text ?? ""
        
        guard let npsw1 = self.newpasswordField?.text?.trimmed(), npsw == npsw1 else{
            SVProgressHUD.showError(withStatus: "两次密码输入不一致")
            return
        }
        
        let nam = self.nameField.text ?? ""
        let cd = self.codeField.text ?? ""
        SVProgressHUD.setDefaultMaskType(.clear)
        ApiLoadingProvider.request(PAPI.findPassword(loginName: nam,
                                                     password: npsw.md5(),
                                                     messageCode: cd),
                                   model: BaseModel.self) { (result, resultInfo) in
            if let codeError = resultInfo.2 {
                self.noNetwork = codeError.code == 2
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                SVProgressHUD.showSuccess(withStatus: resultInfo.1)
                if let callback = self.successFindCallBack {
                    callback(nam)
                }
                self.popVC()
            }
        }
    }
    
    //MARK: - Function
    /// SkyFloatingLabelTextField 基本配置
    func configBaseACFloatingTextfield(TField: SkyFloatingLabelTextField){
        TField.delegate = self
        TField.borderStyle = UITextBorderStyle.none
        TField.textColor = .black
        TField.font = UIFont.systemFont(ofSize: 13 * kDrawdownRatioH)
        TField.adjustsFontSizeToFitWidth = true
        TField.minimumFontSize = 13 * kDrawdownRatioH  //最小可缩小的字号
        TField.tintColor = UIColor.colorWithHexString(hex: "#55b7f9",alpha:1)
        TField.contentVerticalAlignment = .center  //垂直居中对齐
        TField.clearButtonMode = .whileEditing //编辑时出现清除按钮
        TField.returnKeyType = UIReturnKeyType.done //表示完成输入
        TField.placeholderFont = UIFont.boldSystemFont(ofSize: 18 * kDrawdownRatioH)
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
            SVProgressHUD.showError(withStatus: "未输入手机号")
            return false
        }
        guard nam =~ phonePattern else {
            SVProgressHUD.showError(withStatus: "请输入正确的11位手机号")
            return false
        }
        return true
    }
    
    /// 验证密码长度和格式 newType:0 数字、字母大写或小写 1：数字、字母大写和小写
    func verifyPassward(pwdStr: String?, newType: Int = 0) -> Bool {
        guard  let psw:String = pwdStr, psw.length > 0 else {
            SVProgressHUD.showError(withStatus: "未输入新密码")
            return false
        }
        if newType == 0 {
            if !psw.containNumberAndAlphaB(minLen: 8){
                SVProgressHUD.showError(withStatus: "请输入8~16位大、小写字母和数字组合新密码")
                return false
            }
        }
        else if newType == 1 {
            if !psw.containNumberAndAlphaBAndCapitalAlpha(minLen: 8){
                SVProgressHUD.showError(withStatus: "请输入8~16位大、小写字母和数字组合新密码")
                return false
            }
        }
        return true
    }
    
    /// 验证 验证码格式
    func verifyCode(codeStr: String?) -> Bool {
        guard let code = codeStr,code.length > 0 else {
            SVProgressHUD.showError(withStatus: "未输入验证码")
            return false
        }
        if code.length != 6 {
            SVProgressHUD.showError(withStatus: "请输入正确的验证码")
            return false
        }
        return true
    }
    
    /// 更新位置
    func updateLocation() {
//        LocationManagerSwift.shared.updateLocation { (latitude, longitude, status, error) in
//            if status == .OK {
//                self.lat = latitude
//                self.lng = longitude
//            }
//        }
    }
    
    /// 忘记密码 返回登录
    func creatBackButton() -> CSButton {
        let btn = CSButton.init(frame: CGRect(x: 20, y: kStatusBarH + 10, w: 60, h: 25))
        btn.imagePositionMode = .left
        btn.setImage(UIImage.init(named: "white_back_arrow"), for: .normal)
        btn.setTitle("登录", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        return btn
    }
}
