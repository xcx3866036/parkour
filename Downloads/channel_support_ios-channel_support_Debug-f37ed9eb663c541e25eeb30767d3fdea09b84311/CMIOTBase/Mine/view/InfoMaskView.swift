//
//  InfoMaskView.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/12/18.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import WebKit

class InfoMaskView: UIView {

    lazy var imgView:UIImageView = {
        let imgView = UIFactoryGenerateImgView(imageName: "yihezuo_qrcode")
        return imgView
    }()
    
    lazy var webView: WKWebView = {
        let view = WKWebView()
        let filePath = Bundle.main.path(forResource: "yihezuo", ofType: "html")!
        let fileUrl = URL.init(fileURLWithPath: filePath)
        let request = URLRequest.init(url: fileUrl)
        view.load(request)
        return view
    }()
    
    lazy var sepLine: UIView = {
        let line = UIView()
        line.backgroundColor = RGB(216, g: 216, b: 216)
        return line
    }()
    
    lazy var commitBtn: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 18, color: RGB(39, g: 110, b: 255), placeText: "确定", imageName: "")
        btn.backgroundColor = UIColor.clear
        btn.setCornerRadius(radius: 4)
        btn.addBorder(width: 1, color: RGB(216, g: 216, b: 216))
        btn.addTarget(self, action: #selector(commitBtnClick), for: .touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configShareSubViews() {
        self.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.2)
        self.addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.width.equalTo(200)
        }
        self.addTapGesture { (tapGesture) in
            self.removeFromSuperview()
        }
    }
    
    func configProtocolSubView(){
        self.backgroundColor = UIColor.white
        self.addSubview(commitBtn)
        commitBtn.snp.makeConstraints { (make) in
            make.width.equalTo(65)
            make.height.equalTo(35)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-45)
        }
        
        self.addSubview(sepLine)
        sepLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalTo(commitBtn.snp.top).offset(-10)
        }
        self.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(30)
            make.bottom.equalTo(sepLine.snp.top).offset(-2)
        }
    }
    
    @objc func commitBtnClick(){
        self.removeFromSuperview()
    }
}
