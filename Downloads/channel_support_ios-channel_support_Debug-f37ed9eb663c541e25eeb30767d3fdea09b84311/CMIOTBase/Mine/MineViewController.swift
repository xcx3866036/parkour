//
//  MineViewController.swift
//  CMIOTBase
//
//  Created by Apple on 2018/9/29.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import Kingfisher
import SVProgressHUD
import SwiftyUserDefaults

class MineViewController: UIViewController {
    var iconData = [String]()
    var buttonName = [String]()
    
    @IBOutlet weak var dataTable: UITableView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var dataArr:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = true
       
        self.view.backgroundColor = kBackgroundColor
        
        userImage.isUserInteractionEnabled = true
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = 35
        let gesture = UITapGestureRecognizer(target: self, action: #selector(upLoadImg))
        userImage.addGestureRecognizer(gesture)
        
        setUI()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        super.viewWillDisappear(animated)
    }
    
    @objc func upLoadImg() {
        view.endEditing(true)
        let upload = UploadPhoto()
        upload.showUploadPhoto(self, isEditing: true)
        upload.didSelectImage = {img in
            self.userImage.image = img
        }
    }
    
    func setUI() {
        iconData = ["Mask1","Mask","Mask3","Mask2","Mask4","Mask6","Mask5"]
        buttonName = ["员工姓名","员工分组","绑定手机号","修改密码","分享APP","APP操作视频演示","退出登录"]
        nameLabel.textColor = kDefaultColor
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)

        nameLabel.text = UserModel.read()?.employeeName
        detailLabel.textColor = kGayColor
        detailLabel.text = UserModel.read()?.groupName
        dataArr = [UserModel.read()?.employeeName,UserModel.read()?.groupName,UserModel.read()?.cellphone , ""] as! [String]
        
        dataTable.removeMoreLine()
        dataTable.isScrollEnabled = false
        dataTable.reloadData()
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func goOutAction(){
        Defaults[.token] = ""
        guard let window = UIApplication.shared.delegate?.window else { return }
        guard let naviVC = window?.rootViewController as? UINavigationController else { return }
        let vc = LoginViewController()
        let login = UINavigationController.init(rootViewController: vc)
        naviVC.present(login, animated: true, completion: {
            // 将所有界面都返回到根界面
            naviVC.viewControllers.last?.navigationController?.popToRootViewController(animated: true)
        })
    }
    
}

extension MineViewController:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(section == 0){
            return  4
        }else if(section == 1){
            return 2
        }else{
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 60
        }
        else if indexPath.section == 1 {
            return 65
        }
        else{
            return 65
        }
//        return indexPath.section == 0 ? 60 : 65
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.001 : 21
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0{
            let head = UIView.init(frame: CGRect(x: 0, y: 0, w: self.view.frame.width, h: 21))
            head.backgroundColor = kBackgroundColor
            return head
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MineCell" ) as! MineCell
        if(indexPath.section == 0){
            cell.iconImage.image = UIImage(named: iconData[indexPath.row])
            cell.nameLabel.text = buttonName[indexPath.row]
            cell.nameLabel.textColor = kDefaultColor
            cell.userMessage.text  = dataArr[indexPath.row]
            if(indexPath.row == 1 || indexPath.row == 1 ){
                cell.rightImage.isHidden = true
            }
        }
        else if indexPath.section == 1{
            if(indexPath.row == 0){
                cell.iconImage.image = UIImage(named: iconData[4])
                cell.nameLabel.text = buttonName[4]
                cell.nameLabel.textColor = kDefaultColor
                cell.userMessage.text  = ""
                cell.rightImage.isHidden = false
            }else{
                cell.iconImage.image = UIImage(named: iconData[5])
                cell.nameLabel.text = buttonName[5]
                cell.nameLabel.textColor = kDefaultColor
                cell.userMessage.text  = ""
                cell.rightImage.isHidden = false
            }
        }
        else {
            cell.iconImage.image = UIImage(named: iconData[6])
            cell.nameLabel.text = buttonName[6]
            cell.nameLabel.textColor = kRedColor
            cell.userMessage.text  = ""
            cell.rightImage.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if(indexPath.row == 2){
                self.performSegue(withIdentifier: "GoBindPhoneViewController", sender: nil)
            }
            else if(indexPath.row == 3){
                self.performSegue(withIdentifier: "GoFindPasswordViewController", sender: nil)
            }
        }
        else if(indexPath.section == 1){
            if(indexPath.row == 0){
                let shareView = InfoMaskView()
                shareView.configShareSubViews()
                UIApplication.shared.keyWindow?.addSubview(shareView)
                shareView.snp.makeConstraints { (make) in
                    make.top.bottom.left.right.equalToSuperview()
                }
            }else{
                self.performSegue(withIdentifier: "GoPlayViewController", sender:nil )
            }

//           let shareVC = APPShareWebVC()
//            self.navigationController?.pushViewController(shareVC, animated: true)
        }
        else if indexPath.section == 2 {
            let alertController = UIAlertController(title: "",
                                                    message: "确定退出登录？", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "确认", style: .default, handler: {
                action in
                ApiLoadingProvider.request(PAPI.logout(), model: BaseModel.self, completion: { (result, resultInfo) in
                    if let codeError = resultInfo.2 {
                        self.noNetwork = codeError.code == 2
                        SVProgressHUD.showError(withStatus: codeError.localizedDescription)
                    }
                    else{
                        self.goOutAction()
                    }
                })
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}





