//
//  UIView+Art.h
//  DesignBox
//
//  Created by zhaoguogang on 8/13/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ALi)

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat originX;
@property (nonatomic, assign) CGFloat originY;
@property (nonatomic, assign) CGPoint leftTop;
@property (nonatomic, assign) CGPoint rightTop;
@property (nonatomic, assign) CGPoint leftBottom;
@property (nonatomic, assign) CGPoint rightBottom;

@end

