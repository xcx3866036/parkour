//
//  ProductCollectionViewCell.swift
//  CMIOTBase
//
//  Created by Apple on 2018/9/30.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productPhoto: UIImageView!
    
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var old_price: UILabel!
    
    @IBOutlet weak var new_price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // self.isUserInteractionEnabled = true
        productName.textColor = UIColor.colorWithHexString(hex: "#3D3D3D")
        new_price.textColor = UIColor.colorWithHexString(hex: "#FF4B4B")
        old_price.textColor = UIColor.colorWithHexString(hex: "#848484")
        
        let attr = NSMutableAttributedString(string: old_price.text!)
        attr.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.lightGray,
                            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 11),
                            NSAttributedStringKey.strikethroughStyle: 1],
                           range: NSRange(location: 0, length: old_price.text!.count))
        self.old_price.attributedText = attr
        
        contentView.layer.borderColor = kSeparatorColor.cgColor
        contentView.layer.borderWidth = 1
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(toDetail))
//        contentView.addGestureRecognizer(tap)
    }
    
//    @objc func toDetail() {
//
//       // self.viewContainingController()?.navigationController?.pushViewController(vc, animated: true)
//    }
    
}
