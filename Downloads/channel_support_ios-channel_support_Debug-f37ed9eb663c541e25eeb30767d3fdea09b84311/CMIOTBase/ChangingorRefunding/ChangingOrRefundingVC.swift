//
//  ChangingOrRefundingVC.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/22.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class ChangingOrRefundingVC: UIViewController,NavBarTitleChangeable {
    
    private var pageTitleView: SGPageTitleView? = nil
    private var pageContentScrollView: SGPageContentScrollView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "退换货处理"
        view.backgroundColor = RGB(247, g: 248, b: 251)
        
        self.setupSGPagingView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let delegate = appDelegate {
            delegate.changeNavigationBarDefaultInVC(rootVC: self)
        }
    }
    
    
    private func setupSGPagingView() {
        let titles = ["全部","处理中","已完成","已取消"]
        var subVCs = [ChangingOrRefundingItemVC]()
        let configure = SGPageTitleViewConfigure()
        configure.indicatorAdditionalWidth = 10
        // 说明：指示器额外增加的宽度，不设置，指示器宽度为标题文字宽度；若设置无限大，则指示器宽度为按钮宽度
        
        configure.titleGradientEffect = true
        self.pageTitleView = SGPageTitleView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44), delegate: self, titleNames: titles, configure: configure)
        view.addSubview(pageTitleView!)
        
        for(index,_) in titles.enumerated(){
            let changingVC = ChangingOrRefundingItemVC()
            changingVC.changingOrRefundingStatus = index
            subVCs.append(changingVC)
        }
        
        let contentViewHeight = view.h - self.pageTitleView!.bottom - kNavigationBarH
        let contentRect = CGRect(x: 0, y: pageTitleView!.bottom, width: view.frame.size.width, height: contentViewHeight)
        self.pageContentScrollView = SGPageContentScrollView(frame: contentRect, parentVC: self, childVCs: subVCs)
        pageContentScrollView?.delegateScrollView = self
        view.addSubview(pageContentScrollView!)
    }
}

//MARK: - BWSwipeRevealCellDelegate
extension ChangingOrRefundingVC {
    var preferredTextAttributes: [NSAttributedStringKey : AnyObject] {
        let item = FunNavTitleTextAttributesItem(color: UIColor.black, font:nil)
        return getNavgationBarTitleTextAttributes(with: item)
    }
}

extension ChangingOrRefundingVC: SGPageTitleViewDelegate, SGPageContentScrollViewDelegate {
    func pageTitleView(pageTitleView: SGPageTitleView, index: Int) {
        pageContentScrollView?.setPageContentScrollView(index: index)
    }
    
    func pageContentScrollView(pageContentScrollView: SGPageContentScrollView, progress: CGFloat, originalIndex: Int, targetIndex: Int) {
        pageTitleView?.setPageTitleView(progress: progress, originalIndex: originalIndex, targetIndex: targetIndex)
    }
    func pageContentScrollView(pageContentScrollView: SGPageContentScrollView, index: Int) {
        
    }
}
