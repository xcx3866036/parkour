//
//  RepProductDetailVC.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/9.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import SVProgressHUD

class RepProductDetailVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var infoModel: ProductCommissionDetailsModel?
    var dialogues = [DialogueModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = (infoModel?.productName ?? "") + "详情"
        view.backgroundColor = RGB(247, g: 248, b: 251)
    
        self.configUI()
        self.updateUI()
        self.fetchProductCommissionDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        UIApplication.shared.statusBarStyle = .default
        super.viewWillDisappear(animated)
    }
    
    func updateUI(){
        let fullPath = (infoModel?.picturePath ?? "").creatProdcutFullUrlString(imageType: 0)
        self.topImgView.setImageUrl(fullPath, placeholder: UIImage.init(named: "img_placeholder"))
        self.nameLab.text = infoModel?.productName ?? ""
        
        let priceStr = String.init(format: "%.2f", infoModel?.salePrice ?? 0.0)
        let commissionStr = String.init(format: "%.2f", infoModel?.commission?.commission ?? 0.0)
         let commissionratio = (infoModel?.commission?.ratio ?? 0.0) * 100
        
        self.priceLab.text = "￥" + priceStr
        let commission = "佣金"
        let priceFullStr = "￥" + commissionStr + "  "
        let commissionRate = "佣金率 " + String(commissionratio) + "%"
        
        let singleAttribute1 = [NSAttributedStringKey.foregroundColor: RGB(35, g: 35, b: 35),
                                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)]
        let singleAttribute2 = [NSAttributedStringKey.foregroundColor: RGB(255, g: 75, b: 75),
                                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)]
        let singleAttribute3 = [NSAttributedStringKey.foregroundColor: RGB(35, g: 35, b: 35),
                                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)]
        
        let commissionFullStr = NSMutableAttributedString.init(string: commission, attributes: singleAttribute1)
        let subcommissionStr2 = NSAttributedString.init(string: String(priceFullStr), attributes: singleAttribute2)
        let subcommissionStr3 = NSAttributedString.init(string: String(commissionRate), attributes: singleAttribute3)
        commissionFullStr.append(subcommissionStr2)
        commissionFullStr.append(subcommissionStr3)
        self.commissionLab.attributedText = commissionFullStr
    }
    
    func updateUI(infoModel: ProductCommissionDetailsModel?){
        if let info = infoModel {
            dialogues = info.dialogue ?? []
        }
        for item in dialogues {
            let dialogue = item.dialogue ?? ""
            if dialogue.length <= 0 {
                continue
            }
            let dialogueArr = self.getArrayFromJSONString(jsonString: dialogue)
            var messages = [Message]()
            for dialogueInfo in dialogueArr {
                let type = (dialogueInfo["type"] as? Int) ?? 0
                let content = (dialogueInfo["content"] as? String) ?? ""
                if type > 0 {
                    let message = Message.init(incoming: type == 1, text: content)
                    messages.append(message)
                }
            }
            item.messages = messages
        }
        tabView.reloadData()
    }

    //MARK: - function
    @objc func backUpVC(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func gotoProductDetailVC(){
        print("detail click ..........")
        if let info = infoModel {
            let product = info.creatProductModel()
            let salesVC = UIStoryboard(name: "Sale", bundle: nil).instantiateViewController(withIdentifier: "SaleDetailViewController") as! SaleDetailViewController
            salesVC.model = product
            salesVC.titleName = product.productName ?? ""
            self.navigationController?.pushViewController(salesVC, animated: true)
        }
    }
    
    //MARK: - Network
    func fetchProductCommissionDetails(){
        self.noNetwork = false
        ApiLoadingProvider.request(PAPI.queryProductDetails(productId:infoModel?.id ?? 0), model: ProductCommissionDetailsModel.self) { (result, resultInfo) in
            if let codeError = resultInfo.2 {
                self.noNetwork = codeError.code == 2
                self.updateUI(infoModel: nil)
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
               self.updateUI(infoModel: result)
            }
        }
    }
    
    //MARK: - UI
    lazy var tabView: UITableView = {
        let tabView = UITableView.init(frame: CGRect(), style: .plain)
        tabView.register(MessageBubbleTableViewCell.classForCoder(), forCellReuseIdentifier: "messageBubbleIdentifier")
        tabView.delegate = self
        tabView.dataSource = self
        tabView.separatorStyle = .none
        tabView.backgroundColor = UIColor.clear
        tabView.tableFooterView = UIView.init()
        return tabView
    }()
    
    lazy var tabHeadView: UIView = {
        let headView = UIView.init(x: 0, y: 0, w: SCREEN_WIDTH, h: 482)
        headView.backgroundColor = UIColor.clear
        return headView
    }()
    
    lazy var topImgView: UIImageView = {
        let imgView = UIFactoryGenerateImgView(imageName: "img_placeholder")
        return imgView
    }()
    
    lazy var backBtn: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 10, color: UIColor.white, placeText: "", imageName: "circle_back_arrow")
        btn.addTarget(self, action: #selector(backUpVC(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var productInfoBgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        return bgView
    }()
    
    lazy var nameLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 19, color: RGB(33, g: 33, b: 33), placeText: "某品牌路由器HU-YU89")
        lab.font = UIFont.boldSystemFont(ofSize: 19)
        return lab
    }()
    
    lazy var priceLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 23, color: RGB(255, g: 75, b: 75), placeText: "¥199.00")
        lab.font = UIFont.boldSystemFont(ofSize: 23)
        return lab
    }()
    
    lazy var commissionLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 15, color: RGB(35, g: 35, b: 35), placeText: "")
        return lab
    }()
    
    lazy var lineView: UIView = {
        let line = UIView()
        line.backgroundColor = RGB(216, g: 216, b: 216)
        return line
    }()
    
    lazy var detailBg: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.clear
        bgView.addTapGesture(target: self, action: #selector(gotoProductDetailVC))
        return bgView
    }()
    
    lazy var detailLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 14, color: RGB(69, g: 69, b: 69), placeText: "产品详情")
        return lab
    }()
    
    lazy var detailImgView: UIImageView = {
        let imgView = UIFactoryGenerateImgView(imageName: "rep_product_detail")
        return imgView
    }()
    
    func configUI(){
        
        self.view.addSubview(tabView)
        tabView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(-kStatusBarH)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-15)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-15)
            }
        }
        tabView.tableHeaderView = tabHeadView
        
        backBtn.frame = CGRect.init(x: 11, y: kStatusBarH + 5, w: 34, h: 34)
        self.view.addSubview(backBtn)
        
        topImgView.frame = CGRect.init(x: 0, y: 0, w: SCREEN_WIDTH, h: 375)
        tabHeadView.addSubview(topImgView)
        
        //        backBtn.frame = CGRect.init(x: 11, y: 25, w: 34, h: 34)
        //        tabHeadView.addSubview(backBtn)
        
        productInfoBgView.frame = CGRect.init(x: 15, y: 310, w: SCREEN_WIDTH - 30, h: 171)
        tabHeadView.addSubview(productInfoBgView)
        
        nameLab.frame = CGRect.init(x: 21, y: 21, w: productInfoBgView.w - 42, h: 24)
        productInfoBgView.addSubview(nameLab)
        
        priceLab.frame = CGRect.init(x: 21, y: nameLab.bottom + 15, w: nameLab.w, h: 27)
        productInfoBgView.addSubview(priceLab)
        
        commissionLab.frame = CGRect.init(x: 21, y: priceLab.bottom + 5, w: nameLab.w, h: 18)
        productInfoBgView.addSubview(commissionLab)
        
        lineView.frame = CGRect.init(x: 0, y: commissionLab.bottom + 16, w: productInfoBgView.w, h: 1)
        productInfoBgView.addSubview(lineView)
        
        detailBg.frame = CGRect.init(x: 0, y: lineView.bottom, w: productInfoBgView.w, h: 46)
        productInfoBgView.addSubview(detailBg)
        
        detailImgView.frame = CGRect.init(x: detailBg.w - 6 - 5, y: 16.5, w: 6, h: 13)
        detailBg.addSubview(detailImgView)
        
        detailLab.frame = CGRect.init(x: 21, y: 14, w: 80, h: 18)
        detailBg.addSubview(detailLab)
    }
}

// MARK: - UITableViewDelegate UITableViewDataSource
extension RepProductDetailVC {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dialogues.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let messageItems = dialogues[section].messages ?? []
        return messageItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageBubbleIdentifier", for: indexPath) as! MessageBubbleTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = RGB(245, g: 245, b: 245)
        let messages = dialogues[indexPath.section].messages ?? []
        cell.configureWithMessage(message: messages[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let dialogueItem = dialogues[section]
        let decStr = dialogueItem.sceneDescribe ?? ""
        var decStrH = decStr.height(SCREEN_WIDTH - 17 - 17, font: UIFont.systemFont(ofSize: 13), lineBreakMode: nil)
        decStrH = decStr.length > 0 ? decStrH : 0
        return 70 + decStrH
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dialogueItem = dialogues[section]
        let decStr = dialogueItem.sceneDescribe ?? ""
        var decStrH = decStr.height(SCREEN_WIDTH - 17 - 17, font: UIFont.systemFont(ofSize: 13), lineBreakMode: nil)
        decStrH = decStr.length > 0 ? decStrH : 0
        
        let headView = UIView.init(x: 0, y: 0, w: SCREEN_WIDTH, h: 70 + decStrH)
        headView.backgroundColor = UIColor.clear
        
        let sceneLab = UIFactoryGenerateLab(fontSize: 15, color: RGBA(r: 2, g: 81, b: 255, a: 1), placeText: "销售场景模拟")
        sceneLab.frame = CGRect.init(x: 17, y: 10, w: 100, h: 21)
        headView.addSubview(sceneLab)
        
        let sceneLab1 = UIFactoryGenerateLab(fontSize: 14, color: RGB(26, g: 26, b: 26), placeText: dialogueItem.sceneName ?? "")
        sceneLab1.frame = CGRect.init(x: 17, y: sceneLab.bottom + 10, w: 100, h: 21)
        headView.addSubview(sceneLab1)
        
        let sceneDescriLab = UIFactoryGenerateLab(fontSize: 13, color: RGB(69, g: 69, b: 69), placeText: decStr)
        sceneDescriLab.numberOfLines = 0
        sceneDescriLab.frame = CGRect.init(x: 17, y: sceneLab1.bottom + 1, w: headView.w - 17 - 17, h: decStrH)
        headView.addSubview(sceneDescriLab)
        return headView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension RepProductDetailVC {
    func getArrayFromJSONString(jsonString:String) -> [[String:Any]]{
        let jsonData:Data = jsonString.data(using: .utf8)!
        let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if array != nil {
            return array as! [[String : Any]]
        }
        return [[String:Any]]()
    }
}
