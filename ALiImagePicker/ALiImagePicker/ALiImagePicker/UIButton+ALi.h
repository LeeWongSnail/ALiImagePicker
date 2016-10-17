//
//  UIButton+ALi.h
//  ALiImagePicker
//
//  Created by LeeWong on 2016/10/17.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EArtButtonImagePosition) {
    EArtButtonImagePositionLeft = 0,              //图片在左，文字在右，默认
    EArtButtonImagePositionRight = 1,             //图片在右，文字在左
    EArtButtonImagePositionTop = 2,               //图片在上，文字在下
    EArtButtonImagePositionBottom = 3,            //图片在下，文字在上
};


@interface UIButton (ALi)

/**
 *  利用UIButton的titleEdgeInsets和imageEdgeInsets来实现文字和图片的自由排列
 *  注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing
 *
 *  @param spacing 图片和文字的间隔
 */
- (void)adjustImagePosition:(EArtButtonImagePosition)postion spacing:(CGFloat)spacing;

@end
