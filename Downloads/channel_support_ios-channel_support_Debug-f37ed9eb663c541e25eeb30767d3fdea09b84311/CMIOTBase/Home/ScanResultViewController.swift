//
//  ScanResultViewController.swift
//  CMIOTBase
//
//  Created by Apple on 2018/10/11.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class ScanResultViewController: UIViewController {

    @IBOutlet weak var backBt: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = kBackgroundColor
        backBt.layer.masksToBounds = true
        backBt.layer.borderWidth = 1
        backBt.layer.borderColor = UIColor.colorWithHexString(hex: "#1951FF").cgColor
        backBt.layer.cornerRadius = 5
        self.title = "收款成功"
    }
    @IBAction func goBack(_ sender: Any) {
        self.popToRootVC()
    }
}

extension ScanResultViewController:NavBarTitleChangeable{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        appDelegate!.changeNavigationBarDefaultInVC(rootVC: self)
        
    }
    
    var preferredTextAttributes: [NSAttributedStringKey : AnyObject] {
        let item = FunNavTitleTextAttributesItem(color: UIColor.black, font:nil)
        return getNavgationBarTitleTextAttributes(with: item)
    }
    
    override func backToUpVC() {
//        let orderVC = OrderManagerVC()
//        orderVC.tag = "1"
//        self.navigationController?.pushViewController(orderVC, animated: true)
        self.popToRootVC()
    }
}
