//
//  GeneralDefine.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/9/18.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import Foundation
import DeviceKit

// FIXME:根据需求修改路径

//let CHBaseUrl = "http://117.139.13.231:19004/app/"     // 外网-成都-已停止服务

//let CHBaseUrl = "http://183.230.40.32:19004/app/"      // 外网-重庆
let CHBaseUrl = "http://117.139.13.231:29004/app/"     // 外网-测试
//let CHBaseUrl = "http://172.16.5.40:9004/app/"         // 内网-测试

//let CHVideoUrl = "http://172.16.5.40:9004"         // 内网-视屏地址
let CHVideoUrl = "http://117.139.13.231:29004"     // 外网-测试
//let CHVideoUrl = "http://183.230.40.32:19004"      // 外网-重庆



//以6的比例设置
let kRatioToIP6H = (SCREEN_HEIGHT == 812.0 ? 667.0/667.0 : SCREEN_HEIGHT/667.0)
let kRatioToIP6W = SCREEN_WIDTH/375
let kNormalIP6H = SCREEN_HEIGHT/667

let kDrawdownRatioW = kRatioToIP6W <= 1 ? kRatioToIP6W : 1
let kDrawdownRatioH = kNormalIP6H <= 1 ? kNormalIP6H : 1

//nav高度
let kStatusBarH = UIApplication.shared.statusBarFrame.size.height
let kNavigationBarH : CGFloat =  kStatusBarH + 44

let userInfoPath = "\(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.userDomainMask,true).first!)/userInfoPath.data"

let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let ONE_PX = 1.0/UIScreen.main.scale
let kPageSize: Int = 20

// 版本信息
let infoDic = Bundle.main.infoDictionary
let appVersion = infoDic?["CFBundleShortVersionString"] // 获取App的版本
let appBuildVersion = infoDic?["CFBundleVersion"] // 获取App的build版本
let appName = infoDic?["CFBundleDisplayName"] // 获取App的名称

// 设备信息
let deviceName = UIDevice.current.name  //获取设备名称 例如：**的手机
let sysName = UIDevice.current.systemName //获取系统名称 例如：iPhone OS
let sysVersion = UIDevice.current.systemVersion //获取系统版本 例如：9.2
let deviceUUID = UIDevice.current.identifierForVendor?.uuidString  //获取设备唯一标识符 例如：FBF2306E-A0D8-4F4B-BDED-9333B627D3E6
let deviceModel = UIDevice.current.model //获取设备的型号 例如：iPhone






