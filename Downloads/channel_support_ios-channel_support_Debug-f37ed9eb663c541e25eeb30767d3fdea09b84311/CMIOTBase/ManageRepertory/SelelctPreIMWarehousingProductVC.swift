//
//  SelelctPreIMWarehousingProductVC.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/16.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import SVProgressHUD

class SelelctPreIMWarehousingProductVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var mainDataArr = [ProductGroupModel]()
    var subDataArr = [ProductModel]()
    var dataArr = [(ProductGroupModel,[ProductModel],[[GoodsModel]])]()
    var selectedIndex: Int = 0
    var subSelectedIndex: Int = -1
    var selUser: UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择产品"
        self.view.backgroundColor = RGB(247, g: 248, b: 251)
        self.configUI()
        self.fetchProductGroupList()
    }
    
    override func backToUpVC() {
        let resutl = self.addUpSelGoods()
        let addedGoods = resutl.0
        if addedGoods.count <= 0 {
            self.navigationController?.popViewController(animated: true)
            return
        }
        let alertController = UIAlertController(title: "确定返回？",
                                                message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确认", style: .default, handler: {
            action in
           self.navigationController?.popViewController(animated: true)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func updateProductTypeUI(infoModel:ProductGroupListModel?){
        if let info = infoModel {
            mainDataArr = info.list ?? []
        }
        for (_,groupInfo) in mainDataArr.enumerated() {
            dataArr.append((groupInfo,[ProductModel](),[[GoodsModel]]()))
        }
        if mainDataArr.count > 0 {
            self.fetchProductList()
        }
        mainTabView.reloadData()
    }
    
    func updateProductListUI(infoModel:ProductListModel?){
        if let info = infoModel {
            subDataArr = info.list ?? []
        }
        for (_) in subDataArr {
            dataArr[selectedIndex].2.append([GoodsModel]())
        }
        dataArr[selectedIndex].1 = subDataArr
        subTabView.reloadData()
    }
    
    //MARK: - function
    // 统计选择的产品
    func addUpSelGoods() -> ([GoodsModel],[(ProductModel,[GoodsModel])]) {
        var addedGoods = [GoodsModel]()
        var addedProducts = [(ProductModel,[GoodsModel])]()
        for item in dataArr {
            let productArr = item.1
            let googsArr = item.2
            for (index,goods) in googsArr.enumerated(){
                if goods.count > 0 {
                    addedGoods += goods
                    addedProducts.append((productArr[index],goods))
                }
            }
        }
        return (addedGoods,addedProducts)
    }
    
    @objc func lastStepClick(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func commitBtnClick(sender: UIButton) {
        let resutl = self.addUpSelGoods()
        let addedGoods = resutl.0
        let addedProducts = resutl.1
        if addedGoods.count > 0 {
            let detailVC = PreIMWarehousingDetailVC()
            detailVC.selUser = self.selUser
            detailVC.preAddedProducts = addedProducts
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        else{
            SVProgressHUD.showInfo(withStatus: "请先添加商品！")
        }
    }
    
    @objc func searchBtnClick(sender: UIButton) {
        let searchVC = ZSSearchPeopleViewController()
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    //MARK: - Network
    func fetchProductGroupList(){
        self.noNetwork = false
        ApiLoadingProvider.request(PAPI.queryPreProductGroupList(), model: ProductGroupListModel.self) { (result, resultInfo) in
            if let codeError = resultInfo.2 {
                self.noNetwork = codeError.code == 2
                self.updateProductTypeUI(infoModel: nil)
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                self.updateProductTypeUI(infoModel: result)
            }
        }
    }
    
    func fetchProductList(){
        self.noNetwork = false
         let group = dataArr[selectedIndex].0
        ApiLoadingProvider.request(PAPI.queryGroupProductList(groupId: group.id ?? 0), model: ProductListModel.self) { (result, resultInfo) in
            if let codeError = resultInfo.2 {
                self.noNetwork = codeError.code == 2
                self.updateProductListUI(infoModel: nil)
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                self.updateProductListUI(infoModel: result)
            }
        }
    }
    
    //MARK: - UI
    lazy var stepBgView: UIView = {
        let bgview = UIView()
        bgview.backgroundColor = UIColor.clear
        return bgview
    }()
    
    lazy var stepIndicatorView: StepIndicatorView = {
        let stepIndicatorView = UIFactoryGenerateStepIndicatorView()
        stepIndicatorView.stepMarks = ["选择员工","添加预出库产品"]
        stepIndicatorView.direction = .customCenter
        stepIndicatorView.numberOfSteps = 2
        stepIndicatorView.currentStep = 1
        stepIndicatorView.stepWith = 100.0
        stepIndicatorView.frame = CGRect(x: 15, y: 0, width: SCREEN_WIDTH - 15 - 15, height: 87)
        stepIndicatorView.backgroundColor = UIColor.clear
        return stepIndicatorView
    }()
    
    lazy var lastStepBtn: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 18, color: RGB(25, g: 81, b: 255), placeText: "上一步",imageName:"")
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(lastStepClick(sender:)), for: .touchUpInside)
        btn.backgroundColor = UIColor.white
        btn.setCornerRadius(radius: 6)
        btn.addBorder(width: 1, color: RGB(25, g: 81, b: 255))
        return btn
    }()
    
    lazy var commitBtn: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 18, color: RGB(255, g: 255, b: 255), placeText: "",imageName:"")
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(commitBtnClick(sender:)), for: .touchUpInside)
        btn.backgroundColor = RGB(25, g: 81, b: 255)
        btn.setCornerRadius(radius: 6)
        return btn
    }()
    
    lazy var countLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 15, color: UIColor.white, placeText: "数量 0")
        return lab
    }()
    
    lazy var preLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 18, color: UIColor.white, placeText: "预出库")
        lab.textAlignment = .right
        return lab
    }()
    
    lazy var mainTabView: UITableView = {
        let tabView = UITableView.init(frame: CGRect(), style: .plain)
        tabView.register(SelectProductGroupCell.classForCoder(), forCellReuseIdentifier: "selectProductTypeIdentifier")
        tabView.delegate = self
        tabView.dataSource = self
        tabView.separatorStyle = .none
        tabView.backgroundColor = RGB(247, g: 248, b: 251)
        return tabView
    }()
    lazy var subTabView: UITableView = {
        let tabView = UITableView.init(frame: CGRect(), style: .plain)
        tabView.register(SelectProductsCell.classForCoder(), forCellReuseIdentifier: "selectProductIdentifier")
        tabView.delegate = self
        tabView.dataSource = self
        tabView.separatorStyle = .none
        tabView.backgroundColor = UIColor.white
        return tabView
    }()
    
    func configUI() {
        self.view.addSubview(stepBgView)
        stepBgView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(87)
        }
//        stepBgView.addGradientLayerWithColors(bounds: CGRect.init(x: 0, y: 0, w: SCREEN_WIDTH, h: 87))
        stepBgView.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "step_pre_bg")!)
        stepBgView.addSubview(stepIndicatorView)
        
        view.addSubview(lastStepBtn)
        lastStepBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(110)
            make.height.equalTo(45)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-15)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-15)
            }
        }
        
        view.addSubview(commitBtn)
        commitBtn.snp.makeConstraints { (make) in
            make.left.equalTo(lastStepBtn.snp.right).offset(10)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(45)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-15)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-15)
            }
        }
//        commitBtn.addGradientLayerWithColors(bounds: CGRect.init(x: 0, y: 0, w: SCREEN_WIDTH - 30 - 110 - 10, h: 45))
        commitBtn.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "btn_bg")!)
        
        commitBtn.addSubview(preLab)
        preLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(25)
            make.right.equalToSuperview().offset(-26)
        }
        
        commitBtn.addSubview(countLab)
        countLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.height.equalTo(21)
            make.right.equalTo(preLab.snp.left).offset(-4)
        }
        
        view.addSubview(mainTabView)
        mainTabView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(87)
            make.width.equalTo(88)
            make.bottom.equalTo(commitBtn.snp.top).offset(-32)
        }
        
        view.addSubview(subTabView)
        subTabView.snp.makeConstraints { (make) in
            make.left.equalTo(mainTabView.snp.right)
            make.right.equalToSuperview()
            make.top.equalTo(mainTabView.snp.top)
            make.bottom.equalTo(mainTabView.snp.bottom)
        }
    }
}


// MARK: - UITableViewDelegate UITableViewDataSource
extension SelelctPreIMWarehousingProductVC {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == mainTabView {
            return dataArr.count
        }
        else if tableView == subTabView {
            if dataArr.count > 0 {
                return dataArr[selectedIndex].1.count
            }
            else{
                return 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == mainTabView {
            let mainCell = tableView.dequeueReusableCell(withIdentifier: "selectProductTypeIdentifier", for: indexPath) as! SelectProductGroupCell
            mainCell.selectionStyle = .none
            mainCell.groupNameLab.text = dataArr[indexPath.row].0.groupName ?? ""
            if indexPath.row == selectedIndex {
                mainCell.backgroundColor = RGB(255, g: 255, b: 255)
                mainCell.groupNameLab.textColor = RGB(25, g: 81, b: 255)
            }
            else{
                mainCell.groupNameLab.textColor = RGB(28, g: 28, b: 28)
                mainCell.backgroundColor = RGB(247, g: 248, b: 251)
            }
            return mainCell
        }
        else if tableView == subTabView {
            let subCell = tableView.dequeueReusableCell(withIdentifier: "selectProductIdentifier", for: indexPath) as! SelectProductsCell
            let addedGoods = dataArr[selectedIndex].2[indexPath.row]
            subCell.configGroupProductInfo(info:dataArr[selectedIndex].1[indexPath.row],count: addedGoods.count)
            subCell.selectionStyle = .none
            return subCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == mainTabView {
            let groupName = dataArr[indexPath.row].0.groupName ?? ""
            let calHeight = groupName.height(88 - 8, font: UIFont.systemFont(ofSize: 15), lineBreakMode: nil)
            let height = calHeight <= 21 ? 21 : calHeight
            return CGFloat(34 + height)
        }
        else if tableView == subTabView {
            return 77
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView.init()
        return headView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == mainTabView {
            if indexPath.row == selectedIndex {
                return
            }
            selectedIndex = indexPath.row
            subSelectedIndex = -1
            mainTabView.reloadData()
            let products = dataArr[selectedIndex].1
            if products.count > 0 {
                subTabView.reloadData()
            }
            else{
                self.fetchProductList()
            }
        }
        else if tableView == subTabView {
            let equalVC = EqualExchangeProductVC()
            let product = dataArr[selectedIndex].1[indexPath.row]
            let addedGoods = dataArr[selectedIndex].2[indexPath.row]
            equalVC.inputType = .preIMWarehousingInputType
            equalVC.selPreGoods = product
            equalVC.upPreAddedGoogs = addedGoods
            equalVC.preIndex = indexPath.row
            equalVC.preAddedCallback = { [unowned self] (index, addedGoods) in
                self.dataArr[self.selectedIndex].2[index] = addedGoods
                var count = 0
                for item in self.dataArr {
                    for goodsItem in item.2 {
                         count += goodsItem.count
                    }
                }
                self.countLab.text = "数量 " + String(count)
                self.subTabView.reloadData()
            }
            self.navigationController?.pushViewController(equalVC, animated: true)
        }
    }
}

