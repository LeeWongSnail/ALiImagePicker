//
//  UIView+Art.m
//  DesignBox
//
//  Created by zhaoguogang on 8/13/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import "UIView+ALi.h"
#import <objc/runtime.h>

@implementation UIView (ALi)

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    self.frame = CGRectMake(self.originX, self.originY, size.width, size.height);
}

- (CGFloat)originX {
    return self.frame.origin.x;
}

- (void)setOriginX:(CGFloat)originX {
    self.frame = CGRectMake(originX, self.originY, self.size.width, self.size.height);
}

- (CGFloat)originY
{
    return self.frame.origin.y;
}

- (void)setOriginY:(CGFloat)originY {
    self.frame = CGRectMake(self.originX, originY, self.size.width, self.size.height);
}

- (CGPoint)leftTop {
    return CGPointMake(self.originX, self.originY);
}

- (void)setLeftTop:(CGPoint)leftTo {
    self.frame = CGRectMake(leftTo.x, leftTo.y, self.size.width, self.size.height);
}

- (CGPoint)rightTop {
    return CGPointMake(self.originX + self.size.width, self.originY);
}

- (void)setRightTop:(CGPoint)rightTop {
    self.frame = CGRectMake(rightTop.x - self.size.width, rightTop.y, self.size.width, self.size.height);
}

- (CGPoint)leftBottom {
    return CGPointMake(self.originX, self.originY + self.size.height);
}

- (void)setLeftBottom:(CGPoint)leftBottom {
    self.frame = CGRectMake(leftBottom.x, leftBottom.y - self.size.height, self.size.width, self.size.height);
}

- (CGPoint)rightBottom {
    return CGPointMake(self.originX + self.size.width, self.originY + self.size.height);
}

- (void)setRightBottom:(CGPoint)rightBottom {
    self.frame = CGRectMake(rightBottom.x - self.size.width, rightBottom.y - self.size.height, self.size.width, self.size.height);
}
@end
