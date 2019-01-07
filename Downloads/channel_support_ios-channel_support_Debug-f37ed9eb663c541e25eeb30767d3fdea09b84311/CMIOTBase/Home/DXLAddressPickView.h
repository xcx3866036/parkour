//
//  DXLAddressPickView.h
//  DXLAddressView
//
//  Created by ding on 2017/12/29.
//  Copyright © 2017年 ding. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kWidth ([UIScreen mainScreen].bounds.size.width)
#define kHeight ([UIScreen mainScreen].bounds.size.height)


typedef void(^determineBtnActionBlock)(NSString *shengId, NSString *shiId, NSString *xianId, NSString *shengName, NSString *shiName, NSString *xianName);

@interface DXLAddressPickView : UIView

@property (nonatomic, copy) determineBtnActionBlock determineBtnBlock;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)show;
- (void)showWithProvince:(NSString *)province city:(NSString *)city county:(NSString *)county;
- (void)dismiss;












@end
