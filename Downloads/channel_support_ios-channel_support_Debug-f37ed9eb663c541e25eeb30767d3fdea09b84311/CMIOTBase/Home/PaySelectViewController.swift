//
//  PaySelectViewController.swift
//  CMIOTBase
//
//  Created by Apple on 2018/10/11.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import SVProgressHUD
class PaySelectViewController: UIViewController {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var zfbBt: UIView!
    @IBOutlet weak var weixinBt: UIView!
    @IBOutlet weak var payView: UIView!
    var currentId:Int = 0 //生成订单id
    var select:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.payView.contentMode = .scaleToFill
        self.payView.layer.contents = UIImage.init(named: "line")?.cgImage
        view.backgroundColor = kBackgroundColor
        self.title = "收款"
        loadData()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(zfbPay))
        self.zfbBt.isUserInteractionEnabled = true
        self.zfbBt.layer.borderWidth = 1
        self.zfbBt.layer.borderColor = UIColor.lightGray.cgColor
        self.zfbBt.addGestureRecognizer(gesture)
        
        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(weixinPay))
        self.weixinBt.isUserInteractionEnabled = true
        self.weixinBt.layer.borderWidth = 1
        self.weixinBt.layer.borderColor = UIColor.lightGray.cgColor
        self.weixinBt.addGestureRecognizer(gesture1)

    }
    
    func loadData(){
        ApiLoadingProvider.request(PAPI.queryOrderDetail(id: currentId), model: OrderDetailModel.self) { (reslut, info) in
            if let codeError = info.2 {
                self.noNetwork = codeError.code == 2
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                self.priceLabel.text = String(format: "￥%.2f", (reslut?.amount)!)
                
            }
        }
    }
    

    
    @objc func weixinPay(){
        self.select = "1"
        self.performSegue(withIdentifier: "GoScanViewController", sender: nil)
        
    }
    
    @objc func zfbPay(){
        self.select = "2"
        self.performSegue(withIdentifier: "GoScanViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "GoScanViewController"){
            let vc:ScanViewController = segue.destination as! ScanViewController
            vc.currentId = self.currentId
            vc.flag = self.select
        }
        
    }
    
}

extension PaySelectViewController:NavBarTitleChangeable{
    
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
       // self.popToRootVC()
    }
}
