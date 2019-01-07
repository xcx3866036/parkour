//
//  APPShareWebVC.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/11/20.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import SVProgressHUD
import WebKit

class APPShareWebVC: UIViewController,NavBarTitleChangeable,WKNavigationDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "分享APP"
        self.view.backgroundColor = kBackgroundColor
        self.configUI()
        self.loadShareUrl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let delegate = appDelegate {
            delegate.changeNavigationBarDefaultInVC(rootVC: self)
        }
    }
    
    //MARK: - Function
    func loadShareUrl(){
        SVProgressHUD.show()
        let shareUrl = URL.init(string: "https://www.baidu.com")
        let shareRequest = URLRequest.init(url: shareUrl!)
        shareWebView.load(shareRequest)
    }
    
    //MARK: - UI
    lazy var shareWebView: WKWebView = {
        let view = WKWebView()
        view.navigationDelegate = self
        return view
    }()
    
    lazy var shareBtn: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 18, color: RGB(255, g: 255, b: 255), placeText: "分  享",imageName:"")
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(shareBtnClick(sender:)), for: .touchUpInside)
        btn.backgroundColor = RGB(255, g: 255, b: 255)
        btn.setCornerRadius(radius: 6)
        return btn
    }()
    
    func configUI() {
        self.view.addSubview(shareBtn)
        shareBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(45)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-8)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-8)
            }
        }
        shareBtn.addGradientLayerWithColors(bounds: CGRect.init(x: 0, y: 0, w: SCREEN_WIDTH - 30, h: 45))
        
        self.view.addSubview(shareWebView)
        shareWebView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(shareBtn.snp.top).offset(-10)
        }
    }
    
    @objc func shareBtnClick(sender: UIButton) {
        UMSocialUIManager.showShareMenuViewInWindow { (platformType, info) in
            let shareImg = UIImage.init(named: "yihezuo_qrcode")
            let shareObject = UMShareObject.shareObject(withTitle: "title", descr: "descr", thumImage: shareImg)
            let shareMessage = UMSocialMessageObject.init(mediaObject: shareObject)
            UMSocialManager.default()?.share(to: platformType, messageObject: shareMessage, currentViewController: self, completion: { (result, shareError) in
                if let error = shareError {
                    print("Share Error:\(error.localizedDescription)")
                }
                else{
                    print("Share Success:\(String(describing: result))")
                }
            })
        }
    }
}

//MARK: - NavBarTitleChangeable
extension APPShareWebVC {
    var preferredTextAttributes: [NSAttributedStringKey : AnyObject] {
        let item = FunNavTitleTextAttributesItem(color: UIColor.black, font:nil)
        return getNavgationBarTitleTextAttributes(with: item)
    }
}

//MARK: - WKNavigationDelegate
extension APPShareWebVC{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error){
        SVProgressHUD.showError(withStatus: error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        SVProgressHUD.showError(withStatus: error.localizedDescription)
    }
}
