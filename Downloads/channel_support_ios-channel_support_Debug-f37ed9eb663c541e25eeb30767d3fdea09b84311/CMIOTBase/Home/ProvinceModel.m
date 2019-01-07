//
//  ProvinceModel.m
//  DXLAddressView
//
//  Created by ding on 2017/12/29.
//  Copyright © 2017年 ding. All rights reserved.
//

#import "ProvinceModel.h"

@implementation ProvinceModel
+ (instancetype)showDataWith:(NSDictionary *)dict
{
    ProvinceModel *model = [[ProvinceModel alloc] init];
    model.name = dict[@"areaName"];
    model.code = dict[@"areaId"];
    
    NSArray *arrayT = [dict objectForKey:@"children"];
    NSMutableArray *data = [[NSMutableArray alloc] init];
    [arrayT enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CityModel *Models = [CityModel showCityDataWith:obj];
        [data addObject:Models];
    }];
    model.city = data;
    return model;
}
@end
