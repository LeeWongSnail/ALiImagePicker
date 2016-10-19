//
//  ALiSingleImageController.h
//  ALiImagePicker
//
//  Created by LeeWong on 2016/10/19.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ALiAsset;

@interface ALiSingleImageController : UIViewController

@property (nonatomic, strong) NSMutableArray *selectedAsset;

@property (nonatomic, assign) NSInteger curIndex;

@property (nonatomic, strong) ALiAsset *asset;

@property (nonatomic, strong) NSMutableArray *allAssets;

@property (nonatomic, copy) void (^photoChooseBlock)(NSArray *selectAssets);

@end
