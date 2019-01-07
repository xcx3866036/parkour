//
//  FunctionModulesCell.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/9/28.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class FunctionModulesCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    lazy var collectionView: UICollectionView = {
        
        let itemWidth = (SCREEN_WIDTH - 15 - 15 - 9 - 9) / 3
        
        let flowLayout = UICollectionViewFlowLayout();
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 8
        flowLayout.minimumLineSpacing = 10
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15)
        flowLayout.itemSize = CGSize.init(width: itemWidth, height: itemWidth)
        
        let collectionView = UICollectionView.init(frame: CGRect(), collectionViewLayout: flowLayout)
        collectionView.register(ModuleColCell.classForCoder(), forCellWithReuseIdentifier: "modulesIdentifier")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    var cellClickBlock: ((Int,Int) -> ())?
    let dataArr = ["cell1","cell2","cell3","cell4","cell5","cell6"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func calCollectionCount() -> Int {
        let user = UserModel.read()
        let app_xiaosou = user?.app_xiaosou ?? 0
        let app_changku = user?.app_changku ?? 0
        if app_changku == 1 && app_xiaosou == 1 {
            return 6
        }
        else if app_changku == 1 && app_xiaosou == 0 {
            return 1
        }
        else if app_changku == 0 && app_xiaosou == 1 {
            return 5
        }
        return 0
    }
}
    
    // MARK: - CollectionViewDelegate  CollectionViewDataSource
    extension FunctionModulesCell {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return self.calCollectionCount()
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "modulesIdentifier", for: indexPath) as! ModuleColCell
//            cell.backgroundColor = RGB(36, g: 78, b: 255)
            let count = self.calCollectionCount()
            if count == 6 {
                cell.configModuleInfoByIndex(index: indexPath.row)
                if indexPath.row == dataArr.count - 1 {
                    cell.authorityImgView.isHidden = false
                }
                else{
                    cell.authorityImgView.isHidden = true
                }
            }
            else if count == 5 {
                 cell.configModuleInfoByIndex(index: indexPath.row)
                 cell.authorityImgView.isHidden = true
            }
            else if count == 1 {
                 cell.configModuleInfoByIndex(index: 5)
                 cell.authorityImgView.isHidden = false
            }
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if let  click = self.cellClickBlock {
                let count = self.calCollectionCount()
                if count == 1 {
                     click(indexPath.row,1)
                }
                else{
                     click(indexPath.row,0)
                }
            }
        }
}

