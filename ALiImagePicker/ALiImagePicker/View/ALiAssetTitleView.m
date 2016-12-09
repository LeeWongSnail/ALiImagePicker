//
//  ALiAssetTitleView.m
//  ALiImagePicker
//
//  Created by LeeWong on 2016/11/3.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "ALiAssetTitleView.h"
#import "NSString+ALi.h"

@interface ALiAssetTitleView ()


@end

@implementation ALiAssetTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}


- (void)buildUI
{
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(eventHandler)]];
}

- (CGFloat)updateTitleConstraints
{
    [self.titleButton sizeToFit];
    
    CGFloat  width = CGRectGetWidth(self.titleButton.frame)/2 + 2 + CGRectGetWidth(self.arrowBtn.frame) + 15;
    self.size = CGSizeMake(width * 2, self.frame.size.height);
    
    self.titleButton.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    
    self.arrowBtn.originX = self.titleButton.rightTop.x + 5;
    self.arrowBtn.center = CGPointMake(self.arrowBtn.center.x, self.titleButton.center.y);
    
    self.arrowBtn.transform = CGAffineTransformRotate(self.arrowBtn.transform, M_PI);
    
    return CGRectGetMaxX(self.arrowBtn.frame) + 10;
}


- (void)eventHandler
{
    if (self.titleViewDidClick) {
        self.titleViewDidClick();
    }
}


#pragma mark - Lazy Load
- (UILabel *)titleButton{
    if (!_titleButton) {
        _titleButton = [[UILabel alloc] init];
        _titleButton.text = @"所有照片";
        _titleButton.font = [UIFont systemFontOfSize:15.];
        _titleButton.textColor = [UIColor blackColor];
        [self addSubview:_titleButton];
    }
    return _titleButton;
}

- (UIImageView *)arrowBtn{
    if (!_arrowBtn) {
        _arrowBtn = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imagepicker_navigationbar_arrow_down"]];
        [self addSubview:_arrowBtn];
    }
    return _arrowBtn;
}

@end
