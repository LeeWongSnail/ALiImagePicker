//
//  ALiImageBrowserBottomToolBar.m
//  ALiImagePicker
//
//  Created by LeeWong on 2016/10/18.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "ALiImageBrowserBottomToolBar.h"

@interface ALiImageBrowserBottomToolBar ()

@property (nonatomic, strong) UIButton *fullImageBtn;

@property (nonatomic, strong) UIButton *selectedCountBtn;

@property (nonatomic, strong) UIButton *sendBtn;

@end

@implementation ALiImageBrowserBottomToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI
{
    self.fullImageBtn.size = CGSizeMake(80, 30);
    self.fullImageBtn.originX = 15;
    self.fullImageBtn.originY = self.center.y - 15 - 10;
    
    self.sendBtn.size = CGSizeMake(50, 30);
    self.sendBtn.originY = self.fullImageBtn.originY;
    self.sendBtn.originX = self.size.width - 15 - 25;
    
    self.selectedCountBtn.size = CGSizeMake(30, 30);
    self.selectedCountBtn.originY = self.sendBtn.originY;
    self.selectedCountBtn.originX = self.sendBtn.originX - 5 - 30;
}

#pragma mark - Lazy Load

- (UIButton *)fullImageBtn
{
    if (_fullImageBtn == nil) {
        _fullImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullImageBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_fullImageBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
        [_fullImageBtn setTitle:@"fullImage" forState:UIControlStateNormal];
        [_fullImageBtn setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
        [_fullImageBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self addSubview:_fullImageBtn];
    }
    return _fullImageBtn;
}


- (UIButton *)selectedCountBtn
{
    if (_selectedCountBtn == nil) {
        _selectedCountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectedCountBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_selectedCountBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
        [_selectedCountBtn setTitle:@"fullImage" forState:UIControlStateNormal];
        [_selectedCountBtn setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
        [_selectedCountBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
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
        [_sendBtn setTitle:@"fullImage" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
        [_sendBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self addSubview:_sendBtn];
    }
    return _sendBtn;
}

@end
