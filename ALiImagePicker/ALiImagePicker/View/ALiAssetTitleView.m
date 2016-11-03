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
//    self.titleButton.frame = CGRectMake(0, 0, 120, 30);
    [self updateTitleConstraints];
}

- (void)updateTitleConstraints
{
   CGFloat width = [self.titleButton.currentTitle sizeWithFont:[UIFont systemFontOfSize:15.] maxSize:CGSizeMake(200, 30)].width;
    self.titleButton.center = self.center;
    self.titleButton.size = CGSizeMake(width, 30);
    
    CGFloat x = CGRectGetMaxX(self.titleButton.frame);
    self.arrowBtn.frame = CGRectMake(x, self.titleButton.frame.origin.y, 30, 30);
    
}


- (void)eventHandler
{
    if (self.titleViewDidClick) {
        self.titleViewDidClick();
    }
}

#pragma mark - Lazy Load
- (UIButton *)titleButton{
    if (!_titleButton) {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_titleButton setImage:[UIImage imageNamed:@"imagepicker_navigationbar_arrow_down"] forState:UIControlStateNormal];
        [_titleButton setImage:[UIImage imageNamed:@"imagepicker_navigationbar_arrow_up"] forState:UIControlStateSelected];
        [_titleButton setTitle:@"所有照片" forState:UIControlStateNormal];
        _titleButton.titleLabel.font = [UIFont systemFontOfSize:15.];
        [_titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_titleButton adjustImagePosition:EArtButtonImagePositionRight spacing:5];
        [_titleButton addTarget:self action:@selector(eventHandler) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_titleButton];
    }
    return _titleButton;
}

- (UIButton *)arrowBtn{
    if (!_arrowBtn) {
        _arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _arrowBtn.frame = CGRectMake(0, 0, 120, 30);
        [_arrowBtn setImage:[UIImage imageNamed:@"imagepicker_navigationbar_arrow_down"] forState:UIControlStateNormal];
        [_arrowBtn setImage:[UIImage imageNamed:@"imagepicker_navigationbar_arrow_up"] forState:UIControlStateSelected];
        [_arrowBtn setTitle:@"所有照片" forState:UIControlStateNormal];
        [_arrowBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_arrowBtn adjustImagePosition:EArtButtonImagePositionRight spacing:5];
        [_arrowBtn addTarget:self action:@selector(eventHandler) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_arrowBtn];
    }
    return _arrowBtn;
}

@end
