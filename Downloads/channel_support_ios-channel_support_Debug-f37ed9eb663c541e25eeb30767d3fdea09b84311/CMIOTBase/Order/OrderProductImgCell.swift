//
//  OrderProductImgCell.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/11.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class OrderProductImgCell: UICollectionViewCell {
    lazy var productImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "img_placeholder")
        return imgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = false
        
        self.contentView.addSubview(productImgView)
        productImgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
