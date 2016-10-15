//
//  ArtAssetGroupCell.h
//  DesignBox
//
//  Created by leoliu on 15/8/28.
//  Copyright (c) 2015年 GK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ALiAssetGroupCell : UITableViewCell

@property (nonatomic, strong) PHCollection *assetsGroup;
@property (nonatomic, assign) BOOL   isSelected;

@end
