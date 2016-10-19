//
//  ALiImageBrowserBottomToolBar.m
//  ALiImagePicker
//
//  Created by LeeWong on 2016/10/18.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "ALiImageBrowserBottomToolBar.h"

@interface ALiImageBrowserBottomToolBar ()


@end

@implementation ALiImageBrowserBottomToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (void)buildUI
{
    
    self.fullImageBtn.size = CGSizeMake(20,20);
    self.fullImageBtn.originX = 10;
    self.fullImageBtn.originY = 25;
    
    CGFloat x = CGRectGetMaxX(self.fullImageBtn.frame) + 10 + 40;
    self.fullTitleButton.size = CGSizeMake(120, 32);
    self.fullTitleButton.center = CGPointMake(x, self.fullImageBtn.center.y);
    
    
    self.sendBtn.size = CGSizeMake(50, 30);
    x = SCREEN_W - 15 - 25;
    self.sendBtn.center = CGPointMake(x, self.fullImageBtn.center.y);

    self.selectedCountBtn.size = CGSizeMake(30, 30);
    x = self.sendBtn.originX - 5 - 15;
    self.selectedCountBtn.center = CGPointMake(x, self.fullImageBtn.center.y);
}

#pragma mark - Lazy Load

- (UIButton *)fullImageBtn
{
    if (_fullImageBtn == nil) {
        _fullImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullImageBtn setImage:[UIImage imageNamed:@"fullimage_normal"] forState:UIControlStateNormal];
        [_fullImageBtn setImage:[UIImage imageNamed:@"fullimage_selected"] forState:UIControlStateSelected];
        [self addSubview:_fullImageBtn];
    }
    return _fullImageBtn;
}

- (UIButton *)fullTitleButton
{
    if (_fullTitleButton == nil) {
        _fullTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullTitleButton setTitle:@"Full Image" forState:UIControlStateNormal];
        [_fullTitleButton setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
        [_fullTitleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _fullTitleButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_fullTitleButton];
    }
    return _fullTitleButton;
}

- (UIButton *)selectedCountBtn
{
    if (_selectedCountBtn == nil) {
        _selectedCountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectedCountBtn setImage:[UIImage imageNamed:@"sendcount"] forState:UIControlStateSelected];
        [_selectedCountBtn setTitle:@"" forState:UIControlStateNormal];
        [_selectedCountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_selectedCountBtn];
    }
    return _selectedCountBtn;
}


- (UIButton *)sendBtn
{
    if (_sendBtn == nil) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_sendBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
        [_sendBtn setTitle:@"Send" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
        [_sendBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [self addSubview:_sendBtn];
    }
    return _sendBtn;
}

@end
