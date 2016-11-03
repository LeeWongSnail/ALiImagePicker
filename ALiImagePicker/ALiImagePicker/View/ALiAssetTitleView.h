//
//  ALiAssetTitleView.h
//  ALiImagePicker
//
//  Created by LeeWong on 2016/11/3.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALiAssetTitleView : UIView

@property (nonatomic, strong) UIButton *titleButton;

@property (nonatomic, strong) UIButton *arrowBtn;

@property (nonatomic, copy) void (^titleViewDidClick)();

@end
