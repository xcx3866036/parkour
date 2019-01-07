//
//  CommissionDetailViewController.swift
//  CMIOTBase
//
//  Created by Apple on 2018/10/15.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import SVProgressHUD
class CommissionDetailViewController: UIViewController {

    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var shapeImage: UIImageView!
    @IBOutlet weak var topBg: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var detailTable: UITableView!
    var flag:String = "0"
    var typePrice:Double =  0.00
    var model:CommissionMonthModel?
    
    var dataArr:[CommissionModelDetails] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "月份佣金详情"
        self.view.backgroundColor = UIColor.colorWithHexString(hex: "#F7F8FB")
        detailTable.backgroundColor = UIColor.clear
        
        //设置背景图片(如果图片太小，会自动平铺)
        topBg.backgroundColor = UIColor.init(patternImage: UIImage(named: "commissionTopBG")!)
        
        let dateformatter = DateFormatter()
        
        dateformatter.dateFormat = "YYYY"
        
        let time = dateformatter.string(from: Date())
        self.year.text = time
        if(flag != "0"){
            let calendar: Calendar = Calendar(identifier: .gregorian)
            var comps: DateComponents = DateComponents()
            comps = calendar.dateComponents([.month], from: Date())
            self.month.text = String(format: "%d/", comps.month!)
        }else{
            self.month.text = String(format: "%@/", model!.settlementMonth)
        }
        
        if(self.flag == "0"){
            self.priceLabel.text = String(format: "%.2f", model!.commissionIncome!)
        }else{
            self.priceLabel.text = String(format: "%.2f", typePrice)
        }
        
        self.shapeImage.isHidden = false
        self.year.isHidden = false
        self.detailLabel.isHidden = false
        if(flag == "2"){
            self.title = "结算中"
            self.month.text = "结算中"
            self.year.isHidden = true
            self.shapeImage.isHidden = true
            self.detailLabel.isHidden = true
        }
        
        loadData()
        
    }
    
    func loadData(){
        if(self.flag == "0"){
            let date = String(format: "%@-%@", self.year.text!,model!.settlementMonth)
            print("\(date)")
            ApiLoadingProvider.request(PAPI.queryCommissionDetails(date: date), model: CommissionModelDetailsList.self) { (result, info) in
                if let codeError = info.2 {
                    self.noNetwork = codeError.code == 2
                    SVProgressHUD.showError(withStatus: codeError.localizedDescription)
                }
                else{
                    self.dataArr = (result?.list)!
                    self.detailTable.reloadData()
                }
            }
        }else if(self.flag == "2"){
            ApiLoadingProvider.request(PAPI.querySettletingCommissionDetails(), model: CommissionModelDetailsList.self) { (result, info) in
                if let codeError = info.2 {
                    self.noNetwork = codeError.code == 2
                    SVProgressHUD.showError(withStatus: codeError.localizedDescription)
                }
                else{
                    self.dataArr = (result?.list)!
                    self.detailTable.reloadData()
                }
            }
        }else{
            ApiLoadingProvider.request(PAPI.queryMonthSettletedCommissionDetails(), model: CommissionModelDetailsList.self) { (result, info) in
                if let codeError = info.2 {
                    self.noNetwork = codeError.code == 2
                    SVProgressHUD.showError(withStatus: codeError.localizedDescription)
                }
                else{
                    self.dataArr = (result?.list)!
                    self.detailTable.reloadData()
                }
            }
        }

    }


}

extension CommissionDetailViewController:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view:UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, w: self.view.frame.width, h: 16))
        view.backgroundColor = UIColor.clear
        
        let line:UIView = UIView.init(frame: CGRect.init(x: 20, y: 16, w: self.view.frame.width, h: 1))
        
        line.backgroundColor = UIColor.colorWithHexString(hex: "#D8D8D8")
        view.addSubview(line)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommissionDetailTableViewCell" ) as! CommissionDetailTableViewCell
        cell.orderlLabel.text = String(format: "订单:%@", dataArr[indexPath.row].orderNo)
        cell.moneylabel.text = String(format: "+%.2f", dataArr[indexPath.row].commission!)
        cell.dateLabel.text = dataArr[indexPath.row].settlementDay
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

extension CommissionDetailViewController:NavBarTitleChangeable{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        appDelegate!.changeNavigationBarDefaultInVC(rootVC: self)
        
    }
    
    var preferredTextAttributes: [NSAttributedStringKey : AnyObject] {
        let item = FunNavTitleTextAttributesItem(color: UIColor.black, font:nil)
        return getNavgationBarTitleTextAttributes(with: item)
    }
    
    
}
