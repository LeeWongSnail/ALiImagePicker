//
//  ALiImageBrowserController.h
//  ALiImagePicker
//
//  Created by LeeWong on 2016/10/18.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ALiAsset;

@interface ALiImageBrowserController : UIViewController

@property (nonatomic, strong) NSMutableArray *selectedAsset;

@property (nonatomic, assign) NSInteger curIndex;


@property (nonatomic, strong) NSMutableArray *allAssets;

@property (nonatomic, copy) void (^photoChooseBlock)(NSArray *selectAssets);

@end
