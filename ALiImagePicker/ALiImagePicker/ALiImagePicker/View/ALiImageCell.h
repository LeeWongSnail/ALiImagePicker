//
//  ALiImageCell.h
//  ALiImagePicker
//
//  Created by LeeWong on 2016/10/17.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ALiAsset;

@protocol ALiImageCellDelegate <NSObject>

- (void)imageDidSelect:(ALiAsset *)asset select:(BOOL)isSelect;

@end

@interface ALiImageCell : UICollectionViewCell

@property (nonatomic, weak) id <ALiImageCellDelegate> delegate;

- (void)configImageCell:(ALiAsset *)asset;

@end
