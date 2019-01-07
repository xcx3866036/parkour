//
//  APIService.swift
//  CMIOTBase
//
//  Created by xcx on 2018/2/28.
//  Copyright © 2018年 xcx. All rights reserved.
//

import HandyJSON
import Moya
import MBProgressHUD
import SwiftyJSON

extension Response {
    func mapModel<T: HandyJSON>(_ type: T.Type) throws -> T {
        let jsonString = String(data: data, encoding: .utf8)
        guard let model = JSONDeserializer<T>.deserializeFrom(json: jsonString) else {
            throw MoyaError.jsonMapping(self)
        }
        return model
    }
}

extension MoyaProvider {
    @discardableResult
    open func request<T: HandyJSON>(_ target: Target,
                                    model: T.Type,
                                    completion: @escaping (T?, (Int,String,NSError?)) -> Void) -> Cancellable? {
        
        
        return request(target, completion: { result in
            
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                
                let jsonString = String(data: data, encoding: .utf8)
                guard let model = JSONDeserializer<returnData<T>>.deserializeFrom(json: jsonString) else {
                    return
                }

                if let dict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                    print(target.path + ":")
                    print(JSON(dict))
                }
                if model.returnCode == 1 {
                     completion(model.details,(1,model.returnMsg ?? "",nil))
                }
                // 登录已过期，请重新登录!
                else if model.returnCode == -201{
                    relogin()
                }
                else{
                    let err = NSError(domain: "APIService.error", code: model.returnCode, userInfo: [NSLocalizedDescriptionKey: model.returnMsg ?? ""])
                    completion(model.details,(model.returnCode,model.returnMsg ?? "",err))
                }
                
            case let .failure(error):
                let err = NSError(domain: "APIService.error", code: 2, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription])
                completion(nil, (2,"",err))
            }

        })
    }
}


struct returnData<T: HandyJSON>: HandyJSON {
    var returnCode: Int = 0
    var returnMsg:String?
    var details: T?
}

struct ModelData: HandyJSON {}
extension Array: HandyJSON{}

