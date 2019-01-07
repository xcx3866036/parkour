//
//  LoginViewController.swift
//  sugarProject
//
//  Created by 杜鹏 on 2017/9/19.
//  Copyright © 2017年 杜鹏. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import SVProgressHUD
import CryptoSwift
import SkyFloatingLabelTextField


class LoginViewController: UIViewController {

    var countDown:TCCountDown!
    var segment: ZKSegment!
    var selIndex:Int = 0
    var isAgree = true
    var lng:Double! = 0
    var lat:Double! = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "登录"
        self.configUI()
        
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(LoginViewController.viewtap(_:)))
        self.view.addGestureRecognizer(gesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.view.endEditing(true)
    }
    

    // MARK: - Button actin
    @objc func TFRightViewClick(_ button:UIButton){
        switch button.tag {
        case 1000: // 清除账号
            print("清除账号")
            nameField.text = ""
        case 2000: // 显示密码 隐藏密码
            print("显示密码")
            if button.isSelected {
                button.isSelected = false
            }else{
                button.isSelected = true
            }
            passwordField.isSecureTextEntry = !button.isSelected
        default:
             print("button_click")
        }
    }
    
    @objc func viewtap(_ recog:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    @objc func login(){
        self.view.endEditing(true)
        guard self.isAgree else {
            SVProgressHUD.showError(withStatus: "请先阅读并同意信息服务协议")
            return
        }
        guard let nam = self.nameField.text?.trimmed(), nam.length > 0 else {
            SVProgressHUD.showError(withStatus: "未输入手机号")
            return
        }
        guard nam =~ phonePattern else {
            SVProgressHUD.showError(withStatus: "请输入正确的11位手机号")
            return
        }
        var inputPsw = self.passwordField.text?.trimmed()
        var inputCode = self.codeField.text?.trimmed()
        if selIndex == 0 {
            guard let psw = inputPsw, psw.length > 0 else {
                SVProgressHUD.showError(withStatus: "未输入密码")
                return
            }
            guard psw.containNumberAndAlphaBAndCapitalAlpha(minLen: 8) else {
                SVProgressHUD.showError(withStatus: "请输入8~16位大、小写字母和数字组合密码")
                return
            }
            inputCode = ""
        }
        else if selIndex == 1 {
            guard let code = inputCode,code.length > 0 else {
                SVProgressHUD.showError(withStatus: "未输入验证码")
                return
            }
            
            guard code.length == 6 else {
                SVProgressHUD.showError(withStatus: "请输入正确的验证码")
                return
            }
            inputPsw = ""
        }
        
        self.loginWitnAccount(account: nam, pwd: inputPsw!, code: inputCode!)
    }
    
    /// 找回密码
    @objc func findPassword(){
        let findPasswod = ForgotPasswordVC()
        findPasswod.successFindCallBack = { [unowned self] (phoneStr) in
            self.nameField.text = phoneStr
        }
        self.navigationController?.pushViewController(findPasswod, animated: true)
    }
    
    /// 同意用户协议
    @objc func agreeInfoProtocol(){
        isAgree = !isAgree
        agreeBtn.isSelected = isAgree
    }
    
    /// 查看用户协议
    @objc func checkInfoProtocol(){
        let agreeView = InfoMaskView()
        agreeView.configProtocolSubView()
        UIApplication.shared.keyWindow?.addSubview(agreeView)
        agreeView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
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
//        TField.placeholderFont = UIFont.boldSystemFont(ofSize: 18 * kDrawdownRatioH)
        TField.placeholderFont = UIFont.systemFont(ofSize: 17 * kDrawdownRatioH)
        TField.selectedLineHeight = 0.5
        TField.lineColor = RGB(216, g: 216, b: 216)
        TField.selectedLineColor = RGB(0, g: 121, b: 255)
        TField.placeholderColor = RGB(39, g: 39, b: 39)
        TField.selectedTitleColor = RGB(39, g: 39, b: 39)
        TField.titleColor = RGB(39, g: 39, b: 39)
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
    
    // MARK:network methods
    @objc func getCheckMessage(btn:UIButton) {
    
        if btn.isSelected { return }
        let result = self.verifyPhoneNumber(phoneStr: self.nameField.text?.trimmed())
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
    
    func loginWitnAccount(account:String, pwd: String, code: String) {
        SVProgressHUD.setDefaultMaskType(.clear)
        let salt = random16String()
        let fullPwd = (pwd.md5() + salt).md5()
        ApiLoadingProvider.request(PAPI.login(loginName: account,
                                              password: fullPwd,
                                              messageCode: code,
                                              salt: salt,
                                              longitude: 0.0,
                                              latitude: 0.0,
                                              location: ""),
                                   model: LoginModel.self) { (result, resultInfo) in
            if let codeError = resultInfo.2 {
                self.noNetwork = codeError.code == 2
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                SVProgressHUD.showSuccess(withStatus: resultInfo.1)
                Defaults[.token] = result?.token ?? ""
                let user = result?.user
                UserModel.save(model: user)
                NotificationCenter.default.post(name: Notification.Name(kLoginSuccessNotification), object: nil)
                self.dismissVC(completion:nil)
            }
        }
    }
    
    //MARK: - UI
    lazy var logoImgView: UIImageView = {
        let imgView = UIFactoryGenerateImgView(imageName: "login_logo")
        return imgView
    }()
    
    lazy var logoBgView: UIImageView = {
        let imgView = UIFactoryGenerateImgView(imageName: "login_bg")
        return imgView
    }()
    
    lazy var commitBtn:UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 18,
                                       color: UIColor.white,
                                       placeText: "登录",
                                       imageName: "")
        btn.backgroundColor = RGB(25, g: 81, b: 255)
        btn.setCornerRadius(radius: 6)
        btn.addTarget(self, action: #selector(login), for: .touchUpInside)
        return btn
    }()
    
    lazy var findPasswordBtn:UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 15,
                                       color: RGB(29, g: 29, b: 29),
                                       placeText: "忘记密码？",
                                       imageName: "")
        btn.addTarget(self, action: #selector(findPassword), for: .touchUpInside)
        return btn
    }()
    
    lazy var findPasswordBtnLine:UIView = {
        let line = UIView()
        line.backgroundColor = RGB(29, g: 29, b: 29)
        return line
    }()
    
    lazy var agreeBtn: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 15,
                                       color: RGB(29, g: 29, b: 29),
                                       placeText: "  同意",
                                       imageName: "agree_normal")
        btn.setImage(UIImage.init(named: "agree_sel"), for: .selected)
        btn.setTitle("  同意", for: .normal)
        btn.addTarget(self, action: #selector(agreeInfoProtocol), for: .touchUpInside)
        btn.isSelected = isAgree
        return btn
    }()
    
    lazy var protocolLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 15,
                                       color: RGB(16, g: 124, b: 255),
                                       placeText: "")
        lab.textAlignment = .center
        let myString = "用户协议"
        let myAttribute = [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue]
        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
        lab.attributedText = myAttrString
        lab.addTapGesture(target: self, action: #selector(checkInfoProtocol))
        return lab
    }()

    lazy var nameField: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        field.keyboardDistanceFromTextField = 180
        field.tag = 80
        field.keyboardType = UIKeyboardType.numberPad
        field.placeholder = "手机号"
        self.configBaseACFloatingTextfield(TField: field)
        return field
    }()
    lazy var passwordField: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        field.keyboardDistanceFromTextField = 100
        field.tag = 82
        field.isSecureTextEntry = false
        field.keyboardType = UIKeyboardType.namePhonePad
        field.placeholder = "密码"
        field.isSecureTextEntry = true
        self.configBaseACFloatingTextfield(TField: field)
        return field
    }()
    lazy var codeField: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        field.keyboardDistanceFromTextField = 140
        field.keyboardType = UIKeyboardType.numberPad
        field.tag = 81
        self.configBaseACFloatingTextfield(TField: field)
        field.placeholder = "验证码"
        return field
    }()
    
    func configSegment(){
        segment = ZKSegment.init(frame: CGRect(x: -16, y: 280 * kDrawdownRatioH, width: 280, height: 45),
                                 style: .line,
                                 itemColor: RGB(137, g: 137, b: 137),
                                 itemSelectedColor: RGB(56, g: 56, b: 56),
                                 itemStyleSelectedColor: RGB(39, g: 110, b: 255),
                                 itemFont: UIFont.systemFont(ofSize: 18),
                                 itemMargin: 40,
                                 items: ["密码登录", "验证码登录"],
                                 change: { (index, item) in
                                    self.selIndex = index
                                    self.reConfigUI()
        })
        
        segment.backgroundColor = UIColor.clear
        self.view.addSubview(segment)
    }
    
    func configUI() {
        self.view.addSubview(logoBgView)
        logoBgView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(280 * kDrawdownRatioH)
        }
        
        logoBgView.addSubview(logoImgView)
        logoImgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(74 * kDrawdownRatioH)
            make.centerX.equalToSuperview()
            make.width.equalTo(155 * kDrawdownRatioW)
            make.height.equalTo(100 * kDrawdownRatioH)
        }
        
        self.view.addSubview(commitBtn)
        commitBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(45)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50 * kDrawdownRatioH)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-50 * kDrawdownRatioH)
            }
        }
//        commitBtn.addGradientLayerWithColors(bounds: CGRect.init(x: 0, y: 0, w: SCREEN_WIDTH - 60, h: 45))
        commitBtn.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "btn_bg")!)
        
        view.addSubview(findPasswordBtn)
        findPasswordBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-30)
            make.width.equalTo(80)
            make.height.equalTo(44)
            make.bottom.equalTo(commitBtn.snp.top).offset(-21 * kDrawdownRatioH)
        }
        
        view.addSubview(agreeBtn)
        agreeBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.width.equalTo(60)
            make.height.equalTo(30)
            make.centerY.equalTo(findPasswordBtn.snp.centerY)
        }
        
        view.addSubview(protocolLab)
        protocolLab.snp.makeConstraints { (make) in
            make.left.equalTo(agreeBtn.snp.right).offset(0)
            make.width.equalTo(65)
            make.height.equalTo(30)
            make.centerY.equalTo(findPasswordBtn.snp.centerY)
        }
        
        view.addSubview(findPasswordBtnLine)
        findPasswordBtnLine.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.right.equalToSuperview().offset(-30)
            make.width.equalTo(80)
            make.top.equalTo(findPasswordBtn.snp.bottom).offset(-14)
        }
        
        setNameField()
        setPasswordField()
        setCodeField()
        
        self.configSegment()
    }
    
    func reConfigUI(){
        if selIndex == 0 {
            print("密码登录")
            codeField.isHidden = true
            passwordField.isHidden = false
            findPasswordBtn.isHidden = false
            findPasswordBtnLine.isHidden = false
        }
        else if selIndex == 1 {
            print("验证码登录")
            codeField.isHidden = false
            passwordField.isHidden = true
            findPasswordBtn.isHidden = true
            findPasswordBtnLine.isHidden = true
        }
    }
    
    func setNameField(){
        let user = UserModel.read()
        nameField.text = user?.cellphone
        view.addSubview(nameField)
        nameField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalTo(logoBgView.snp.bottom).offset(45 + 25)
            make.height.equalTo(60 * kDrawdownRatioH)
        }
        
        let accRightView = UIButton()
        accRightView.setImage(#imageLiteral(resourceName: "login_delete"), for: .normal)
        accRightView.addTarget(self,
                               action: #selector(TFRightViewClick(_:)),
                               for: UIControlEvents.touchUpInside)
        accRightView.contentMode = .right
        accRightView.w = 20
        accRightView.h = 20
        accRightView.tag = 1000
        nameField.rightView = accRightView
        nameField.rightViewMode = .whileEditing
        
        if let name = Defaults[.userName]{
            nameField.text = name
        }
    }
    
    func setPasswordField() {
        view.addSubview(passwordField)
        passwordField.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalTo(nameField.snp.bottom).offset(12)
            make.height.equalTo(60 * kDrawdownRatioH)
            
        })
        
        let accRightView = UIButton.init(frame: CGRect.init(x: 0, y: 0, w: 20, h: 20))
        accRightView.setImage(#imageLiteral(resourceName: "login_pwd_show"), for: .selected)
        accRightView.setImage(#imageLiteral(resourceName: "login_pwd_hide"), for: .normal)
        accRightView.addTarget(self,
                               action: #selector(TFRightViewClick(_:)),
                               for: UIControlEvents.touchUpInside)
        accRightView.contentMode = .right
        accRightView.tag = 2000
        
        passwordField.rightView = accRightView
        passwordField.rightViewMode = .whileEditing
        
    }
    
    func setCodeField(){
        view.addSubview(codeField)
        codeField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalTo(nameField.snp.bottom).offset(12)
            make.height.equalTo(60 * kDrawdownRatioH)
        }
        
        let accRightView :UIButton
        
        countDown = TCCountDown()
        countDown.isCounting = false
        accRightView = countDown.codeBtn
        accRightView.layer.cornerRadius = 2
        accRightView.layer.masksToBounds = true
        accRightView.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        accRightView.addTarget(self,
                               action: #selector(LoginViewController.getCheckMessage(btn:)),
                               for: UIControlEvents.touchUpInside)
        accRightView.contentMode = .center
        accRightView.contentHorizontalAlignment = .right
        accRightView.w = 100
        accRightView.h = 20
        accRightView.tag = 90
        
        codeField.rightView = accRightView
        codeField.rightViewMode = .always
    }
}

/// 更新位置
extension LoginViewController {
    func updateLocation() {
//        LocationManagerSwift.shared.updateLocation { (latitude, longitude, status, error) in
//            if status == .OK {
//                self.lat = latitude
//                self.lng = longitude
//            }
//        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    // MARK: textField delegate
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        let nsString = textField.text as NSString?
        let newString = nsString?.replacingCharacters(in: range, with: string)
        let length:NSInteger = (newString?.count)!
        if textField == nameField {
            if length > 11 {
                return false
            }
        }

        if textField == passwordField {
            if length > 16 {
                return false
            }
            let StringSet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz" //不允许输入其他字符
            for c in string {
                if  !StringSet.contains(String(c)){
                    return false
                }
            }
        }
        
        if textField == codeField {
            if length > 6 {
                return false
            }
        }
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField){
        
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        //        endEditBlock?(textField.text!)
    }
}




