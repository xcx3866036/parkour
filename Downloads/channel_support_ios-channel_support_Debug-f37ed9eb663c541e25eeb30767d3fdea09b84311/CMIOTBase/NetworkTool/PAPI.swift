//
//  AppDelegate.swift
//  CMIOTBase
//
//  Created by xcx on 2018/2/8.
//  Copyright © 2018年 xcx. All rights reserved.
//

import UIKit
import Moya
import HandyJSON
import MBProgressHUD
import SVProgressHUD
import SwiftyJSON
import SwiftyUserDefaults

let LoadingPlugin = NetworkActivityPlugin { (type, target) in
    switch type {
    case .began:
        SVProgressHUD.dismiss()
        SVProgressHUD.show()
//        MBProgressHUD.hide()
//        MBProgressHUD.show(nil)
    case .ended:
//        MBProgressHUD.hide()
        SVProgressHUD.dismiss()
    }
}

let timeoutClosure = {(endpoint: Endpoint<PAPI>, closure: MoyaProvider<PAPI>.RequestResultClosure) -> Void in
    
    if var urlRequest = try? endpoint.urlRequest() {
        urlRequest.timeoutInterval = 20
        closure(.success(urlRequest))
    } else {
        closure(.failure(MoyaError.requestMapping(endpoint.url)))
    }
}

let ApiProvider = MoyaProvider<PAPI>(requestClosure: timeoutClosure)

let ApiLoadingProvider = MoyaProvider<PAPI>(requestClosure: timeoutClosure, plugins: [LoadingPlugin])

///api
enum PAPI {
    
    ///登录
    ///loginName 用户名
    ///password 密码
    case login(loginName:String,
        password:String,
        messageCode:String,
        salt:String,
        longitude:Double,
        latitude:Double,
        location:String)
    
    ///获取短信验证码
    ///loginName 用户名
    case getMessageCode(loginName:String )
    
    ///找回密码
    ///loginName 用户名
    ///password 新密码
    ///messageCode 验证码
    case findPassword(loginName:String , password:String , messageCode:String)
    
    ///查询单个员工分组
    ///id 分组id
    case queryEmployeeGroup(id:Int)
    
    ///查询员工分组列表
    case queryEmployeeGroupList(inIds:[Int],likeGroupName:String)
    
    ///查询单个员工信息
    ///id 员工id
    case queryEmployeeInfo(id:Int)
    
    ///查询员工信息列表
    case queryEmployeeInfoList(groupId:Int)
    
    //搜索员工信息列表
    case searchEmployeeInfoList(likeEmployeeName:String)
    
    //搜索员工信息历史列表
    case historySearchEmployeeInfoList()
    
    ///查询单个产品分组
    /// 产品分组id
    case queryProductGroup(id:Int)
    
    ///查询产品分组列表
    case queryPreProductGroupList()
    
    ///查询单个产品
    ///产品id
    case queryProduct(id:Int)
    
    ///修改密码
    ///loginName 登录账号
    ///messageCode 短信验证码
    ///passworrd 新密码
    case resetPassword(loginName:String ,messageCode:String , passworrd:String)
    
    ///退出/注销账号
    case logout()
    
    ///修改头像
    ///photo 头像
    case modifyEmployrrPhoto(photo:String)
    
    ///修改手机号
    ///cellphone 手机号码
    ///messageCode 短信验证码
    ///password 登录密码
    case modifyemployeeCellPhone(cellphone:String,messageCode:String,password:String ,salt:String)
    
    ///当月销售情况
    case statisticsCurrentMonthSales()
    
    ///统计库存信息
    /// startDate 起始日期
    /// endDate 结束日期
    case statisticsStock(startDate:String , endDate:String)
    
    ///统计退换货数据
    /// startDate 起始日期
    /// endDate 结束日期
    case statisticsReture(startDate:String , endDate:String)
    
    ///退还货员工维度统计
    /// startDate 退还起始日期
    /// endDate 退还结束日期
    case statisticsEmployeeDimesionReture(startDate:String , endDate:String,queryCondition:[String:Any])
    
    ///退还货员工维度明细
    /// employeeId 员工id
    /// endDate 退还日期
    case queryRetureEmployeeDetails(employeeId:Int, endDate:String,queryCondition:[String:Any])
    
    ///预出库统计
    /// startDate 起始日期
    /// endDate 结束日期
    case statisticsOut(startDate:String , endDate:String)
    
    
    ///预出库员工维度统计
    /// startDate 起始日期
    /// endDate 结束日期
    case  statisticsEmployeeOut(startDate:String , endDate:String, queryCondition:[String:Any])
    
    
    ///预出库明细
    /// startDate 起始日期
    /// endDate 结束日期
    case statisticsEmployeeDimesionOut(employeeId:Int , operationDate:String,queryCondition:[String:Any])
    
    ///保存预出库信息
    ///owerId 拥有人ID
    ///outRecords 出库记录
    case createOutRecords(owerId:Int, outRecords:Array<Any>)
    
    ///通过二维码获取商品
    ///barCode 条形码
    ///productId 产品ID
    case queryGoods(barCode:String ,productId:Int)
    
    ///通过二维码获取已出库商品
    ///barCode 条形码
    ///productId 产品ID
    case queryOutGoods(barCode:String,productId:Int)
    
    ///通过二维码获取已售出商品信息
    ///barCode 条形码
    ///inCurrentStatuses 1:未出库 2:已出库 3:已售出 4:换货回收 5:退货回收 6:已入库 7:换货换出 8:平级换出 9:平级换入
    case querySaledGoods(inBarCodes:[String],orderId:Int,inCurrentStatuses:[Int])
    
    ///获取换货回收的商品
    ///id 售后id
   case exchangeBackGoodsList(id:Int)
    
    ///保存退换货信息
    /// returnRecords 还货记录
    case createReturnRecords(returnRecords:Array<Any>)
    
//    ///查询产品分组列表
//    ///inOrganizeIds 产品分组IDs
    case queryProductGroupList()
    
    ///查询特定分组产品列表
    case queryGroupProductList(groupId:Int)
    
    ///查询单个产品的详情
    ///id c产品id
    case queryProductDetail(id:Int)
    
    ///添加商品到购物车
    ///productId 产品ID
    ///productCount 下单数量
    ///totalAmount 产品金额
    case createCartItem(productId:Int , productCount:Int , totalAmount:Float)
    
    ///编辑商品到购物车
    ///productId 产品ID
    ///productCount 下单数量
    ///totalAmount 产品金额
    case modifyCartItem(productId:Int , productCount:Int , amount:Double)
    
    /// 清空购物车
    case deleteCartItem()
    
    ///查询购物车信息
    case queryCartItemList()
    
    ///查询顾客信息
    ///likeCellphone 手机号码
    case queryCustomerInfoList(likeCellphone:String)
    
    ///新增客户信息
    /// customerName 客户姓名
    /// cellphone 手机号码
    case createCustomerInfo(customerName:String , cellphone:String , provinceCode:String , cityCode:String , countyCode:String , address:String)
    
    ///修改客户信息
    /// id 顾客id
    /// customerName 客户姓名
    /// cellphone 手机号码
    case modifyCustomerInfo(id:Int,customerName:String , cellphone:String ,provinceCode:String , cityCode:String , countyCode:String , address:String)
    
    ///新增订单
    ///customer 客户id
    ///orderDetails 订单明细
    case createOrderInfo(customer:Int , orderDetails:Array<CartItemListItemModel>)
    
    ///新增订单明细
    ///orderId 订单id
    ///goodsIds 商品id
    case createOrderDetails(orderId:Int , goodsIds:Array<CartItemListItemModel>)
    
    ///获取微信支付二维码
    ///orderId 订单ID
    ///messageCode 商品ID
    case checkAcceptanceCode(orderId:Int ,messageCode:String)
    
    ///查询订单列表
    /// orderStatus 订单状态
    case queryOrderList(inOrderStatus:[Int],queryCondition:[String:Any])
    
    ///查询订单明细
    ///id 订单id
    case queryOrderDetail(id :Int)
    
    ///取消订单
    ///id 订单id
    case cancelOrder(id:Int,remark:String)
    
    ///修改订单备注
    ///
    case modifyOrderRemark(id:Int, remark:String)
    
    ///申请售后
    ///id 订单id
    ///type 售后类型
    case applyAfterSale(id:Int , type:Int, remark:String )
    
    ///查询售后列表
    ///type 售后类型
    ///dealStatus 售后处理状态
    case queryAfterSaleServiceInfoList(dealStatus:[Int],queryCondition:[String:Any])
    
    ///查询单个售后信息
    ///id 售后id
    case queryAfterSaleServiceInfo(id:Int)
    
    ///取消售后
    ///id 售后id
    case cancelAfterSale(id:Int, remark:String)
    
    ///查询商品二位码列表
    ///id 售后id
    case queryGoodsBarcodeList(id:Int)
    
    ///换货扫码回收
    ///id 商品id
    /// barCode 二维码
    case returnGoods(id:Int , goodsList:Array<Any>)
    
    ///换货
    ///id 售后id
    ///oldGoodsList 旧商品列表
    ///newGoodsList 新商品列表
    case replaceGoods(id :Int , replaceList:Array<Any>)
    
    ///拒绝售后
    ///id 售后id
    case refuseAfterSale(id :Int,remark:String)
    
    ///确认退货售后
    ///id 售后id
    case agreeReturnGoods(id:Int, operationType:Int)
    
    ///退货扫码回收
    ///id 售后id
    ///goodsList 商品列表
    case backGoods(id:Int , goodsList:Array<Any>)
    
    ///查询退款详情
    ///id 售后id
    case queryRefund(id:Int)
    
    
    ///统计指定用户的库存情况
    case statisticsPersonalStock()
    
    ///库存明细
    ///productId 产品ID
    ///flowStatus 库存状态
    case queryStockDetail(productId:Int , flowStatus:Int)
    
    ///统计产品维度的库存数据
    case statisticsProductDimensionStock(queryCondition:[String:Any])
    
    ///组内库存统计
    case statisticsGroupStockList(groupId:Int,queryCondition:[String:Any])
    
    ///库存明细
    ///productId 产品id
    ///goodsStatus 状态
    case queryStockDetails(productId:Int,goodsStatus:Int)
    
    
    ///产品库存明细
    ///productId 产品id
    ///goodsStatus 状态
    case queryProductStockDetails(productId:Int,goodsStatus:Int,queryCondition:[String:Any])
    
    ///组内库存明细
    case queryStatisticsGroupStockDetails(groupId:Int, productId:Int,queryCondition:[String:Any])
    
    ///查询产品佣金情况
    ///groupId 分组ID
    case queryProductInfoList(groupId:Int)
    
    ///查询产品佣金列表
    case queryProductCommissionList(groupId:Int,queryCondition:[String:Any])
    
    ///查询产品佣金明细
    ///productID 产品id
    case queryProductDetails(productId:Int)
    
    ///组内库存详情
    /// groupId 员工组ID
    case statisticsGroupStockInfo(groupId:Int)
    
    ///组内换货
    ///goodIds 商品id
    case exchangeGoods(goodsIds:[Int])
    
    ///我的酬金
    case statisticsCurrentMonth()
    
    ///历史酬金统计记录
    case statisticsHistoryMonth(settlementYear:String)
    
    ///酬金明细
    case queryCommissionDetails(date:String)
    
    ///二维码获取已出库商品
    case queryCurrentHolderOutedGoods(barCode:String)
    ///发送订单验证码
    case sendMsgCode(orderId:Int)
    ///验证验证码
    case checkMsgCode(orderId:Int , msgCode:String)
    
//    ///获取微信二维码
//    case checkAcceptanceCode(orderId:Int , messageCode:String)
    case modifyOrderDetail(orderId:Int,goodsIds:[Int])
    ///获取支付链接
    case getPayUrl(orderId:Int)
    ///查询支付状态
    case queryPayStatus(orderId:Int)
    ///搜索
    case queryProductList(likeProductName:String)
    ///结算中明细
    case querySettletingCommissionDetails()
    ///月明细
    case queryMonthSettletedCommissionDetails()
    ///获取视频URL
    case queryVidoUrlList()
}

extension PAPI: TargetType {

    var baseURL: URL { return URL(string: CHBaseUrl)! }
    
    var path: String {
        switch self{
        case .login(_,_,_,_,_,_,_) :
            return "index/login"
        case .getMessageCode(_):
           return "index/get-message-code"
        case .findPassword(_, _, _):
            return "index/find-password"
        case .queryEmployeeGroup(_):
            return "employee/query-employee-group"
        case .queryEmployeeGroupList(_,_):
            return "employee/query-employee-group-list"
        case .queryEmployeeInfo(_):
            return "employee/query-employee-info"
        case .queryEmployeeInfoList(_):
            return "employee/query-employee-info-list"
        case .searchEmployeeInfoList(_):
            return "employee/query-employee-info-list"
        case .historySearchEmployeeInfoList():
            return "employee/query-employee-info-list"
        case .queryProductGroup(_):
            return "/product/query-product-group"
        case .queryProductGroupList:
            return "product/query-product-group-list"
        case .queryPreProductGroupList:
            return "product/query-product-group-list"
        case .queryProduct(_):
            return "product/query-product"
        case .resetPassword(_, _,_):
            return "index/reset-password"
        case .logout:
            return "index/logout"
        case .modifyEmployrrPhoto(_):
            return "index/modify-employee-photo"
        case .modifyemployeeCellPhone(_, _, _,_):
            return "/index/modify-employee-cellphone"
        case .statisticsCurrentMonthSales:
            return "statistics/statistics-current-month-sales"
        case .statisticsStock(_, _):
            return "stock/statistics-stock"
        case .statisticsReture(_, _):
            return "stock/statistics-return"
        case .statisticsEmployeeDimesionReture(_,_,_):
            return "stock/statistics-employee-return"
        case .queryRetureEmployeeDetails(_, _,_):
            return "stock/query-return-detail-list"
        case .statisticsOut(_, _):
            return "stock/statistics-out"
        case .statisticsEmployeeDimesionOut(_, _,_):
            return "stock/query-out-detail-list"
        case .statisticsEmployeeOut(_, _, _):
            return "stock/statistics-employee-out"
        case .createOutRecords(_, _):
            return "stock/create-out-records"
        case .queryGoods(_,_):
            return "goods/query-unout-goods"
        case .createReturnRecords(_):
            return "stock/create-return-records"
        case .queryOutGoods(_,_):
            return "goods/query-outed-goods"
        case .querySaledGoods(_,_,_):
            return "goods/query-order-goods-list"
        case .exchangeBackGoodsList(_):
            return "after-sale/query-exchange-back-goods-list"
        case .queryProductList(_):
            return "product/query-product-list"
        case .queryGroupProductList(_):
            return "product/query-product-list"
        case .queryProductDetail(_):
            return "product/query-product"
        case .createCartItem(_,_,_):
            return "cart-item/create-cart-item"
        case .modifyCartItem(_,_,_):
            return "cart-item/modify-cart-item"
        case .deleteCartItem():
            return "cart-item/delete-cart-item"
        case .queryCartItemList:
            return "cart-item/query-cart-item-list"
        case .queryCustomerInfoList(_):
            return "customer-info/query-customer-info-list"
        case .createCustomerInfo(_,_,_,_,_,_):
            return "customer-info/create-customer-info"
        case .modifyCustomerInfo(_,_,_, _,_,_,_):
            return "customer-info/modify-customer-info"
        case .createOrderInfo(_,_):
            return "order/create-order"
        case .createOrderDetails(_,_):
            return "order/create-order-details"
        case .checkAcceptanceCode(_,_):
            return "order/check-acceptance-code"
        case .queryOrderList(_,_):
            return "order/query-order-list"
        case .queryOrderDetail(_):
            return "order/query-order-detail"
        case .cancelOrder(_,_):
            return "order/cancel-order"
        case .modifyOrderRemark(_,_):
            return "order/modify-order-remark"
        case .applyAfterSale(_,_,_):
            return "after-sale/apply-after-sale"
        case .queryAfterSaleServiceInfoList(_,_):
            return "after-sale/query-after-sale-list"
        case .queryAfterSaleServiceInfo(_):
            return "after-sale/query-after-sale-info"
        case .cancelAfterSale(_,_):
            return "after-sale/cancel-after-sale"
        case .queryGoodsBarcodeList(_):
            return "after-sale/query-goods-barcode-list"
        case .returnGoods(_,_):
            return "after-sale/return-goods"
        case .replaceGoods(_,_):
            return "after-sale/replace-goods"
        case .refuseAfterSale(_,_):
            return "after-sale/refuse-after-sale"
        case .agreeReturnGoods(_,_):
            return "after-sale/agree-back-goods"
        case .backGoods(_,_):
            return "after-sale/back-goods"
        case .queryRefund(_):
            return "after-sale/query-refund"
        case .statisticsPersonalStock:
            return "personal-stock/statistics-personal-stock"
        case .queryStockDetail(_, _):
            return "personal-stock/query-stock-details"
        case .statisticsProductDimensionStock(_):
            return "personal-stock/statistics-product-stock"
        case .statisticsGroupStockList(_,_):
            return "personal-stock/statistics-group-stock-list"
        case .queryStockDetails(_,_):
            return "personal-stock/query-stock-detail-list"
        case .queryProductStockDetails(_,_,_):
            return "personal-stock/query-product-stock-detail-list"
        case .queryStatisticsGroupStockDetails(_,_,_):
            return "personal-stock/statistics-group-stock-detail-list"
        case .queryProductInfoList(_):
            return "commission/query-product-info-list"
        case .queryProductCommissionList(_,_):
            return "personal-stock/query-product-commission-list"
        case .queryProductDetails(_):
            return "personal-stock/query-commission-details"
        case .statisticsGroupStockInfo(_):
            return "personal-stock/statistics-group-stock-info"
        case .exchangeGoods(_):
            return "personal-stock/exchange-goods-holder"
        case .statisticsCurrentMonth:
            return "commission/statistics-current-month"
        case .statisticsHistoryMonth(_):
            return "commission/statistics-history-month"
        case .queryCommissionDetails(_):
            return "commission/query-month-settleted-commission-details"
        case .queryCurrentHolderOutedGoods(_):
            return "goods/query-current-holder-outed-goods"
        case .sendMsgCode(_):
            return "order/send-msg-code"
        case .checkMsgCode(_, _):
            return "order/check-msg-code"
        case .modifyOrderDetail:
           return "order/modify-order-detail"
        case .getPayUrl(_):
            return "order/get-pay-url"
        case .queryPayStatus(_):
            return "order/query-pay-status"
        case  .querySettletingCommissionDetails():
            return "commission/query-settleting-commission-details"
        case .queryMonthSettletedCommissionDetails():
            return "commission/query-month-settleted-commission-details"
        case .queryVidoUrlList():
            return "vido/query-vido-url-list"
        }
        
    }
    
    
    var method: Moya.Method { return .post }
    var task: Task {
        let user = UserModel.read()
        var parmeters = [String : Any]()
        parmeters = ["currentUser": user?.id ?? 0,
                     "organizeId":user?.organizeId ?? 0]
        
        var dic:Dictionary = [String: Any]()
        
        switch self {
        case .login(let loginName, let password,let messageCode, let salt,let longitude, let latitude,let location):
            dic["loginName"] = loginName
            dic["password"] = password
            dic["loginWay"] = 2
            dic["location"] = location
            dic["messageCode"] = messageCode
            dic["versionNum"] = appVersion
            dic["salt"] = salt
            dic["longitude"] = longitude
            dic["latitude"] = latitude
            dic["cellphoneId"] = deviceUUID
            dic["cellphoneInfo"] = deviceModel + "," + sysVersion
        
            return .requestParameters(parameters: dic, encoding: JSONEncoding.default)
        case .getMessageCode(let loginName):
            dic["loginName"] = loginName

            return .requestParameters(parameters: dic, encoding: JSONEncoding.default)
        case .findPassword(let loginName, let password, let messageCode):
            dic["loginName"] = loginName
            dic["password"] = password
            dic["messageCode"] = messageCode
            return .requestParameters(parameters: dic, encoding: JSONEncoding.default)
            
        case .queryEmployeeGroup(let id):
            parmeters["id"] = id
            
        case .queryEmployeeGroupList(let inIds,let likeGroupName):
            dic["inIds"] = inIds
            dic["likeGroupName"] = likeGroupName
            
        case .queryEmployeeInfo(let id):
            parmeters["id"] = id
            
        case .queryEmployeeInfoList(let groupId):
             parmeters["groupId"] = groupId
            
        case .searchEmployeeInfoList(let likeEmployeeName):
            parmeters["likeEmployeeName"] = likeEmployeeName
           
        case .historySearchEmployeeInfoList():
            break
            
        case .queryProductGroup(let id):
            parmeters["id"] = id
        case .queryProductGroupList:
            break
        case .queryPreProductGroupList:
            break
        case .queryProduct(let id):
            parmeters["id"] = id
        case .resetPassword(let loginName, let messageCode , let passWord):
            parmeters["loginName"] = loginName
            parmeters["messageCode"] = messageCode
            parmeters["password"] = passWord
        case .logout:
            break
        case .modifyEmployrrPhoto(let photo):
            parmeters["photo"] = photo
        case .modifyemployeeCellPhone(let cellphone, let messageCode, let password,let salt):
            parmeters["cellphone"] = cellphone
            parmeters["messageCode"] = messageCode
            parmeters["password"] = password
            parmeters["salt"] = salt

        case .statisticsCurrentMonthSales():
           break

        case .statisticsStock(let startDate, let endDate):
            parmeters["startDate"] = startDate
            parmeters["endDate"] = endDate
        case .statisticsReture(let startDate, let endDate):
            parmeters["startDate"] = startDate
            parmeters["endDate"] = endDate
        case .statisticsEmployeeDimesionReture(let startDate, let endDate, let queryCondition):
            parmeters["startDate"] = startDate
            parmeters["endDate"] = endDate
            parmeters["queryCondition"] = queryCondition
        case .queryRetureEmployeeDetails(let employeeId, let endDate, let queryCondition):
            parmeters["employeeId"] = employeeId
            parmeters["operationDate"] = endDate
            parmeters["queryCondition"] = queryCondition
        case .statisticsOut(let startDate, let endDate):
            parmeters["startDate"] = startDate
            parmeters["endDate"] = endDate
        case .statisticsEmployeeDimesionOut(let employeeId, let operationDate, let queryCondition):
            parmeters["employeeId"] = employeeId
            parmeters["operationDate"] = operationDate
            parmeters["queryCondition"] = queryCondition
        case .statisticsEmployeeOut(let startDate, let endDate, let queryCondition):
            parmeters["startDate"] = startDate
            parmeters["endDate"] = endDate
            parmeters["queryCondition"] = queryCondition
        case .createOutRecords(let owerId, let outRecords):
            parmeters["currentHolder"] = owerId
            parmeters["outRecords"] = outRecords
        case .queryGoods(let barCode, let productId):
            parmeters["barCode"] = barCode
            parmeters["productId"] = productId
        case .createReturnRecords(let returnRecords):
            parmeters["returnRecords"] = returnRecords
        case .queryOutGoods(let barCode,let productId):
            if productId >= 0 {
                parmeters["productId"] = productId
            }
            parmeters["barCode"] = barCode
        case .querySaledGoods(let inBarCodes, let orderId, let inCurrentStatuses):
            if inBarCodes.count > 0 {
                 parmeters["inBarCodes"] = inBarCodes
            }
            parmeters["orderId"] = orderId
            parmeters["inCurrentStatuses"] = inCurrentStatuses
        case .exchangeBackGoodsList(let id):
            parmeters["id"] = id
        case .queryProductList(let likeProductName):
            parmeters["likeProductName"] = likeProductName
            
        case .queryGroupProductList(let groupId):
            parmeters["inProductGroupIds"] = [groupId]
            
        case .queryProductDetail(let id):
            parmeters["id"] = id
        case .createCartItem(let productId, let productCount, let totalAmount):
            parmeters["productId"] = productId
            parmeters["productCount"] = productCount
            parmeters["totalAmount"] = totalAmount
            
        case .modifyCartItem(let productId, let productCount, let amount):
            parmeters["productId"] = productId
            parmeters["productCount"] = productCount
            parmeters["amount"] = amount
        case .deleteCartItem():
            break
        case .queryCartItemList:
            break
        case .queryCustomerInfoList(let likeCellphone):
            parmeters["likeCellphone"] = likeCellphone
        case .createCustomerInfo(let customerName, let cellphone , let provinceCode , let cityCode , let countyCode , let adress):
            parmeters["cellphone"] = cellphone
            parmeters["customerName"] = customerName
            
            parmeters["provinceCode"] = provinceCode
            parmeters["cityCode"] = cityCode
            
            parmeters["countyCode"] = countyCode
            parmeters["address"] = adress
        case .modifyCustomerInfo(let id, let customerName, let cellphone, let provinceCode , let cityCode , let countyCode , let adress):
            parmeters["id"] = id
            parmeters["customerName"] = customerName
            parmeters["cellphone"] = cellphone
            parmeters["provinceCode"] = provinceCode
            parmeters["cityCode"] = cityCode
            
            parmeters["countyCode"] = countyCode
            parmeters["address"] = adress
        case .createOrderInfo(let customer, let orderDetails):

            struct OrderProgram: HandyJSON {
                var customer: Int?
                var currentUser:Int?
                var organizeId:Int?
                var orderDetails: [CartItemListItemModel]?
                
            }

            var param = OrderProgram()
            param.customer = customer
            param.orderDetails = orderDetails
            param.currentUser = UserModel.read()?.id
            param.organizeId = UserModel.read()?.organizeId
            parmeters = param.toJSON() ?? [String: Any]()
            
           
        case .createOrderDetails(let orderId, let goodsIds):
            parmeters["orderId"] = orderId
            parmeters["goodsIds"] = goodsIds
        case .checkAcceptanceCode(let orderId, let messageCode):
            parmeters["orderId"] = orderId
            parmeters["messageCode"] = messageCode
        case .queryOrderList(let orderStatus, let queryCondition):
            parmeters["inOrderStatus"] = orderStatus
            parmeters["queryCondition"] = queryCondition
        case .queryOrderDetail(let id):
            parmeters["id"] = id
        case .cancelOrder(let id, let remark):
            parmeters["id"] = id
            parmeters["remark"] = remark
        case .modifyOrderRemark(let id, let remark):
            parmeters["id"] = id
            parmeters["remark"] = remark
        case .applyAfterSale(let id, let type, let remark):
            parmeters["id"] = id
            parmeters["type"] = type
            parmeters["remark"] = remark
        case .queryAfterSaleServiceInfoList(let dealStatus, let queryCondition):
            parmeters["inDealStatuses"] = dealStatus
            parmeters["queryCondition"] = queryCondition
        case .queryAfterSaleServiceInfo(let id):
            parmeters["id"] = id
        case .cancelAfterSale(let id, let remark):
            parmeters["id"] = id
            parmeters["remark"] = remark
        case .queryGoodsBarcodeList(let id):
            parmeters["id"] = id
        case .returnGoods(let id, let goodsList):
            parmeters["id"] = id
            parmeters["goodsIds"] = goodsList
        case .replaceGoods(let id, let replaceList):
            parmeters["id"] = id
            parmeters["replaceList"] = replaceList
            
        case .refuseAfterSale(let id, let remark):
            parmeters["id"] = id
            parmeters["remark"] = remark
            
        case .agreeReturnGoods(let id, let operationType):
            parmeters["id"] = id
            parmeters["operationType"] = operationType
        case .backGoods(let id, let goodsList):
            parmeters["id"] = id
            parmeters["goodsIds"] = goodsList
        case .queryRefund(let id):
            parmeters["id"] = id
        case .statisticsPersonalStock():
            break
        case .queryStockDetail(let productId, let flowStatus):
            parmeters["productId"] = productId
            parmeters["flowStatus"] = flowStatus
            
        case .statisticsProductDimensionStock(let queryCondition):
            parmeters["queryCondition"] = queryCondition
           break
            
        case .statisticsGroupStockList(let groupId, let queryCondition):
            if groupId >= 0 {
               parmeters["groupId"] = groupId
            }
            parmeters["queryCondition"] = queryCondition
            
        case .queryStockDetails(let productId, let goodsStatus):
            if productId >= 0 {
                parmeters["productId"] = productId
            }
            if goodsStatus >= 0 {
                parmeters["currentStatus"] = goodsStatus
            }
            
        case .queryProductStockDetails(let productId, let goodsStatus, let queryCondition):
            if productId >= 0 {
                parmeters["productId"] = productId
            }
            if goodsStatus >= 0 {
                parmeters["currentStatus"] = goodsStatus
            }
            parmeters["queryCondition"] = queryCondition
        case .queryStatisticsGroupStockDetails(let groupId,let productId, let queryCondition):
            parmeters["productId"] = productId
            parmeters["groupId"] = groupId
            parmeters["queryCondition"] = queryCondition
        case .queryProductInfoList(let groupId):
            parmeters["groupId"] = groupId
            
        case .queryProductCommissionList(let groupId, let queryCondition):
            parmeters["groupId"] = groupId
            parmeters["queryCondition"] = queryCondition
           
        case .queryProductDetails(let productId):
            parmeters["productId"] = productId
            
        case .statisticsGroupStockInfo(let groupId):
            parmeters["groupId"] = groupId
            
        case .exchangeGoods(let goodIds):
            parmeters["goodsIds"] = goodIds
            
        case .statisticsCurrentMonth:
            parmeters["settlementUser"] = UserModel.read()?.id ?? ""
            parmeters["currentUser"] = ""
        case .statisticsHistoryMonth(let settlementYear):
            parmeters["settlementUser"] = UserModel.read()?.id ?? ""
            parmeters["currentUser"] = ""
            let dateformatter = DateFormatter()
            
            dateformatter.dateFormat = "YYYY"
            
            let time = dateformatter.string(from: Date())

            parmeters["settlementYear"] = time
            if(settlementYear != ""){
                parmeters["settlementYear"] = settlementYear
            }
            break
        case .queryCommissionDetails(let date):
            parmeters["settlementUser"] = UserModel.read()?.id ?? ""
            parmeters["settlementYearMonth"] = date
            break
        case .queryCurrentHolderOutedGoods(let barCode):
            parmeters["barCode"] = barCode
        case .sendMsgCode(let orderId):
            parmeters["orderId"] = orderId
        case .checkMsgCode(let orderId, let msgCode):
            parmeters["orderId"] = orderId
            parmeters["msgCode"] = msgCode
        case .modifyOrderDetail(let orderId, let goodsIds):
            print("\(orderId),\(goodsIds)")
            parmeters["orderId"] = orderId
            parmeters["goodsIds"] = goodsIds
        case .getPayUrl(let orderId):
            print("\(orderId)")
            parmeters["orderId"] = orderId
            parmeters["payWay"] = Int("6")
        case .queryPayStatus(let orderId):
            parmeters["orderId"] = orderId
        case .querySettletingCommissionDetails:
            parmeters["settlementUser"] = UserModel.read()?.id ?? ""
            parmeters["currentUser"] = ""
        case .queryMonthSettletedCommissionDetails:
            parmeters["settlementUser"] = UserModel.read()?.id ?? ""
            parmeters["currentUser"] = ""
        case .queryVidoUrlList: break
            
        }
        
        
        
        return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
    }
    
    var sampleData: Data {
//        switch self {
//            case .queryProductList()
//                return "{\"returnCode\" : \"1\",\"returnMsg\" : \"成功\",\"details\": {\"total\": \"100\",\"list\": [{\"id\" : \"1\" ,\"productName\" : \"和目HN45POE交换机 中国移动 和目HN45POE交换机\",\"productNo\" : \"1\",\"groupId\" : 1,\"groupName\" : \"和电器\",\"picturePath\" : \"http://www.zhipinmall.com:8083/null/1/779/9c1f2f7873614f0b85f3af16d5ba1b7c.jpg\",\"salePrice\" : 126.00,\"linePrice\" : 180.00}]}}"
//        default :
            return "".data(using: String.Encoding.utf8)!
        //}
        
        
    }
    var headers: [String : String]? {
        var header: [String:String] = ["Content-Type":"application/json"]
        switch self {
        case .login(_,_,_, _,_, _,_):
            return header
        case .getMessageCode(_):
            return header
        case .findPassword(_, _, _):
            return header
        default:
            let token = Defaults[.token] ?? ""
            print("Token: " + token)
            header["Access-Token"] = token
            return header
        }

    }
}



