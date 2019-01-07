//
//  ChooseChangedProductVC.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/16.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class ChooseChangedProductVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var sumCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择换货商品"
        view.backgroundColor = RGB(247, g: 248, b: 251)
        self.configUI()
        self.updateUI()
    }
    
    func updateUI() {
        
        let singleAttribute3 = [ NSAttributedStringKey.foregroundColor: RGB(38, g: 38, b: 38)]
        let singleAttribute4 = [ NSAttributedStringKey.foregroundColor: RGB(255, g: 79, b: 0)]
        
        let countAttStr = NSMutableAttributedString.init(string: "数量：", attributes: singleAttribute3)
        let subCountAttStr = NSAttributedString.init(string: String(sumCount), attributes: singleAttribute4)
        
        countAttStr.append(subCountAttStr)
        countLab.attributedText = countAttStr
    }
    
    //MARK: - Function
    @objc func commitBtnClick(sender: UIButton) {
        let commitVC = CommitAddRemarkVC()
        commitVC.operateType = .applyForExchangingGoods
        self.navigationController?.pushViewController(commitVC, animated: true)
    }
    
    // MARK: - UI
    lazy var tabView: UITableView = {
        let tabView = UITableView.init(frame: CGRect(), style: .plain)
        tabView.register(ChangedProductsCell.classForCoder(), forCellReuseIdentifier: "chooseChangedProductIdentifier")
        tabView.delegate = self
        tabView.dataSource = self
        tabView.separatorStyle = .none
        tabView.backgroundColor = .clear
        tabView.tableFooterView = UIView.init()
        return tabView
    }()
    
    
    lazy var commitBtn: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 18, color: RGB(255, g: 255, b: 255), placeText: "确认换货",imageName:"")
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(commitBtnClick(sender:)), for: .touchUpInside)
        btn.backgroundColor = RGB(255, g: 255, b: 255)
        return btn
    }()
    
    lazy var countBgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        return bgView
    }()
    
    lazy var countLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 15, color: RGB(38, g: 38, b: 38), placeText: "")
        return lab
    }()
    
    func configUI() {
        self.view.addSubview(commitBtn)
        commitBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(226)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top)
            }
        }
//        commitBtn.addGradientLayerWithColors(bounds: CGRect.init(x: 0, y: 0, w: 226, h: 50))
        commitBtn.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "btn_bg")!)
        
        self.view.addSubview(countBgView)
        countBgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalTo(50)
            make.right.equalTo(commitBtn.snp.left)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top)
            }
        }
        
        countBgView.addSubview(countLab)
        countLab.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.height.equalTo(50)
            make.left.equalToSuperview().offset(19)
        }
        
        self.view.addSubview(tabView)
        tabView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.bottom.equalTo(commitBtn.snp.top).offset(-22)
        }
    }
}

// MARK: - UITableViewDelegate UITableViewDataSource
extension ChooseChangedProductVC {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chooseChangedProductIdentifier", for: indexPath) as! ChangedProductsCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.index = indexPath.row
        cell.cellClickBlock = { [unowned self] (index,value) in
            print("index:\(index) value:\(value)")
            let valueCount = value
            self.sumCount += valueCount
            self.updateUI()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView.init()
        return headView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let productVC = ChooseChangedProductVC()
            self.navigationController?.pushViewController(productVC, animated: true)
        }
    }
}
