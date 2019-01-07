//
//  AppDelegate.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/9/18.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import EAIntroView
import SwiftyUserDefaults
import IQKeyboardManagerSwift
import SVProgressHUD
import Bugly
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var alamoFileManager:SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10 // seconds
        let manager = Alamofire.SessionManager(configuration: configuration)
        return manager
    }()
    
    let documentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.endIndex - 1]
    }()
    
    let cacheDirectory: URL = {
        let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return urls[urls.endIndex - 1]
    }()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIViewController.initializeMethod()
        SVProgressHUD.setMinimumDismissTimeInterval(2)
        SVProgressHUD.setDefaultMaskType(.clear)
        IQKeyboardManager.shared.enable = true
        let buglyAppId = "943c651a50"
        Bugly.start(withAppId: buglyAppId)
        let _ = log
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        if version != Defaults[.lastAppVersion] {
            Defaults[.lastAppVersion] = version
            self.showGuide()
        }
        // 配置分享
        UMConfigure.initWithAppkey("5c107fb1b465f55cc40000b1", channel: "App Store")
        UMSocialGlobal.shareInstance()?.isUsingWaterMark = true
        UMSocialGlobal.shareInstance()?.isUsingHttpsWhenShareContent = false
        let platForm = UMSocialPlatformType(rawValue: 1001) ?? UMSocialPlatformType.userDefine_Begin
        UMSocialUIManager.addCustomPlatformWithoutFilted( platForm,
                                                          withPlatformIcon: UIImage.init(named: "share_download"),
                                                          withPlatformName: "下载图片")
        UMSocialShareUIConfig.shareInstance()?.sharePageGroupViewConfig.sharePageGroupViewPostionType = .bottom
        UMSocialShareUIConfig.shareInstance()?.sharePageScrollViewConfig.shareScrollViewPageItemStyleType = .none
        
        
        // 设置微信的appKey和appSecret
        UMSocialManager.default()?.setPlaform(UMSocialPlatformType.wechatTimeLine,
                                              appKey: "wxf175a159cf689b33",
                                              appSecret: "03bb15ce45e7bba55ad12c112f3400c7",
                                              redirectURL: "http://mobile.umeng.com/social")
        
        UMSocialManager.default()?.removePlatformProvider(with: UMSocialPlatformType.wechatFavorite)
        
        let homeVC = ChannelsHomeVC.init()
        let naviVC = FunNavigationViewController.init(rootViewController: homeVC)
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = naviVC
        self.configNavigationBarInVC(rootVC: homeVC)
        
        self.checkVersionAction()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
         self.checkVersionAction()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        let result = UMSocialManager.default()?.handleOpen(url) ?? false
        /*
         if result == false {
            // 其他如支付等SDK的回调
         }
         */
        return result
    }
}

// MARK : - IntroPage
extension AppDelegate {
    func showGuide(){
        let page1 = EAIntroPage.init()
        page1.titleIconView = UIImageView.init(image: #imageLiteral(resourceName: "guide_one"))
        page1.titleIconPositionY = 0
        page1.titleIconView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        let page2 = EAIntroPage.init()
        page2.titleIconView = UIImageView.init(image: #imageLiteral(resourceName: "guide_two"))
        page2.titleIconPositionY = 0
        page2.titleIconView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        let page3 = EAIntroPage.init()
        page3.titleIconView = UIImageView.init(image: #imageLiteral(resourceName: "guide_three"))
        page3.titleIconPositionY = 0
        page3.titleIconView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        
        let pageView = EAIntroView.init(frame: (self.window?.bounds)!, andPages: [page1,page2,page3])
        pageView?.showSkipButtonOnlyOnLastPage = true
        pageView?.skipButton.setImage(#imageLiteral(resourceName: "guide_button"), for: .normal)
        pageView?.skipButton.setTitle("", for: .normal)
        pageView?.skipButton.bounds = CGRect.init(x: 0, y: 0, width: 144, height: 47)
        pageView?.useMotionEffects = false
        pageView?.skipButtonAlignment = .center
        pageView?.skipButtonY = 85
        pageView?.pageControlY = 42
        pageView?.scrollView.bounces = false
        pageView?.show(in: self.window)
    }
    
    func configNavigationBarInVC(rootVC: UIViewController) {
        rootVC.navigationController?.navigationBar.isTranslucent = true
        rootVC.navigationController?.navigationBar.setBackgroundImage(UIImage.init(), for: .default)
        rootVC.navigationController?.navigationBar.shadowImage = UIImage.init()
        rootVC.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    func configAppearance() {
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.white
        ]
    }
    
    // 黑色statusbar 白色背景NavigationBar 黑色tint
    func changeNavigationBarDefaultInVC(rootVC: UIViewController) {
         UIApplication.shared.statusBarStyle = .default
        rootVC.navigationController?.navigationBar.isTranslucent = false
    rootVC.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color: UIColor.white), for: .default)
        rootVC.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color: UIColor.white)
        rootVC.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    func changeNavigationBarSperateInVC(rootVC: UIViewController) {
        UIApplication.shared.statusBarStyle = .default
        rootVC.navigationController?.navigationBar.isTranslucent = false
        rootVC.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color: UIColor.white), for: .default)
        rootVC.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color: UIColor.lightGray)
        rootVC.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    // 白色statusbar 透明背景NavigationBar 白色tint
    func changeNavigationBarLightContentInVC(rootVC: UIViewController) {
        UIApplication.shared.statusBarStyle = .lightContent
        rootVC.navigationController?.navigationBar.isTranslucent = true
        rootVC.navigationController?.navigationBar.setBackgroundImage(UIImage.init(), for: .default)
        rootVC.navigationController?.navigationBar.shadowImage = UIImage.init()
        rootVC.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    // 白色statusbar 黑色背景NavigationBar 白色tint
    func changeBlackNavigationBarLightContentInVC(rootVC: UIViewController) {
        UIApplication.shared.statusBarStyle = .lightContent
        rootVC.navigationController?.navigationBar.isTranslucent = false
        rootVC.navigationController?.navigationBar.setBackgroundImage(UIImage.init(named: "scan_navibar_bg"), for: .default)
        rootVC.navigationController?.navigationBar.shadowImage = UIImage.init()
        rootVC.navigationController?.navigationBar.tintColor = UIColor.white
        
    }
}

// 版本更新
extension AppDelegate {
    func checkVersionAction(){
        let url = "http://api.fir.im/apps/latest/5be4001b548b7a225437169c?api_token=1aa6d5d7c88fd169402fb7966f97f919"
        alamoFileManager.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            if response.result.isSuccess {
                if let json = response.result.value{
                    let dic = json as! NSDictionary
                    print(dic)
                    let versionShort = dic["versionShort"] as! String
                    let currentVersion =  Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
                  
                    // 本地版本低于fir.im最新版本才更新
                    if String.compareVersion(localVersion: currentVersion, latestVersion: versionShort){
                        
                        let versinStr = "发现新版本V" + versionShort
                        let versionInfo = dic["changelog"] as! String
                        let alertController = UIAlertController(title: versinStr, message: versionInfo, preferredStyle: .alert)
                        let OKAction = UIAlertAction.init(title: "立即更新", style: .destructive) { (action) in
                            let updateUrl = dic["update_url"] as! String
                            UIApplication.shared.openURL(URL.init(string: updateUrl)!)
                        }
                        let cancelAction = UIAlertAction.init(title: "暂不更新", style: .cancel, handler: nil)
                        alertController.addAction(cancelAction)
                        alertController.addAction(OKAction)
                        UIApplication.shared.keyWindow?.rootViewController?.presentVC(alertController)
                    }
                }
            }
            else {
                print("firm请求失败\(String(describing: response.error?.localizedDescription))")
            }
        }
    }
}

