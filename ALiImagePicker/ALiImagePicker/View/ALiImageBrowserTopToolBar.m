//
//  ALiImageBrowserTopToolBar.m
//  ALiImagePicker
//
//  Created by LeeWong on 2016/10/18.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "ALiImageBrowserTopToolBar.h"

@interface ALiImageBrowserTopToolBar ()

@end

@implementation ALiImageBrowserTopToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.7;
    }
    return self;
}

- (void)buildUI
{
    
    self.backBtn.originY = 15;
    self.backBtn.originX = 15;
    self.backBtn.size = CGSizeMake(30, 30);
    
    self.selectBtn.size = CGSizeMake(30, 30);
    self.selectBtn.originY = self.backBtn.originY;
    self.selectBtn.originX = SCREEN_W - 30 - 15;
    
}

#pragma mark - Lazy Load

- (UIButton *)backBtn
{
    if (_backBtn == nil) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [self addSubview:_backBtn];
    }
    
    return _backBtn;
}

- (UIButton *)selectBtn
{
    if (_selectBtn == nil) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setImage:[UIImage imageNamed:@"selected_normal"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"selected_selected"] forState:UIControlStateSelected];
        [self addSubview:_selectBtn];
    }
    return _selectBtn;
}

@end
