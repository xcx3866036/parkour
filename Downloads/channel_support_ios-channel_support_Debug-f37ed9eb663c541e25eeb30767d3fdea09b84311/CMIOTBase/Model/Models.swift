//
//  Models.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/18.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import Foundation
import HandyJSON

class BaseModel: HandyJSON {
    
    required init() {}
}

/*
 2.1 Login
 */
class LoginModel: HandyJSON {
    var token: String? = ""     // token
    var user: UserModel?
    required init() {}
}

/*
 用户信息
 */
class UserModel: NSObject,HandyJSON,NSCoding {
    var id: Int? = 0 //用户ID
    var roleId: Int? = 0
    var roleName: String? = ""
    var loginName: String? = "" //登录账号
    var employeeName: String? = "" //用户姓名
    var employeeNo: String? = ""  //工号
    var cellphone: String? = ""  //手机号
    var organizeId: Int? = 0        //departmentId
    var organizeName: String? = ""  //组织机构名称
    var groupId: Int? = 0         //groupId
    var groupName: String? = ""  //分组名称
    var sex: Int? = 1          //性别
    var sexName: String? = ""  //性别名称
    var nationCode: String? = ""  //民族编码
    var nationName: String? = ""  //民族
    var photo: String? = ""      //头像
    var business: CompanyBusiness?   // 业务权限
    var network: NetworkInfo?        // 网点
    
    // 权限属性 -- 根据u权限信息需要自己赋值
    var app_login:Int? = 0      // 库存权限
    var app_xiaosou:Int? = 0    // 库存权限
    var app_changku:Int? = 0    // 库存权限
    
    required override init() {}
    
    // MARK: - 格式化
    func encode(with aCoder:NSCoder) {
        aCoder.encode(id, forKey:"id")
        aCoder.encode(loginName, forKey:"loginName")
        aCoder.encode(roleId, forKey:"roleId")
        aCoder.encode(roleName, forKey:"roleName")
        aCoder.encode(employeeName, forKey:"employeeName")
        aCoder.encode(employeeNo, forKey:"employeeNo")
        aCoder.encode(cellphone, forKey:"cellphone")
        aCoder.encode(organizeId, forKey:"organizeId")
        aCoder.encode(organizeName, forKey:"organizeName")
        aCoder.encode(groupId, forKey:"groupId")
        aCoder.encode(groupName, forKey:"groupName")
        aCoder.encode(sex, forKey:"sex")
        aCoder.encode(sexName, forKey:"sexName")
        aCoder.encode(nationCode, forKey:"nationCode")
        aCoder.encode(nationName, forKey:"nationName")
        aCoder.encode(photo, forKey:"photo")
       
        aCoder.encode(app_login, forKey:"app_login")
        aCoder.encode(app_xiaosou, forKey:"app_xiaosou")
        aCoder.encode(app_changku, forKey:"app_changku")
    }
    
    // MARK:- 处理需要解档的字段
    required init(coder aDecoder:NSCoder) {
        id = aDecoder.decodeObject(forKey:"id")as?Int
        roleId = aDecoder.decodeObject(forKey:"roleId")as?Int
        roleName = aDecoder.decodeObject(forKey:"roleName") as? String
        loginName = aDecoder.decodeObject(forKey:"loginName") as? String
        employeeName = aDecoder.decodeObject(forKey:"employeeName") as? String
        employeeNo = aDecoder.decodeObject(forKey:"employeeNo") as? String
        cellphone = aDecoder.decodeObject(forKey:"cellphone") as? String
        organizeId = aDecoder.decodeObject(forKey:"organizeId") as? Int
        organizeName = aDecoder.decodeObject(forKey:"organizeName") as? String
        groupId = aDecoder.decodeObject(forKey:"groupId") as? Int
        groupName = aDecoder.decodeObject(forKey:"groupName") as? String
        sex = aDecoder.decodeObject(forKey:"sex") as? Int
        sexName = aDecoder.decodeObject(forKey:"sexName") as?String
        nationCode = aDecoder.decodeObject(forKey:"nationCode") as? String
        nationName = aDecoder.decodeObject(forKey:"nationName") as? String
        photo = aDecoder.decodeObject(forKey:"photo") as? String
        
        app_login = aDecoder.decodeObject(forKey:"app_login") as? Int
        app_xiaosou = aDecoder.decodeObject(forKey:"app_xiaosou") as? Int
        app_changku = aDecoder.decodeObject(forKey:"app_changku") as? Int
        
    }
    
    /*
     * 这里是保存UserModel到本地
     */
    static func save(model:UserModel?) {
        if model == nil {
            return
        }
        model?.app_login = model?.business?.app_login
        model?.app_xiaosou = model?.business?.app_xiaosou
        model?.app_changku = model?.business?.app_changku
        let userDefault = UserDefaults.standard
        let modelData:NSData = NSKeyedArchiver.archivedData(withRootObject: model!) as NSData
        userDefault.set(modelData, forKey: "UserModel")
    }
    
    /*
     * 这里是获取UserModel
     */
    static func read() -> UserModel? {
        let userDefault = UserDefaults.standard
        if let myModelData = userDefault.object(forKey: "UserModel"){
            return NSKeyedUnarchiver.unarchiveObject(with: myModelData as! Data) as? UserModel
        }
        return nil
    }
}


class CompanyBusiness: HandyJSON {
    var app_login:Int? = 0    // 库存权限
    var app_xiaosou:Int? = 0    // 库存权限
    var app_changku:Int? = 0    // 库存权限
    required init() {}
}

class NetworkInfo: HandyJSON {
    required init() {}
}

/*
 2.4查询单个员工分组
 */
class EmployeeGroupModel: HandyJSON {
    var id: Int? = 0 //组ID
    var groupName: String? = "" //组名称
    var sort: Int? = 0 //排序
    var employeeCount: Int? = 0
    required init() {}
}

/*
 2.5员工分组列表
 */
class EmployeeGroupListModel: HandyJSON {
    var total: Int? = 0 //总数
    var list: [EmployeeGroupModel]? = [] //组列表
    required init() {}
}

/*
 2.6单个员工信息 - UserModel
 */

//class EmployeeInfoBaseModel: BaseModel {
//    var details:UserModel?
//    required init() {}
//}

/*
 2.7 员工信息列表
 */
class EmployeeInfoListModel: HandyJSON {
    var total: Int? = 0 //总数
    var list: [UserModel]? = [] //组列表
    required init() {}
}

/*
 2.8单个产品分组
 */

class ProductGroupModel: HandyJSON {
    var id: Int? = 0 //组ID
    var sort: Int? = 0 //
    var groupName: String? = "" //组名称
    required init() {}
}

/*
 2.9产品分组列表
 */
class ProductGroupListModel: HandyJSON {
    var total: Int? = 0 //总数
    var list: [ProductGroupModel]? = [] //组列表
    required init() {}
}

/*
 2.10 单个产品
 */
class ProductModel: HandyJSON {
    var id: Int? = 0 //产品ID
    var productNo: String? = ""
    var productName: String? = ""
    var groupId: Int? = 0
    var groupName: String? = ""
    var picturePath: String? = ""    // 图片地址
    var pictureList: [String]?   //图片数组
    var salePrice: Double? = 0.0     // 销售价 - 单位分
    var linePrice: Double? = 0.0     // 划线价 - 单位分
    var commission: Double? = 0.0    // 佣金
    var inventory: Int? = 0          // 库存
    var productType: Int? = 0
    var putawayTime: String? = ""        //上线时间
    
    // 8.2
    var goodsId: Int? = 0        // 商品ID
    var currentStatus: Int = 0   // 当前状态
    var barCode: String? = ""    // 当前状态
    var price: Double? = 0       //当前售价
    var productId: Int? = 0      // 产品ID
    
    //11.7
    var stockCount: Int? = 0    // 库存总量
    
    var specific: ProductSpecific?   //产品规格
    required init() {}
}
class ProductSpecific: HandyJSON {
    required init() {}
}

/*
 6.5查询单个产品的详情
 */
class ProductDetailModel: HandyJSON {
    var id: Int? = 0 //
    var productId: Int? = 0
    var list:[String] = []
    required init() {}
}

/*
 2.11 产品列表
 */

class ProductListModel: HandyJSON {
    var total: Int? = 0            //总数
    var list: [ProductModel]? = [] //产品列表
    required init() {}
}

/*
 4.1当月销售情况
 */
class CurrentMonthSalesModel: HandyJSON {
    var totalOrder: Int? = 0    // 当月订单数
    var totalAmount: Double? = 0  // 总销售额 - 单位为元,保留2位小数
    required init() {}
}

/*
 5.1统计库存信息
 */
class StockModel: HandyJSON {
    var totalReturn: Int? = 0    // 退换货总数
    var totalOut: Int? = 0       // 预出库总数
    required init() {}
}

/*
5.2统计退换货数据
 */
class ReturnModel: HandyJSON {
    var totalReturn: Int? = 0    // 退换货总数
    var totalBad: Int? = 0       // 坏货总数
    required init() {}
}

/*
 5.3退还货员工维度统计
 */
class EmployeeDimensionReturnModel: HandyJSON {
    var total: Int? = 0
    var list: [EmployeeDimensionReturnListModel]? = []
    required init() {}
}
class EmployeeDimensionReturnListModel: HandyJSON {
    var employeeId: Int? = 0
    var employeeName: String? = ""
    var totalReturn: Int? = 0
    var totalBad: Int? = 0
    var operationDate: String? = ""
    var total: Int? = 0
    required init() {}
}

/*
 5.4退还货员工维度明细
 */
class ReturnEmployeeDetailsModel: HandyJSON {
    var total: Int? = 0
    var list: [ReturnEmployeeDetailsListModel]? = []
    required init() {}
}
class ReturnEmployeeDetailsListModel: HandyJSON {
    var productId: Int? = 0
    var productName: String? = ""
    var goodsId: Int? = 0
    var barCode: String? = ""       // 商品二位码
    var status: Int? = 0            // 商品状态
    var isBad: Int? = 0
    required init() {}
}

/*
 5.5预出库统计
 */
class OutModel: HandyJSON {
    var total: Int? = 0    // 预出库总数
    required init() {}
}

/*
 5.6预出库明细
 */
class EmployeeDimensionOutModel: HandyJSON {
    var total: Int? = 0
    var list: [EmployeeDimensionOutListModel]? = []
    required init() {}
}
class EmployeeDimensionOutListModel: HandyJSON {
    var productId: Int? = 0
    var productName: String? = ""
    var goodsId: Int? = 0
    var barCode: String? = ""       // 商品二位码
    var status: Int? = 0            // 商品状态
    var isBad: Int? = 0
    required init() {}
}

/*
 5.8通过二维码获取商品
 */
class GoodsModel: HandyJSON {
    var id: Int? = 0    // 商品ID
    var barCode: String? = ""
    var status: Int? = 0
    var isBad: Int? = 0    //
    var updateUser: Int? = 0
    var createUser: Int? = 0
    var createTime:String? = ""
    var updateTime:String? = ""
    var productId: Int? = 0
    var productName: String? = ""
    var currentStatus:Int? = 0
    var picturePath:String? = ""
    required init() {}
    
    func isSatisfyPreStock() -> Bool {
        if currentStatus == 1 {
            return true
        }
        return false
    }
}

/*
 9.6 获取换货回收的商品
 */
class ExchangeBackGoodsListModel: HandyJSON {
    var list: [GoodsModel]? = []
    required init() {}
}

/*
 5.10通过二维码获取已出库商品
 */
class OutGoodsModel: HandyJSON {
    var id: Int? = 0    // 商品ID
    var barCode: String? = ""
    var currentHolder: Int? = 0   // 商品拥有人
    var currentHolderName: String? = ""  //
    var outTime: String? = ""    // 出库时间
    var isBad: Int? = 0
    /*
     1 未出库
     2 已出库
     3 已售出
     4 换货回收
     5 退货回收
     6 已入库
     7 换货换出
     8 平级换出
     9 平级换入
     2/4/5/9可以退货
     */
    var currentStatus: Int? = 0
    var productId: Int? = 0
    var productName: String? = ""
    var picturePath: String? = ""
    // 扫码换新后手动赋值添加
    var exchangeOutGoods: OutGoodsModel?   // 换新的新编码
    required init() {}
    
    // 2/4/5/9可以退货
    func isSatisfyBack() -> Bool {
        let stataus = self.currentStatus ?? 0
        if stataus == 2 || stataus == 4 || stataus == 5 || stataus == 9{
           return true
        }
        else{
            return false
        }
    }
    
    // 2,4,5,9是可以换新
    func isSatisfyExchangeNew() -> Bool {
        let stataus = self.currentStatus ?? 0
        if stataus == 2 || stataus == 4 || stataus == 5 || stataus == 9{
            return true
        }
        else{
            return false
        }
    }
    
    // 可以回收
    func isSatisfyRecyle() -> Bool {
        let stataus = self.currentStatus ?? 0
        if stataus == 3 || stataus == 7{
            return true
        }
        else{
            return false
        }
    }
}

/*
  9.12通过二维码获取已售出商品
 */
class SaledGoodsModel: HandyJSON{
    var list:[OutGoodsModel]? = []
    required init() {}
}

/*
 6.5查询购物车信息
 */
class CartItemListModel: HandyJSON {
    var orderCount: Int? = 0      // 下单数
    var totalAmount: Double? = 0  // 下单总金额
    var list: [CartItemListItemModel]? = []
    required init() {}
}
class CartItemListItemModel: HandyJSON {
    var id: Int? = 0
    var productId: Int? = 0
    var productName: String? = ""
    var picturePath: String? = ""
    var productCount: Int? = 0           //
    var amount: Double? = 0.0       //
    required init() {}
}

/*
6.6 查询客户信息
 */
class CustomerInfoListModel: HandyJSON {
    var total: Int? = 0
    var list: [CustomerInfoListItemModel]? = []
    required init() {}
}
class CustomerInfoListItemModel: HandyJSON {
    var id: Int? = 0    // 客户ID
    var customerName: String? = ""
    var cellphone: String? = ""   //
    var provinceCode: String? = ""  //
    var cityCode: String? = ""    //
    var countyCode: String? = ""
    var gender: Int? = 0
    var address: String? = ""
    required init() {}
}

/*
 6.7新增客户信息
 */
class CreateCustomerInfoModel: HandyJSON {
    var id: Int? = 0    //
    required init() {}
}

/*
 6.8修改客户信息 - CreateCustomerInfoModel
 */
//class ModifyCustomerInfoBaseModel: BaseModel {
//    var details:CreateCustomerInfoModel?
//    required init() {}
//}

/*
 6.9新增订单
 */
class CreateOrderInfoModel: HandyJSON {
    var id: Int? = 0    //
    required init() {}
}

/*
 6.13获取微信支付二维码
 */
class AcceptanceCodModel: HandyJSON {
    var codeStr: String? = ""    //
    required init() {}
}

/*
 7.7 扫码返回
 */
class OrderScanGoodsModel: HandyJSON {
    var id: Int? = 0  // 商品id
    var barCode: String? = ""   //条形码
    var currentHolder: Int? = 0  //拥有人id
    var currentHolderName: String? = ""   //拥有人姓名
    var createTime: String? = ""   //出库时间
    var currentStatus: Int? = 0   //当前状态
    var productId: Int? = 0   //产品id
    var productName: String? = ""   //产品名
    required init() {}
}
/*
 7.7 二维码返回
 */
class OrderPayUrlModel: HandyJSON {
    var payUrl: String? = ""  // url

    required init() {}
}


/*
 8.1查询订单列表
 */

class OrderInofListModel: HandyJSON {
    var total: Int? = 0
    var list: [OrderInofListItemModel]? = []
    required init() {}
}
class OrderInofListItemModel: HandyJSON {
    var id: Int? = 0    // 订单ID
    var orderNo: String? = ""
    var goodsCount: Int? = 0   //
    var amount: Double? = 0  //
    var payWay: Int? = 0    //
    var payStatus: Int? = 0
    var payTime: String? = ""
    var createTime: String? = ""
    var createUser: Int? = 0
    
    /*
     1 已下单待安装  用户已下单还没有进行扫码      -- 
     2 已安装待验收 扫码安装完成未输入用户验收码
     3 已验收待付款
     4 已支付 已支付、换货服务完成、取消售后
     5 售后服务中 换货服务
     6 已退款 退款完成，订单关闭
     7 已完成 订单超出服务期限
     8 已取消 未支付前取消
     9 售后服务中 退货退款服务
     */
    var orderStatus: Int? = 0
    var picturePaths:[String]? = []
    var isReturnable: Int = 0      // 申请售后  可退货退款
    var isExchangeable: Int = 0    // 申请售后  可换货
    var returnGoodsDays: Int = 0   // 支持退货天数
    var exchangeGoodsDays: Int = 0 // 支持换货天数
    
    required init() {}
    
    func configOrderStatusInfo() -> (btnStr:String,isHidenCancle:Bool,statusImgStr:String,statusStr:String,listStatusStr:String,step:Int){
        var btnTitle = ""
        var needHideCancleBtn = true
        var statusImgName = ""
        var statusStr = ""
        var listStatusStr = ""
        var step = 0
        switch self.orderStatus ?? 0 {
        case 1:
            btnTitle = "扫码安装"
            needHideCancleBtn = false
            statusImgName = ""
            statusStr = ""
            listStatusStr = "服务中"
            step = 1
        case 2:
            btnTitle = "输入验证码"
            needHideCancleBtn = false
            statusImgName = ""
            statusStr = ""
            listStatusStr = "服务中"
            step = 2
        case 3:
            btnTitle = "立即收款"
            needHideCancleBtn = false
            statusImgName = ""
            statusStr = ""
            listStatusStr = "代收款"
            step = 3
        case 4:
            btnTitle = "申请售后"
            needHideCancleBtn = true
            statusImgName = "order_status_success"
            statusStr = "订单交易已完成"
            listStatusStr = "已完成"
            step = 0
        case 5:
            btnTitle = ""
            needHideCancleBtn = true
            statusImgName = "order_status_success"
            statusStr = "售后服务中"
            listStatusStr = "售后中"
            step = 0
        case 6:
            btnTitle = "申请售后"
            needHideCancleBtn = true
            statusImgName = "order_status_success"
            statusStr = "订单交易已完成"
            listStatusStr = "已完成"
            step = 0
        case 7:
            btnTitle = "申请售后"
            needHideCancleBtn = true
            statusImgName = "order_status_success"
            statusStr = "订单交易已完成"
            listStatusStr = "已完成"
            step = 0
        case 8:
            btnTitle = "再次购买"
            needHideCancleBtn = true
            statusImgName = "order_status_cancle"
            statusStr = "订单交易已取消"
            listStatusStr = "已取消"
            step = 0
        case 9:
            btnTitle = ""
            needHideCancleBtn = true
            statusImgName = "order_status_success"
            statusStr = "售后服务中"
            listStatusStr = "售后中"
            step = 0
        default:
            btnTitle = ""
            needHideCancleBtn = true
            statusImgName = ""
            statusStr = ""
            step = 0
        }
        
        return(btnTitle,needHideCancleBtn,statusImgName,statusStr,listStatusStr,step)
    }
}

/*
 8.2查询订单明细
 */
class OrderDetailModel: HandyJSON {
    var id: Int? = 0    // 订单ID
    var orderNo: String? = ""
    var goodsCount: Int? = 0   //
    var amount: Double? = 0  //
    var payWay: Int? = 0    //
    var payStatus: Int? = 0
    var payTime: String? = ""
    var createTime: String? = ""
    var createUser: Int? = 0
    var orderStatus: Int? = 0
    var remark: String? = ""
    var customerCellphone: String? = ""  //
    var customerAddress: String? = ""    //
    var customer: UserModel?
    var customerName: String? = ""
    var orderDetails: [OrderDetailProductModel] = []
    var picturePaths:[String]? = []
    var serviceNo:String? = ""
    var afterSalesApplyId:Int? = 0
    var status:Int? = 0
    
    var isReturnable: Int = 0      // 申请售后  可退货退款
    var isExchangeable: Int = 0    // 申请售后  可换货
    var returnGoodsDays: Int = 0   // 支持退货天数
    var exchangeGoodsDays: Int = 0 // 支持换货天数
    
    required init() {}
    
    func transformToAfterSaleServiceInfofListItem() -> AfterSaleServiceInfofListItemModel{
        let afterSale = AfterSaleServiceInfofListItemModel()
        afterSale.serviceNo = self.serviceNo
        afterSale.orderId = self.id
        afterSale.id = self.afterSalesApplyId
        afterSale.orderNo = self.orderNo
        afterSale.dealStatus = 0
        afterSale.createTime = self.createTime
        afterSale.goodsAmount = self.goodsCount
        return afterSale
    }
}

class OrderDetailProductModel: HandyJSON {
    var id: Int? = 0 //产品ID
    var barCode: String? = ""
    var updateUser: String? = ""
    
    var productId: Int? = 0
    var createUser: String? = ""
    var createTime: String? = ""
    
    var originalPrice: Double? = 0.0
    var discountPrice: Double? = 0.0
    var price: Double? = 0.0     //
    
    var goodsId: Int? = 0
    var exchangeGoodsDays: Int? = 0
    var picturePath: String? = ""
    var updateTime: String? = ""
    
    var commission: Double? = 0
    var orderId: Int = 0
    var status: String? = ""
    var productName: String? = ""
    var returnGoodsDays: Int? = 0
    required init() {}
}

/*
 9.1查询售后列表
 */
class AfterSaleServiceInfofListModel: HandyJSON {
    var total: Int? = 0
    var list: [AfterSaleServiceInfofListItemModel]? = []
    required init() {}
}
class AfterSaleServiceInfofListItemModel: HandyJSON {
    var id: Int? = 0    // 售后ID
    var serviceNo: String? = ""
    var type: Int? = 0   // 售后类型 1:换货  2:退货
    var orderId: Int? = 0
    var orderNo: String? = ""
    var applyUser: Int? = 0
    var applyUserName: String? = ""
    var createTime: String? = ""  // 申请时间
    
    /*
     1 换货售后已申请
     2 换货售后已回收
     3 换货售后已关闭         换货扫码换新之后直接关闭售后
     4 换货售后已取消
     5 退货退款售后已申请
     6 退货退款售后已检查
     7 退货退款售后已回收     扫码回收之后直接进入待退款状态
     8 退货退款售后已关闭     退款成功之后直接关闭售后
     9 退货退款售后已取消
     10 退货退款售后已拒绝
     */
    var dealStatus: Int? = 0    // 处理状态
    var dealTime: String? = ""   // 处理时间
    var refundTime: String? = ""
    var remark: String? = ""
    var goodsAmount: Int? = 0
    required init() {}
    
    func configAfterSalesStatusInfo() -> (btnStr:String,isHiddenCancel:Bool,isHiddenScan:Bool,statusImgStr:String,statusStr:String,step:Int,markStrs:[String],listStatusStr:String,listMarkStr:String) {
        var needHideCancleBtn = true
        var needHideScanBtn = true
        var btnTitle = ""
        var statusImgName = ""
        var stausStr = ""
        var currentStep = 0
        var markStrs = [String]()
        var listStatusStr = ""
        var listMarkStr = ""
        switch self.dealStatus ?? 0 {
        case 1:
            needHideCancleBtn = false
            needHideScanBtn = false
            btnTitle = "扫码回收"
            statusImgName = ""
            stausStr = ""
            currentStep = 0
            markStrs = ["扫码回收","扫码换新"]
            listStatusStr = "换货"
            listMarkStr = "处理中"
        case 2:
            needHideCancleBtn = true
            needHideScanBtn = false
            btnTitle = "扫码换新"
            statusImgName = ""
            stausStr = ""
            currentStep = 1
            markStrs = ["扫码回收","扫码换新"]
            listStatusStr = "换货"
            listMarkStr = "处理中"
        case 5:
            needHideCancleBtn = false
            needHideScanBtn = false
            btnTitle = "退货检查"
            statusImgName = ""
            stausStr = ""
            currentStep = 0
            markStrs = ["退货检查","扫码回收","退款"]
            listStatusStr = "退货退款"
            listMarkStr = "处理中"
        case 6:
            needHideCancleBtn = false
            needHideScanBtn = false
            btnTitle = "扫码回收"
            statusImgName = ""
            stausStr = ""
            currentStep = 1
            markStrs = ["退货检查","扫码回收","退款"]
            listStatusStr = "退货退款"
            listMarkStr = "处理中"
        case 7:
            needHideCancleBtn = true
            needHideScanBtn = false
            btnTitle = "退款详情"
            statusImgName = ""
            stausStr = ""
            currentStep = 2
            markStrs = ["退货检查","扫码回收","退款"]
            listStatusStr = "退货退款"
            listMarkStr = "处理中"
        case 3:
            needHideCancleBtn = true
            needHideScanBtn = true
            btnTitle = ""
            statusImgName = "order_status_success"
            stausStr = "售后完成"
            listStatusStr = "换货"
            listMarkStr = "已完成"
        case 8:
            needHideCancleBtn = true
            needHideScanBtn = true
            btnTitle = ""
            statusImgName = "order_status_success"
            stausStr = "售后完成"
            listStatusStr = "退货退款"
            listMarkStr = "已完成"
        case 4:
            needHideCancleBtn = true
            needHideScanBtn = true
            btnTitle = ""
            statusImgName = "order_status_cancle"
            stausStr = "取消售后"
            listStatusStr = "换货"
            listMarkStr = "已取消"
        case 9:
            needHideCancleBtn = true
            needHideScanBtn = true
            btnTitle = ""
            statusImgName = "order_status_cancle"
            stausStr = "取消售后"
            listStatusStr = "退货退款"
            listMarkStr = "已取消"
        case 10:
            needHideCancleBtn = true
            needHideScanBtn = true
            btnTitle = ""
            statusImgName = "order_status_cancle"
            stausStr = "拒绝售后"
            listStatusStr = "退货退款"
            listMarkStr = "已拒绝"
        default:
            needHideCancleBtn = true
            needHideScanBtn = true
            btnTitle = ""
            statusImgName = ""
            stausStr = ""
            currentStep = 0
        }
         return(btnTitle,needHideCancleBtn,needHideScanBtn,statusImgName,stausStr,currentStep,markStrs,listStatusStr,listMarkStr)
    }
}

/*
 9.2查询单个售后信息 - AfterSaleServiceInfofListItemModel
 */
class AfterSaleServiceInfoModel: HandyJSON {
    var id: Int? = 0
    var serviceNo: String? = ""
    var type: Int? = 0
    var applyUserName: String? = ""
    var applyUser: Int? = 0
    var createTime:String? = ""
    var refundTime:String? = ""
    var applyTime:String? = ""
    var dealStatus: Int? = 0
    var dealTime: String? = ""
    var goodsCount: Int? = 0
    var remark: String? = ""
    var orderId: Int? = 0
    var orderNo: String? = ""
    var applyCellphone: String? = ""
    var address: String? = ""
    var amount: Double? = 0.0
    var orderDetails: [OrderDetailProductModel]? = []
    var order: OrderDetailModel?
    var picturePaths:[String]? = []
    required init() {}
    
    func creatOrderListItem() -> OrderInofListItemModel {
        let listItem = OrderInofListItemModel()
        listItem.id = self.order?.id
        listItem.orderNo = self.order?.orderNo
        listItem.goodsCount = self.order?.goodsCount
        listItem.amount = self.order?.amount
        listItem.payWay = self.order?.payWay
        listItem.payStatus = self.order?.payStatus
        listItem.payTime = self.order?.payTime
        listItem.createTime = self.order?.createTime
        listItem.createUser = self.order?.createUser
        listItem.orderStatus = self.order?.orderStatus
        listItem.picturePaths = self.order?.picturePaths
        return listItem
    }
}

/*
 9.4根据商品二维码查询已售出商品信息
 */

class GoodsBarcodeListModel: HandyJSON {
    var total: Int? = 0
    var list: [ProductModel]? = []
    required init() {}
}

/*
 9.10查询退款详情
 */
class RefundModel: HandyJSON {
    var refundId: Int? = 0
    var refundStats: Int? = 0
    var orderInfo: OrderDetailModel?    //
    
    required init() {}
}

/*
 11.1统计指定用户的库存情况
 */
class RefundPersonalStockModel: HandyJSON {
    var typeCount: Int? = 0    // 商品种类
    var totalCount: Int? = 0   // 商品库存
    required init() {}
}

/*
11.2库存明细
 */
class StockDetailsModel: HandyJSON {
    var total: Int? = 0
    var list: [StockDetailsItemModel]? = []
    required init() {}
}
class StockDetailsItemModel: HandyJSON {
    var id: Int? = 0    // 库存ID
    var createUser: Int? = 0  // 出库操作人
    var createUserName: String? = ""   //
    var createTime: String? = ""   // 出库时间
    var goodsId: Int? = 0
    
    /*
     1 未出库 该状态暂时不会使用到
     2 已出库 管理员扫码出库的状态
     3 已出售 商品已卖出
     4 换货回收 申请换货售后回收的旧商品状态
     5 退货回收 退货扫码回收之后的状态
     6 已入库  已出库、换货回收、退货回收、平级换入的商品才能进行入库，管理员扫码入库之后的商品状态
     7 换货换出 个人库存中的商品才能进行换货换出，换货售后进行新货扫码安装之后的状态
     8 平级换出 商品进行组内换货之后商品原拥有者的拥有该商品的状态
     9 平级换入 商品进行组内换货之后商品的新拥有者拥有该商品的状态
     */
    var currentStatus: Int? = 0
    var barCode: String? = ""
    var productId: Int? = 0
    var productName: String? = ""
    var picturePath: String? = ""
    required init() {}
}

/*
 11.3 统计产品维度的库存数据
 */
class ProductDimensionStockModel: HandyJSON {
    var total: Int? = 0
    var list: [ProductDimensionStockItemModel]? = []
    required init() {}
}
class ProductDimensionStockItemModel: HandyJSON {
    var productNo: String? = ""    //
    var stockCount: Int? = 0  //
    var productId: Int? = 0
    var productName: String? = ""
    var picturePath: String? = ""
    required init() {}
}

/*
 11.4产品库存明细
 */
class ProductStockDetailsModel: HandyJSON {
    var total: Int? = 0
    var list: [ProductStockDetailsItemModel]? = []
    required init() {}
}
class ProductStockDetailsItemModel: HandyJSON {
    var id: Int? = 0    // 商品ID
    var createUser: Int? = 0  // 出库操作人
    var createUserName: String? = ""   //
    var createTime: String? = ""   // 出库时间
    var stockId: Int? = 0      // 预出库ID
    var currentStatus: Int? = 0
    var barCode: String? = ""
    var productId: Int? = 0
    var productName: String? = ""
    var picturePath: String? = ""
    var operationDate:String? = ""
    var isBad:Int? = 0
    required init() {}
    
    func genOrderScanGoodsModel() -> OrderScanGoodsModel {
        let scanGoods = OrderScanGoodsModel()
        scanGoods.id = self.id
        scanGoods.barCode = self.barCode
        scanGoods.createTime = self.createTime
        scanGoods.currentStatus = self.currentStatus
        scanGoods.productId = self.productId
        scanGoods.productName = self.productName
        return scanGoods
    }
    
    func getCurrentStatusStr() -> String {
        var status = ""
        switch self.currentStatus ?? 0 {
        case 0:
            status = ""
        case 1:
            status = "未出库"
        case 2:
            status = "预出库"
        case 3:
            status = "售出"
        case 4:
            status = "换货退回"
        case 5:
            status = "退货退回"
        case 6:
            status = "退还库房"
        case 7:
            status = "换货换出"
        case 8:
            status = "平级换出"
        case 9:
            status = "平级换入"
        default:
            status = ""
        }
        return status
    }
}

/*
 11.5查询产品佣金列表
 */
class ProductCommissionListModel: HandyJSON {
    var total: Int? = 0
    var list: [ProductCommissionDetailsModel]? = []
    required init() {}
}

/*
 11.6查询产品佣金明细
 */

class ProductCommissionDetailsModel: HandyJSON{
    
    var id: Int? = 0 //产品ID
    var productNo: String? = ""
    var productName: String? = ""
    var groupId: Int? = 0
    var groupName: String? = ""
    var picturePath: String? = ""    // 图片地址
    var salePrice: Double? = 0.0     // 销售价 - 单位分
    var linePrice: Double? = 0.0     // 划线价 - 单位分
    var inventory: Int? = 0          // 库存
    var productType: Int? = 0
    var putawayTime: String? = ""        //上线时间
    var goodsId: Int? = 0        // 商品ID
    var currentStatus: Int = 0   // 当前状态
    var barCode: String? = ""    // 当前状态
    var price: Double? = 0       //当前售价
    var productId: Int? = 0      // 产品ID
    
    var commission: CommissionModel?    // 佣金
    var dialogue: [DialogueModel]?      // 销售场景模拟
    required init() {}
    
    func creatProductModel() -> ProductModel {
        let product = ProductModel()
        product.productNo = self.productNo
        product.productName = self.productName
        product.groupId = self.groupId
        product.groupName = self.groupName
        product.picturePath = self.picturePath
        product.salePrice = self.salePrice
        product.linePrice = self.linePrice
        product.inventory = self.inventory
        product.productType = self.productType
        product.putawayTime = self.putawayTime
        product.goodsId = self.goodsId
        product.currentStatus = self.currentStatus
        product.barCode = self.barCode
        product.price = self.price
        product.putawayTime = self.putawayTime
        product.productId = self.productId
        product.id = self.id
       
        return product
    }
}
class CommissionModel: HandyJSON {
    var id: Int = 0   // 佣金ID
    var ratio: Float? = 0    // 佣金比例
    var commission: Double? = 0       //
    var isRebate: Int? = 0      // 是否返佣
    required init() {}
}
class DialogueModel: HandyJSON {
    var id: Int? = 0 //场景ID
    var sceneName: String? = ""
    var sceneDescribe: String? = ""
    
    // 1 客户  2 员工
    var dialogue: String? = ""    // 对话内容
    // 处理过后的对话内容
    var messages:[Message]?
    required init() {}
}
class Message: NSObject {
    var incoming: Bool = false
    var text: String = ""
    
    init(incoming: Bool, text: String) {
        self.incoming = incoming
        self.text = text
    }
}

/*
 11.7组内库存统计
 */
class GroupStockListModel: HandyJSON {
    var total: Int? = 0
    var list: [ProductModel]? = []
    required init() {}
}

/*
 11.8组内库存明细
 */
class GroupStockDetailsModel: HandyJSON {
    var total: Int? = 0
    var list: [GroupStockDetailsItemModel]? = []
    required init() {}
}
class GroupStockDetailsItemModel: HandyJSON {
    var id: Int? = 0               //员工ID
    var employeeName: String? = ""
    var employeeNo: String? = ""
    var employeeType: Int? = 0
    var cellphone: String? = ""
    var Photo: String? = ""    //
    var stockCount: Int? = 0          // 库存
    required init() {}
}

/*
 12.1当月酬金统计
 */
class CurrentMonthModel: HandyJSON {
    var typeCount: Int? = 0
    var totalCount: Int? = 0
    required init() {}
}

/*
 12.2历史酬金统计记录
 */
class HistoryMonthModel: HandyJSON {
    var typeCount: Int? = 0
    var totalCount: Int? = 0
    required init() {}
}

/*
 12.3当月酬金
 */
class CommissionDetailsModel: HandyJSON {
    var settledAmount: Double? = 0
    var settlementAmount: Double? = 0
    required init() {}
}
///月度酬金历史
class CommissionMonthListModel: HandyJSON {
    var list:[CommissionMonthModel] = []
    required init() {}
}

class CommissionMonthModel: HandyJSON {
    var effectiveSingular: Int? = 0
    var totalSingular: Int? = 0
    var commissionIncome:Double? = 0
    var settlementMonth:String = ""
    required init() {}
}

///月度酬金明细
class CommissionModelDetailsList: HandyJSON {
    var list:[CommissionModelDetails] = []
    required init() {}
}

class CommissionModelDetails: HandyJSON {

    var settlementDay: String? = ""//时间
    var commission:Double? = 0//佣金
    var orderNo:String = "" //单号
    var orderStatus:Int = 0 //订单状态
    required init() {}
}


class CustomerInfo: HandyJSON {
    var id: Int?
    required init() {}
}


/*
 视屏展示list
 */
class MineVideoListModel: HandyJSON {
    var totalCount: Int? = 0 //总数
    var list: [MineVideoModel]? = [] //组列表
    required init() {}
}

/*
 视屏展示
 */
class MineVideoModel: HandyJSON {
    var vidoName: String = ""
    var vidoUrl: String = ""
    var imgUrl: String = ""
    var playTime: String = ""
    var id:Int = 0
    required init() {}
}

