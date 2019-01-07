//
//  EqualExchangeScanVC.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/9.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import AVFoundation
import SVProgressHUD
import PermissionScope

class EqualExchangeScanVC: UIViewController,AVCaptureMetadataOutputObjectsDelegate,NavBarTitleChangeable {

    var device:AVCaptureDevice!
    var input:AVCaptureDeviceInput!
    var outPut:AVCaptureMetadataOutput!
    var session:AVCaptureSession!
    var previewLayer:AVCaptureVideoPreviewLayer!
    let radius = CGFloat(129)
    var inputCallback: ((String,Int) -> ())?
    var selIndex: Int = -1
    let pscope = PermissionScope()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "扫码添加"
        view.backgroundColor = RGB(247, g: 248, b: 251)
        self.fetchCameraPermission()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let delegate = appDelegate {
            delegate.changeBlackNavigationBarLightContentInVC(rootVC: self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let delegate = appDelegate {
            delegate.changeNavigationBarDefaultInVC(rootVC: self)
        }
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let device = AVCaptureDevice.default(for:AVMediaType.video), device.hasTorch {
            do {
                try device.lockForConfiguration()
                device.torchMode = .off
                device.unlockForConfiguration()
            } catch {
                print("AVCaptureDevice Init Error")
                self.popVC()
            }
        }
    }
    
    func configAVCaptureSetting() {
            self.device = AVCaptureDevice.default(for:AVMediaType.video)
            do {
                self.input = try AVCaptureDeviceInput.init(device: self.device) as AVCaptureDeviceInput
            }
            catch let error as NSError {
                log.error(error)
            }
            self.outPut = AVCaptureMetadataOutput.init()
            self.outPut.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
            self.session = AVCaptureSession.init()
            if self.session.canAddInput(self.input){
                self.session.addInput(self.input)
            }
            if self.session.canAddOutput(self.outPut){
                self.session.addOutput(self.outPut)
            }
          self.session.sessionPreset = AVCaptureSession.Preset.hd1920x1080
          self.outPut.metadataObjectTypes = [.ean13,.ean8,.code128,.code39,.code93,.qr]

//            self.outPut.rectOfInterest = CGRect.init(x: 0, y: 0, w: 1, h: 1)
            let scanRect = CGRect.init(x: SCREEN_WIDTH / 2.0 - radius, y: 82, w: radius * 2, h: radius * 2)
            self.outPut.rectOfInterest = CGRect.init(x: scanRect.y / SCREEN_HEIGHT, y: scanRect.x / SCREEN_WIDTH, width: scanRect.h / SCREEN_HEIGHT, height: scanRect.w / SCREEN_WIDTH)
    
            self.previewLayer = AVCaptureVideoPreviewLayer.init(session: self.session)
            self.previewLayer.frame = self.view.bounds
            self.previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            self.view.layer.addSublayer(self.previewLayer)
    }
    
    func startScan() {
        self.configAVCaptureSetting()
        self.configUI()
        self.session.startRunning()
    }

    // MARK: - AVCaptureMetadataOutputObjectsDelegate
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection){
            for object in metadataObjects {
                let dataObject = previewLayer.transformedMetadataObject(for: object ) as! AVMetadataMachineReadableCodeObject
                if dataObject.stringValue != nil {
                   print("扫描结果: " + dataObject.stringValue!)
                    // 如果扫描结果不是10位数字，提示条码无效
                    guard dataObject.stringValue!.length > 0 else {
                        // 提示二维码无效
                        let noticeVC = UIAlertController.init(title: "错误", message:"条码无效", preferredStyle: .alert)
                        let sureAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default, handler: nil)
                        noticeVC.addAction(sureAction)
                        self.presentVC(noticeVC)
                        return
                    }
                    self.session.stopRunning()
                    self.removeLineAnimation()
                    self.scanSuccessWithResult(resultStr: dataObject.stringValue!)
                    break
                }
        }
    }
    
    //MARK: - ButtonPress
    @objc func lightButtonPress(sender: UIButton){
        if let device = AVCaptureDevice.default(for:AVMediaType.video), device.hasTorch {
            do {
                try device.lockForConfiguration()
                let torchOn = !device.isTorchActive
                try device.setTorchModeOn(level: 1.0)
                device.torchMode = torchOn ? .on : .off
                device.unlockForConfiguration()
            } catch {
                print("light Button Press Error")
            }
        }
    }
    
    @objc func cancleButtonPress(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - 获取相机权限
    func fetchCameraPermission(){
        let status = pscope.statusCamera()
        switch status {
        case .unknown:
          self.startScan()
        case .unauthorized:
          self.showErrorCamerPermissionAlert()
        case .disabled:
           self.showErrorCamerPermissionAlert()
        case .authorized:
            self.startScan()
        }
    }
    
    func requestCamerAccess(){
        if let url = URL(string: UIApplicationOpenSettingsURLString){
            if (UIApplication.shared.canOpenURL(url)){
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func showErrorCamerPermissionAlert() {
        let alertVC = UIAlertController.init(title: "权限提示", message:"请您设置允许APP访问您的相机", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: {
            action in
              self.popVC()
            })
        let okAction = UIAlertAction(title: "去授权", style: .default, handler: {
            action in
             self.requestCamerAccess()
        })
        alertVC.addAction(cancelAction)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    //MARK: - Function
    func scanSuccessWithResult(resultStr:String){
        let textStr = "scan result: ---" + resultStr
        print(textStr)
        let index = self.selIndex
        if let callback = self.inputCallback{
            callback(resultStr,index)
        }
         self.navigationController?.popViewController(animated: true)
    }
    
    func removeLineAnimation(){
        imageLine.layer.removeAllAnimations()
    }
    
    func addLineAnimation(){
        UIView.beginAnimations("moveLine", context: nil)
        UIView.setAnimationDuration(3)
        UIView.setAnimationCurve(.linear)
        UIView.setAnimationRepeatCount(10000000)
        imageLine.frame = CGRect.init(x: SCREEN_WIDTH / 2.0 - radius, y: 82 + radius * 2 , w: radius * 2, h: 3)
        UIView.commitAnimations()
    }
    
    //MARK: - UI
    lazy var tipsLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 14, color: RGB(255, g: 255, b: 255), placeText: "请将产品编码放入框内，自动扫描")
        lab.textAlignment = .center
        return lab
    }()
    
    lazy var lightUpBtn: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 0, color: UIColor.clear, placeText: "", imageName: "scan_light_up")
        btn.addTarget(self, action: #selector(lightButtonPress(sender:)), for: .touchUpInside)
        btn.contentHorizontalAlignment = .center
        btn.contentVerticalAlignment = .top
        return btn
    }()
    
    lazy var cancelBtn: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 18, color: UIColor.white, placeText: "取消", imageName: "")
        btn.addTarget(self, action: #selector(cancleButtonPress), for: .touchUpInside)
        btn.contentHorizontalAlignment = .center
        btn.addBorder(width: 1, color: UIColor.white)
        btn.setCornerRadius(radius: 6)
        return btn
    }()
    
    lazy var leftTopImgView: UIImageView = {
        let imgView = UIFactoryGenerateImgView(imageName: "scan_left_top")
        return imgView
    }()
    
    lazy var rightTopImgView: UIImageView = {
        let imgView = UIFactoryGenerateImgView(imageName: "scan_right_top")
        return imgView
    }()
    
    lazy var leftBottomImgView: UIImageView = {
        let imgView = UIFactoryGenerateImgView(imageName: "scan_left_bottom")
        return imgView
    }()
    
    lazy var rightBottomImgView: UIImageView = {
        let imgView = UIFactoryGenerateImgView(imageName: "scan_right_bottom")
        return imgView
    }()
    
    
    lazy var imageLine: UIImageView = {
        let imgView = UIFactoryGenerateImgView(imageName: "scan_move_line")
        return imgView
    }()
    
    func configUI() {
        
        let backItem = UIBarButtonItem.init(image: UIImage.init(named: "white_back_arrow"), style: .plain, target: self, action: #selector(cancleButtonPress))
        self.navigationItem.leftBarButtonItem = backItem
        
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height), cornerRadius: 0)
        let circlePath = UIBezierPath(roundedRect: CGRect(x: SCREEN_WIDTH / 2.0 - radius, y: 82, width: 2 * radius, height: 2 * radius), cornerRadius: 0)
        path.append(circlePath)
        path.usesEvenOddFillRule = true
        
        let fillLayer = CAShapeLayer()
        fillLayer.path = path.cgPath
        fillLayer.fillRule = kCAFillRuleEvenOdd
        fillLayer.fillColor = UIColor.black.cgColor
        fillLayer.opacity = 0.6
        view.layer.addSublayer(fillLayer)
        
        self.view.addSubview(tipsLab)
        tipsLab.snp.makeConstraints { (make) in
            make.height.equalTo(16)
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(38)
        }
        
        self.view.addSubview(leftTopImgView)
        leftTopImgView.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.top.equalTo(tipsLab.snp.bottom).offset(25 + 3)
            make.left.equalToSuperview().offset(SCREEN_WIDTH / 2.0 - radius)
        }
        
        self.view.addSubview(rightTopImgView)
        rightTopImgView.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.top.equalTo(leftTopImgView.snp.top)
            make.left.equalToSuperview().offset(SCREEN_WIDTH / 2.0 + radius - 20)
        }
        
        self.view.addSubview(leftBottomImgView)
        leftBottomImgView.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.left.equalTo(leftTopImgView.snp.left)
            make.top.equalTo(leftTopImgView.snp.top).offset(radius * 2 - 20)
        }
        
        self.view.addSubview(rightBottomImgView)
        rightBottomImgView.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.left.equalTo(rightTopImgView.snp.left)
            make.top.equalTo(leftBottomImgView.snp.top)
        }
        
        self.view.addSubview(lightUpBtn)
        lightUpBtn.snp.makeConstraints { (make) in
            make.width.equalTo(52)
            make.height.equalTo(56)
            make.centerX.equalToSuperview()
            make.top.equalTo(leftBottomImgView.snp.bottom).offset(42 * kDrawdownRatioH)
        }
        
        self.view.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.width.equalTo(127)
            make.height.equalTo(45)
            make.centerX.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20 * kDrawdownRatioH)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-20 * kDrawdownRatioH)
            }
        }
        
        self.view.addSubview(imageLine)
        imageLine.frame = CGRect.init(x: SCREEN_WIDTH / 2.0 - radius, y: 82, w: radius * 2, h: 3)
        self.addLineAnimation()
    }
}

//MARK: - NavBarTitleChangeable
extension EqualExchangeScanVC {
    var preferredTextAttributes: [NSAttributedStringKey : AnyObject] {
        let item = FunNavTitleTextAttributesItem(color: UIColor.white, font:nil)
        return getNavgationBarTitleTextAttributes(with: item)
    }
}
