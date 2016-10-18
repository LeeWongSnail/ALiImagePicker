//
//  ALiImageBrowserTopToolBar.m
//  ALiImagePicker
//
//  Created by LeeWong on 2016/10/18.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "ALiImageBrowserTopToolBar.h"

@interface ALiImageBrowserTopToolBar ()

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIButton *selectBtn;

@end

@implementation ALiImageBrowserTopToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI
{
    
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.8;
    
    self.backBtn.originY = self.center.y-15;
    self.backBtn.originX = 15;
    self.backBtn.size = CGSizeMake(30, 30);
    
    self.selectBtn.size = CGSizeMake(30, 30);
    self.selectBtn.originY = self.backBtn.originY;
    self.selectBtn.originX = self.size.width - 30 - 15;
    
}

#pragma mark - Lazy Load

- (UIButton *)backBtn
{
    if (_backBtn == nil) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self addSubview:_backBtn];
    }
    
    return _backBtn;
}

- (UIButton *)selectBtn
{
    if (_selectBtn == nil) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self addSubview:_selectBtn];
    }
    return _backBtn;
}

@end
