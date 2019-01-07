//
//  ShowResultViewController.swift
//  CMIOTBase
//
//  Created by Apple on 2018/10/10.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class ShowResultViewController: UIViewController {

    @IBOutlet weak var scanimage: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    var currentId:Int = 0 //生成订单id
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "购买人信息"
        view.backgroundColor = kBackgroundColor
        detailLabel.textColor = UIColor.colorWithHexString(hex: "#AAAAAA")
        detailLabel.text = "下单成功后,请工作人员\n扫码安装设备"
        scanimage.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(scanProduct))
        self.scanimage.addGestureRecognizer(gesture)
    }
    @objc func scanProduct(){
        self.performSegue(withIdentifier: "GoSetUpViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "GoSetUpViewController"){
            let vc:SetUpViewController = segue.destination as! SetUpViewController
            vc.currentId = self.currentId
        }
        
    }

    
    
}

extension ShowResultViewController:NavBarTitleChangeable{
    
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
        let orderVC = OrderManagerVC()
        orderVC.tag = "1"
        self.navigationController?.pushViewController(orderVC, animated: true)
        //self.popToRootVC()
    }
}
