//
//  ArtAssetGroupsView.h
//  DesignBox
//
//  Created by leoliu on 15/8/28.
//  Copyright (c) 2015年 GK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ALiAsset.h"

@class ALiAssetGroupsView;

@interface ALiAssetGroupsView : UIView

@property (nonatomic, strong) UIButton *touchButton;
@property (nonatomic, assign) NSInteger indexAssetsGroup;
@property (nonatomic, strong) PHFetchResult *assetsGroups;
@property (nonatomic, strong) NSMutableDictionary *selectedAssetCount;



@end


