//
//  SetUpViewController.swift
//  CMIOTBase
//
//  Created by Apple on 2018/10/10.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import SVProgressHUD
class SetUpViewController: UIViewController {

    @IBOutlet weak var tabView: UITableView!
    @IBOutlet weak var okBt: UIButton!
    var dataArr:[OrderDetailProductModel] = []
    var complateArr:[OrderScanGoodsModel] = []
    var currentId:Int = 0 //生成订单id
    
    var totalComplate:Int = 0 //扫描量
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = kBackgroundColor
        self.title = "扫码安装"
//        okBt.addGradientLayerWithColors(bounds: CGRect.init(x: 0, y: 0, width: okBt.frame.width - 30, height: okBt.frame.height))
        
        loadData()
    }
    
    func loadData(){
        ApiLoadingProvider.request(PAPI.queryOrderDetail(id: currentId), model: OrderDetailModel.self) { (reslut, info) in
            if let codeError = info.2 {
                self.noNetwork = codeError.code == 2
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                self.dataArr = (reslut?.orderDetails)!
                self.tabView.reloadData()
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "GoIdentifyingViewController"){
            let vc:IdentifyingViewController = segue.destination as! IdentifyingViewController
            vc.currentId = self.currentId
        }
        
    }
    
    @IBAction func nextStep(_ sender: Any) {
        var arr:[Int] = []
        for model in self.complateArr{
            arr.append(model.id!)
        }
        ApiLoadingProvider.request(PAPI.modifyOrderDetail(orderId: self.currentId, goodsIds: arr), model: BaseModel.self) { (result, info) in
            if let codeError = info.2 {
                self.noNetwork = codeError.code == 2

                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
                
            }
            else{
                self.performSegue(withIdentifier: "GoIdentifyingViewController", sender: nil)
            }
        }
        
    }
    
    func searchGoods(barCode:String ,cell:SetUpTableViewCell){
        
        ApiLoadingProvider.request(PAPI.queryCurrentHolderOutedGoods(barCode: barCode), model: OrderScanGoodsModel.self) { (reslut, info) in
            if let codeError = info.2 {
                self.noNetwork = codeError.code == 2
                cell.flagImage.image = UIImage.init(named: "false")
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                if cell.productId == (reslut?.productId ?? -1) {
                    cell.flagImage.image = UIImage.init(named: "true")
                    self.complateArr.append(reslut!)
                }
                else{
                    cell.flagImage.image = UIImage.init(named: "false")
                    SVProgressHUD.showError(withStatus: "商品类别不匹配")
                }
            }
        }
    }
}


extension SetUpViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetUpTableViewCell" ) as! SetUpTableViewCell
        let subPath = dataArr[indexPath.row].picturePath!
        if subPath.length > 0 {
            let imageFullPath = subPath.creatProdcutFullUrlString(imageType: 1)
            cell.leftImage.setImageUrl(imageFullPath)
        }
        cell.nameLabel.text = dataArr[indexPath.row].productName!
        cell.productId = dataArr[indexPath.row].productId!
        
        cell.setUpGoBlock = { () -> () in
            let inputVC = EqualExchangeInputVC()
            inputVC.inputType = 0
            inputVC.selProduct = self.dataArr[indexPath.row]
            inputVC.inputCallback = { [unowned self] (contentStr,index) in
                cell.numTF.text = contentStr
                self.searchGoods(barCode: contentStr,cell: cell)
            }
            self.navigationController?.pushViewController(inputVC, animated: true)
//            self.searchGoods(barCode: cell.numTF.text!,cell: cell)
        }
        
        cell.setUpScanActionBlock = { () -> () in
            let scanVC = EqualExchangeScanVC()
            scanVC.inputCallback = { [unowned self] (contentStr,index) in
                cell.numTF.text = contentStr
                self.searchGoods(barCode: contentStr,cell: cell)
            }
            self.navigationController?.pushViewController(scanVC, animated: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        let leftLabel = UILabel()
        
        leftLabel.font = UIFont.systemFont(ofSize: 14)
        leftLabel.textColor = UIColor.colorWithHexString(hex: "#585858")
        leftLabel.text = "扫码安装产品"
        view.addSubview(leftLabel)
        
        let viewWidth = self.view.frame.width
        view.snp.makeConstraints { (make) in

            make.width.equalTo(viewWidth)
            make.height.equalTo(40)
        }
        
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            
            make.centerY.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

extension SetUpViewController:NavBarTitleChangeable{
    
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
    }
}
