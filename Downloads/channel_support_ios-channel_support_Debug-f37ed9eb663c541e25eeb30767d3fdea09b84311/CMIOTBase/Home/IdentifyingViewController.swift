//
//  IdentifyingViewController.swift
//  CMIOTBase
//
//  Created by Apple on 2018/10/10.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import SVProgressHUD
class IdentifyingViewController: UIViewController {

    @IBOutlet weak var tryView: UIView!

    @IBOutlet weak var singleView: UIView!
    var identifyView: JYCodeTextView2!
    @IBOutlet weak var phoneLabel: UILabel!

    @IBOutlet weak var okBt: UIButton!
    var countDown:TCCountDown!
    var currentId:Int = 0 //生成订单id
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = kBackgroundColor
        self.title = "扫码安装"
        
        let tryButton :UIButton
        
        countDown = TCCountDown()
        countDown.isCounting = false
        countDown.type = 1
        tryButton = countDown.codeBtn
        tryButton.layer.cornerRadius = 2
        tryButton.layer.masksToBounds = true
        tryButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        tryButton.setTitle("重新发送", for: .normal)
        tryButton.addTarget(self, action: #selector(getCheckMessage), for: UIControlEvents.touchUpInside)
        tryButton.contentMode = .center
        tryButton.contentHorizontalAlignment = .left
        self.tryView.addSubview(tryButton)
        
        tryButton.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        loadOrderData()
        
        identifyView = JYCodeTextView2(count: 6, margin: 10)
        singleView.addSubview(identifyView)
        
        identifyView.snp.makeConstraints { (make) in
           make.top.bottom.left.right.equalToSuperview()
        }
    }


    // MARK:network methods
    @objc func getCheckMessage() {

        ApiLoadingProvider.request(PAPI.sendMsgCode(orderId: self.currentId), model: BaseModel.self) { (result, resultInfo) in
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "GoPaySelectViewController"){
            let vc:PaySelectViewController = segue.destination as! PaySelectViewController
            vc.currentId = self.currentId
        }
        
    }

    
    func loadOrderData(){
        ApiLoadingProvider.request(PAPI.queryOrderDetail(id: currentId), model: OrderDetailModel.self) { (reslut, info) in
            if let codeError = info.2 {
                self.noNetwork = codeError.code == 2
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                self.phoneLabel.text = reslut!.customerCellphone
                
            }
        }
    }
    
    
    @IBAction func nextStep(_ sender: Any) {
        
        if(identifyView.textField.text!.count < 6){
            SVProgressHUD.showError(withStatus: "验证码输入不正确")
            return
        }
        
        ApiLoadingProvider.request(PAPI.checkMsgCode(orderId: self.currentId, msgCode: identifyView.textField.text!), model: BaseModel.self) { (result, resultInfo) in
            if let codeError = resultInfo.2 {
                self.noNetwork = codeError.code == 2
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                SVProgressHUD.showSuccess(withStatus: resultInfo.1)
                self.performSegue(withIdentifier: "GoPaySelectViewController", sender: nil)
            }
        }
    
    }

}


extension IdentifyingViewController:NavBarTitleChangeable{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
//        okBt.addGradientLayerWithColors(bounds: CGRect.init(x: 0, y: 0, width: okBt.frame.width - 30, height: okBt.frame.height))
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
