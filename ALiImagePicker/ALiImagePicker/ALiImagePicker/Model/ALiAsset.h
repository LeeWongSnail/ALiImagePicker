//
//  ALiAsset.h
//  ALiImagePicker
//
//  Created by LeeWong on 2016/10/15.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALiAsset : NSObject

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, assign, getter=isFullImage) BOOL fullImage;   //是否选择的原图
@property (nonatomic, assign, getter=isSelected) BOOL selected;      //是否被选中


@end
