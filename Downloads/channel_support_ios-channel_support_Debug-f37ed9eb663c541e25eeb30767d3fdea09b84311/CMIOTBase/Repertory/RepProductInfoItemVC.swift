//
//  RepProductInfoVC.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/9.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import SVProgressHUD
import DZNEmptyDataSet
import MJRefresh

class RepProductInfoItemVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {
    lazy var collectionView: UICollectionView = {
        
        let itemWidth = (SCREEN_WIDTH - 4) / 2
        let flowLayout = UICollectionViewFlowLayout();
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 2
        flowLayout.minimumLineSpacing = 2
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        flowLayout.itemSize = CGSize.init(width: itemWidth, height: itemWidth + 64)
        
        let collectionView = UICollectionView.init(frame: CGRect(), collectionViewLayout: flowLayout)
        collectionView.register(RepProductInfoCell.classForCoder(), forCellWithReuseIdentifier: "repProductInfoIdentifier")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    var groupID: Int = 0
    var pageNum: Int = 1
    var dataArr:[ProductCommissionDetailsModel] = [ProductCommissionDetailsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        
        //刷新
        collectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.pageNum = 1
            self?.fetchProductCommissionList(isRefresh: true)
            self?.collectionView.mj_header.endRefreshing()
        })
        
        //加载
        collectionView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            self?.pageNum += 1
            self?.fetchProductCommissionList(isRefresh: false)
            self?.collectionView.mj_footer.endRefreshing()
        })
        
        self.fetchProductCommissionList(isRefresh: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func configUI() {
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(0)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top)
            }
        }
    }
    
    
    func updateUI(infoModel: ProductCommissionListModel?,isRefresh: Bool){
        if let info = infoModel {
            let fetechedArr = info.list ?? []
            if isRefresh{
                dataArr = fetechedArr
                self.collectionView.mj_footer.resetNoMoreData()
            }
            else{
                if fetechedArr.count <= 0{
                    self.collectionView.mj_footer.endRefreshingWithNoMoreData()
                }
                dataArr += fetechedArr
            }
            self.collectionView.reloadData()
        }
    }
    
    
    //MARK: - Network

    func fetchProductCommissionList(isRefresh : Bool){
        self.noNetwork = false
         let queryCondition = ["pageNum":pageNum,"pageSize":kPageSize]
        ApiLoadingProvider.request(PAPI.queryProductCommissionList(groupId:groupID,queryCondition:queryCondition), model: ProductCommissionListModel.self) { (result, resultInfo) in
            if let codeError = resultInfo.2 {
                self.noNetwork = codeError.code == 2
                self.updateUI(infoModel: nil,isRefresh: isRefresh)
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
               self.updateUI(infoModel: result,isRefresh: isRefresh)
            }
        }
    }
   
}


// MARK: - CollectionViewDelegate  CollectionViewDataSource
extension RepProductInfoItemVC {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "repProductInfoIdentifier", for: indexPath) as! RepProductInfoCell
        cell.backgroundColor = UIColor.clear
        let infoModel = dataArr[indexPath.row]
        cell.configRepProductInfo(infoModel: infoModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = RepProductDetailVC()
        let infoModel = dataArr[indexPath.row]
        detailVC.infoModel = infoModel
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension RepProductInfoItemVC {
    
    func image(forEmptyDataSet scrollVie6w: UIScrollView!) -> UIImage! {
        let imageName = self.noNetwork ? "nonetwork" : "nodata"
        return UIImage.init(named: imageName)
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let titleStr = self.noNetwork ? "网络出错了，请检查链接" : "暂时没有数据记录"
        let multipleAttributes: [NSAttributedStringKey : Any] = [
            kCTForegroundColorAttributeName as NSAttributedStringKey: RGB(0, g: 0, b: 0),
            kCTFontAttributeName as NSAttributedStringKey: UIFont.systemFont(ofSize: 12)]
        return NSAttributedString(string: titleStr, attributes: multipleAttributes)
    }
    
    func buttonImage(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> UIImage! {
        return nil
    }
    
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 17
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        if self.noNetwork {
            let multipleAttributes: [NSAttributedStringKey : Any] = [
                kCTForegroundColorAttributeName as NSAttributedStringKey: RGB(0, g: 124, b: 255),
                kCTFontAttributeName as NSAttributedStringKey: UIFont.systemFont(ofSize: 15)]
            return NSAttributedString(string: "点击刷新", attributes: multipleAttributes)
        }
        else{
            return nil
        }
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        if self.noNetwork {
            pageNum = 1
            self.fetchProductCommissionList(isRefresh: true)
        }
    }
}

