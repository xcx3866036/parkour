//
//  PreIMWarehousingDetailVCViewController.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/16.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import SVProgressHUD

class PreIMWarehousingDetailVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var selUser: UserModel?
    var preAddedProducts = [(ProductModel,[GoodsModel])]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "预出库详情"
        view.backgroundColor = RGB(247, g: 248, b: 251)
        self.configUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - Function
    @objc func commitBtnClick(sender: UIButton) {
        self.createOutRecords()
    }
    
    //MARK: - Network
    func createOutRecords(){
        self.noNetwork = false
        var outRecords = [[String:Any]]()
        for item in preAddedProducts{
            let product = item.0
            let goods  = item.1
            var barCodes = [String]()
            for good in goods{
                barCodes.append(good.barCode ?? "")
            }
            let record = ["productId":product.id ?? 0,
                          "barCodes":barCodes] as [String : Any]
            outRecords.append(record)
        }
        ApiLoadingProvider.request(PAPI.createOutRecords(owerId: selUser?.id ?? 0, outRecords: outRecords), model: BaseModel.self) { (result, resultInfo) in
            if let codeError = resultInfo.2 {
                self.noNetwork = codeError.code == 2
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                SVProgressHUD.showSuccess(withStatus: resultInfo.1)
                NotificationCenter.default.post(name: Notification.Name(kUpdateManagerRepNotification), object: nil)
                let completeVC = PreProductsCompleteVC()
                self.navigationController?.pushViewController(completeVC, animated: true)
            }
        }
    }
    
    //MARK: - UI
    lazy var topBg: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "manager_pre_bg")
        imgView.isUserInteractionEnabled = true
        return imgView
    }()
    
    lazy var markImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "manager_pre_detail")
        return imgView
    }()
    
    
    lazy var countLab: UILabel = {
        let type = self.preAddedProducts.count
        var count = 0
        for item in self.preAddedProducts{
            count += item.1.count
        }
        
        let lab = UIFactoryGenerateLab(fontSize: 18, color: UIColor.white, placeText: "预出库合计 " + String(type) + " 类 共 " + String(count) + " 件")
        lab.font = UIFont.boldSystemFont(ofSize: 18)
        return lab
    }()
    
    lazy var userBgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var lastNameBtn: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 18, color: UIColor.white, placeText: "", imageName: "")
        btn.isUserInteractionEnabled = false
        let name = selUser?.employeeName ?? ""
        if name.length > 0 {
            btn.setTitle(String(name.last ?? " "), for: .normal)
        }
        btn.backgroundColor = RGB(249, g: 173, b: 9)
        btn.setCornerRadius(radius: 20)
        return btn
    }()
    
    
    lazy var nameLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 18, color: RGB(37, g: 37, b: 37), placeText: "")
        lab.text = selUser?.employeeName ?? ""
        return lab
    }()
    
    lazy var dateLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 12, color: RGB(37, g: 37, b: 37), placeText: "")
        lab.text = DateFormatter.yyyyMMddFormatter.string(from: Date())
        lab.textAlignment = .right
        return lab
    }()
    
    lazy var tabView: UITableView = {
        let tabView = UITableView.init(frame: CGRect(), style: .plain)
        tabView.register(PreProductsNOCell.classForCoder(), forCellReuseIdentifier: "PreProductsNOCellIdentifier")
        tabView.delegate = self
        tabView.dataSource = self
        tabView.separatorStyle = .none
        tabView.backgroundColor = RGB(247, g: 248, b: 251)
        tabView.tableFooterView = UIView.init()
        return tabView
    }()
    
    lazy var commitBtn: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 18, color: RGB(255, g: 255, b: 255), placeText: "",imageName:"")
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(commitBtnClick(sender:)), for: .touchUpInside)
        btn.backgroundColor = RGB(25, g: 81, b: 255)
        btn.setCornerRadius(radius: 6)
        btn.addAttTitle(mainTitle: "确定预出库", subTitle: "")
        return btn
    }()
    
    func configUI() {
        view.addSubview(topBg)
        topBg.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(125)
        }
        
        view.addSubview(commitBtn)
        commitBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(45)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-15)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-15)
            }
        }
//        commitBtn.addGradientLayerWithColors(bounds: CGRect.init(x: 0, y: 0, w: SCREEN_WIDTH - 30, h: 45))
        commitBtn.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "btn_bg")!)
        
        topBg.addSubview(markImgView)
        markImgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(36)
            make.height.width.equalTo(25)
        }
        
        topBg.addSubview(countLab)
        countLab.snp.makeConstraints { (make) in
            make.left.equalTo(markImgView.snp.right).offset(12)
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(36)
            make.height.equalTo(25)
        }
        
        view.addSubview(userBgView)
        userBgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(topBg.snp.bottom).offset(-35)
            make.height.equalTo(70)
        }
        
        userBgView.addSubview(lastNameBtn)
        lastNameBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.left.equalToSuperview().offset(11)
            make.centerY.equalToSuperview()
        }
//        lastNameBtn.addGradientLayerWithColors(colors: [RGB(25, g: 81, b: 255).cgColor,
//                                                        RGB(0, g: 234, b: 151).cgColor],
//                                               bounds: CGRect.init(x: 0, y: 0, w: 40, h: 40))
        
        userBgView.addSubview(dateLab)
        dateLab.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(17)
            make.centerY.equalToSuperview()
        }
        
        userBgView.addSubview(nameLab)
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(lastNameBtn.snp.right).offset(20)
            make.right.equalTo(dateLab.snp.left)
            make.height.equalTo(25)
            make.centerY.equalToSuperview()
        }
        
        
        view.addSubview(tabView)
        tabView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(userBgView.snp.bottom).offset(10)
            make.bottom.equalTo(commitBtn.snp.top).offset(-15)
        }
    }
}

// MARK: - UITableViewDelegate UITableViewDataSource
extension PreIMWarehousingDetailVC {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return preAddedProducts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return preAddedProducts[section].1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PreProductsNOCellIdentifier", for: indexPath) as! PreProductsNOCell
        let goods = preAddedProducts[indexPath.section].1[indexPath.row]
        cell.configPreGoodsInfo(info: goods)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return CGFloat(34 * preAddedProducts.count)
        return 34
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let prodcut = preAddedProducts[section].0
        let goodsCount = preAddedProducts[section].1.count
        let path = prodcut.picturePath ?? ""
        
        let headView = UIView.init(x: 0, y: 0, w: SCREEN_WIDTH, h: 68)
        headView.backgroundColor = UIColor.clear
        
        let lineView = UIView.init(x: 0, y: 67.5, w: SCREEN_WIDTH, h: 0.5)
        lineView.backgroundColor = RGB(216, g: 216, b: 216)
        headView.addSubview(lineView)
        
        let bgView = UIView.init(x: 0, y: 8, w: SCREEN_WIDTH, h: 60)
        bgView.backgroundColor = UIColor.white
        headView.addSubview(bgView)
        
        let imgView = UIFactoryGenerateImgView(imageName: "img_placeholder")
        imgView.setImageUrl(path.creatProdcutFullUrlString(imageType: 1), placeholder: UIImage.init(named: "img_placeholder"))
        imgView.frame = CGRect.init(x: 25, y: 7, w: 41, h: 41)
        bgView.addSubview(imgView)
        
        let countLab = UIFactoryGenerateLab(fontSize: 18, color: RGB(255, g: 75, b: 75), placeText: "×" + String(goodsCount))
        countLab.textAlignment = .right
        countLab.frame = CGRect.init(x: SCREEN_WIDTH - 40 - 26, y: 17, w: 40, h: 20)
        bgView.addSubview(countLab)
        
        let nameLab = UIFactoryGenerateLab(fontSize: 15, color: RGB(29, g: 29, b: 29), placeText: prodcut.productName ?? "")
        nameLab.frame = CGRect.init(x: imgView.right + 10, y: 17, w: SCREEN_WIDTH - imgView.right - 10 - 40 - 26 , h: 21)
        bgView.addSubview(nameLab)
        
        return headView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
}

// MARK: - UIScrollViewDelegate
extension PreIMWarehousingDetailVC {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let sectionHeaderHeight: CGFloat = 68
        if scrollView.contentOffset.y >= 0 &&  scrollView.contentOffset.y <= sectionHeaderHeight{
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0)
        }
        else if scrollView.contentOffset.y > sectionHeaderHeight{
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0)
        }
    }
}
