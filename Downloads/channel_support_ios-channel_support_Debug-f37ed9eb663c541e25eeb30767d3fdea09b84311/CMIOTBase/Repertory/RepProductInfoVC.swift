//
//  RepProductInfoVC.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/22.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import SVProgressHUD

class RepProductInfoVC: UIViewController,NavBarTitleChangeable {
    
    var mainDataArr = [ProductGroupModel]()
    private var pageTitleView: SGPageTitleView? = nil
    private var pageContentScrollView: SGPageContentScrollView? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "产品资料"
        view.backgroundColor = RGB(247, g: 248, b: 251)
        self.fetchProductGroupList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let delegate = appDelegate {
            delegate.changeNavigationBarDefaultInVC(rootVC: self)
        }
    }
    
    
    private func setupSGPagingView() {
        var titles = [String]()
        var childVCs = [RepProductInfoItemVC]()
        for item in mainDataArr {
            titles.append(item.groupName ?? "")
            let infoVC = RepProductInfoItemVC()
            infoVC.groupID = item.id ?? 0
            childVCs.append(infoVC)
        }
        
        let configure = SGPageTitleViewConfigure()
        configure.indicatorAdditionalWidth = 10
        // 说明：指示器额外增加的宽度，不设置，指示器宽度为标题文字宽度；若设置无限大，则指示器宽度为按钮宽度
        
        configure.titleGradientEffect = true
        
        self.pageTitleView = SGPageTitleView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44), delegate: self, titleNames: titles, configure: configure)
        view.addSubview(pageTitleView!)
        
        let contentViewHeight = view.h - self.pageTitleView!.bottom - kNavigationBarH
        let contentRect = CGRect(x: 0, y: pageTitleView!.bottom, width: view.frame.size.width, height: contentViewHeight)
        self.pageContentScrollView = SGPageContentScrollView(frame: contentRect, parentVC: self, childVCs: childVCs)
        pageContentScrollView?.delegateScrollView = self
        view.addSubview(pageContentScrollView!)
    }
    
    func updateProductTypeUI(infoModel:ProductGroupListModel?){
        if let info = infoModel {
            mainDataArr = info.list ?? []
        }
        if mainDataArr.count > 0 {
            self.setupSGPagingView()
        }
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
}



//MARK: - BWSwipeRevealCellDelegate
extension RepProductInfoVC {
    var preferredTextAttributes: [NSAttributedStringKey : AnyObject] {
        let item = FunNavTitleTextAttributesItem(color: UIColor.black, font:nil)
        return getNavgationBarTitleTextAttributes(with: item)
    }
}

extension RepProductInfoVC: SGPageTitleViewDelegate, SGPageContentScrollViewDelegate {
    func pageTitleView(pageTitleView: SGPageTitleView, index: Int) {
        pageContentScrollView?.setPageContentScrollView(index: index)
    }
    
    func pageContentScrollView(pageContentScrollView: SGPageContentScrollView, progress: CGFloat, originalIndex: Int, targetIndex: Int) {
        pageTitleView?.setPageTitleView(progress: progress, originalIndex: originalIndex, targetIndex: targetIndex)
    }
    func pageContentScrollView(pageContentScrollView: SGPageContentScrollView, index: Int) {
        
    }
}
