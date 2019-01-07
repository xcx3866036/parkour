//
//  PlayViewController.swift
//  CMIOTBase
//
//  Created by 谢成蹊 on 2018/12/20.
//  Copyright © 2018 xiaojunzhang. All rights reserved.
//

import UIKit
import SVProgressHUD
class PlayViewController: UIViewController {

    @IBOutlet weak var playCollection: UICollectionView!
    private let edgeMargin : CGFloat = 10
    var dataArr:[MineVideoModel]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "APP操作视频演示"
        view.backgroundColor = kBackgroundColor
        playCollection.delegate = self
        playCollection.dataSource = self
        
        reloadData()
        // Do any additional setup after loading the view.
    }
    
    func reloadData(){
        ApiLoadingProvider.request(PAPI.queryVidoUrlList(), model: MineVideoListModel.self) { (result, info)  in
            if let codeError = info.2 {
                self.noNetwork = codeError.code == 2
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                self.dataArr = (result?.list)!
                if(self.dataArr?.count != 0){
                    self.playCollection.reloadData()
                }
                
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PlayViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if((dataArr) != nil){
            return dataArr!.count
        }else{
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayCollectionViewCell", for: indexPath) as! PlayCollectionViewCell
        cell.nameLabel.text = self.dataArr![indexPath.row].vidoName
        cell.timeLabel.text = self.dataArr![indexPath.row].playTime

        let imageFullPath = CHVideoUrl + self.dataArr![indexPath.row].imgUrl
        cell.iconImage.setImageUrl(imageFullPath)

        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = WTPlyaerViewController()
        vc.videoUrl = self.dataArr![indexPath.row].vidoUrl
        self.presentVC(vc)
    }
}

extension PlayViewController: UICollectionViewDelegateFlowLayout{
    
    // section整体的inset
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(14, 10, 0, 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (self.view.frame.width -  3 * edgeMargin) / 2, height: 160)
        
    }
    
    // InteritemSpacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    // LineSpacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
        
    }
    // header size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize.zero
        
    }
    // footer size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize.zero
        
    }
    
    
}

extension PlayViewController:NavBarTitleChangeable{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        //        loadData()
        appDelegate!.changeNavigationBarDefaultInVC(rootVC: self)
        
    }
    
    var preferredTextAttributes: [NSAttributedStringKey : AnyObject] {
        let item = FunNavTitleTextAttributesItem(color: UIColor.black, font:nil)
        return getNavgationBarTitleTextAttributes(with: item)
    }
    
    
}
