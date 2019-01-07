//
//  HistorySelectedUserCell.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/16.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class HistorySelectedUserCell: UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    lazy var collectionView: UICollectionView = {
        
        let itemWidth = (SCREEN_WIDTH - 2) / 2
        
        let flowLayout = UICollectionViewFlowLayout();
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        flowLayout.itemSize = CGSize.init(width: itemWidth, height: 60)
        
        let collectionView = UICollectionView.init(frame: CGRect(), collectionViewLayout: flowLayout)
        collectionView.register(HistoryGroupUsersCell.classForCoder(), forCellWithReuseIdentifier: "historySelectedUserCellIdentifier")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    var cellClickBlock: ((Int) -> ())?
    var dataArr = [UserModel]()
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - CollectionViewDelegate  CollectionViewDataSource
extension HistorySelectedUserCell {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "historySelectedUserCellIdentifier", for: indexPath) as! HistoryGroupUsersCell
        cell.configHistoryUserInfo(info:dataArr[indexPath.row],isSelected: false)
//        cell.configSelectUserName(userName: "王大锤", groupName: "产品组", isSelected: false)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let  click = self.cellClickBlock {
            click(indexPath.row)
        }
    }
}
