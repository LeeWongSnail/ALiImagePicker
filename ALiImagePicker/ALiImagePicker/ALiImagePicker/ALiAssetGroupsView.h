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

@protocol ArtAssetGroupsViewDelegate <NSObject>
@optional
- (void)assetsGroupsViewDidCancel:(ALiAssetGroupsView *)groupsView;
- (void)assetsGroupsView:(ALiAssetGroupsView *)groupsView didSelectAssetsGroup:(PHCollection *)assGroup;

@end

@interface ALiAssetGroupsView : UIView

@property (nonatomic, weak) id<ArtAssetGroupsViewDelegate>  delegate;
@property (nonatomic, assign) NSInteger indexAssetsGroup;
@property (nonatomic, strong) NSArray *assetsGroups;
@property (nonatomic, strong) NSMutableDictionary *selectedAssetCount;

- (void)removeAssetSelected:(ALiAsset *)asset;
- (void)addAssetSelected:(ALiAsset *)asset;

@end


