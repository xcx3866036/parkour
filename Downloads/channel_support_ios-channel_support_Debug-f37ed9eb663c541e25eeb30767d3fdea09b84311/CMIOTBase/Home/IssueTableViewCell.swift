//
//  IssueTableViewCell.swift
//  CMIOTBase
//
//  Created by Apple on 2018/10/8.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import SVProgressHUD
class IssueTableViewCell: UITableViewCell {


    @IBOutlet weak var addBt: UIButton!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var reduceBt: UIButton!
    @IBOutlet weak var oldMoney: UILabel!
    @IBOutlet weak var currentMoney: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var leftImage: UIImageView!
    
    var model:ProductModel?
    
    var issueActionBlock:((String) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //numLabel.text = "0"
        self.reduceBt.isEnabled = true
        self.addBt.isEnabled = true
        let attr = NSMutableAttributedString(string: oldMoney.text!)
        attr.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.lightGray,
                            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13),
                            NSAttributedStringKey.strikethroughStyle: 1],
                           range: NSRange(location: 0, length: oldMoney.text!.count))
        self.oldMoney.attributedText = attr
    }

    @IBAction func addAction(_ sender: Any) {
        
        self.reduceBt.isEnabled = true
        self.addBt.isEnabled = true
        
        if self.numLabel.text == "99" {
            return
        }
        var num = Int(self.numLabel.text!)
        num = num! + 1
        self.numLabel.text = String(format: "%d", num!)


        
        
        ApiLoadingProvider.request(PAPI.modifyCartItem(productId: (model?.id)!, productCount: num!
            , amount: (model?.salePrice)!), model: BaseModel.self) { (reslute, info) in
            if let codeError = info.2 {
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                if(self.issueActionBlock != nil){
                    self.issueActionBlock!("1")
                }
            }
        }
        
    }
    @IBAction func reduceAction(_ sender: Any) {
        
        var num = Int(self.numLabel.text!)
        if num! <= 0 {
            return
        }
        num = num! - 1
        self.numLabel.text = String(format: "%d", num!)

        ApiLoadingProvider.request(PAPI.modifyCartItem(productId: (model?.id)!, productCount: num!
            , amount: (model?.salePrice)!), model: BaseModel.self) { (reslute, info) in
                if let codeError = info.2 {
                    SVProgressHUD.showError(withStatus: codeError.localizedDescription)
                }
                else{
                    if(self.issueActionBlock != nil){
                        self.issueActionBlock!("2")
                    }
                }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
