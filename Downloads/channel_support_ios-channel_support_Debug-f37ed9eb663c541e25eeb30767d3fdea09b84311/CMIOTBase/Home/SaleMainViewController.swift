//
//  SaleMainViewController.swift
//  CMIOTBase
//
//  Created by Apple on 2018/9/29.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import SVProgressHUD
class SaleMainViewController: UIViewController {
    private var vc1: CommodityViewController!
    var dataArr:[ProductGroupModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "产品资料"
        loadData()

        // Do any additional setup after loading the view.
    }
    
    func loadData(){
        
        ApiLoadingProvider.request(PAPI.queryProductGroupList(), model: ProductGroupListModel.self) { (result, info) in
            if let codeError = info.2 {
                self.noNetwork = codeError.code == 2
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                self.dataArr = result?.list ?? []
                if(self.dataArr.count != 0){
                    self.setup()
                }
                
            }
        }
    }
    
    func setup() {
       // self.creatBackButton()
        var childVCs = [UIViewController]()
        var childTitles : [String] = []
        for model in dataArr{
            let vc = UIStoryboard(name: "Sale", bundle: nil).instantiateViewController(withIdentifier: "CommodityViewController") as! CommodityViewController
            vc.model = model
            childTitles.append(model.groupName!)
            childVCs.append(vc)
        }
        
        
        // 2.设置样式
        let titleStyle = HYTitleStyle()
        titleStyle.hasScrollLine = true
        titleStyle.hasGradient = false
        titleStyle.lineScrollType = .RealTime
        titleStyle.isScrollEnable = true
        titleStyle.normalColor = kScrollColor
        titleStyle.scrollLineColor = kScrollLineColor
        titleStyle.selectedColor = KnewScrollLine
        titleStyle.normalFont = UIFont.systemFont(ofSize: 15)
        titleStyle.selectedFont = UIFont.AvenirNextDemiBold(size: 15)
        // 3.设置视图大小
        let frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        
        // 3.添加到视图
        let pageView = HYPageView(frame: frame, titles: childTitles, childVCs: childVCs, parentVC: self, titleStyle: titleStyle)
        view.addSubview(pageView)
    }
    
}


extension SaleMainViewController:NavBarTitleChangeable{
    
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
