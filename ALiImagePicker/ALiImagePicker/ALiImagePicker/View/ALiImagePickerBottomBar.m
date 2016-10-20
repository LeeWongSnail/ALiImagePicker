//
//  ALiImagePickerBottomBar.m
//  ALiImagePicker
//
//  Created by LeeWong on 2016/10/20.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "ALiImagePickerBottomBar.h"

@interface ALiImagePickerBottomBar ()


@end

@implementation ALiImagePickerBottomBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)buildUI
{
    self.previewBtn.frame = CGRectMake(10, 8, 60, 30);
    self.previewBtn.enabled = NO;
    CGFloat x = SCREEN_W - 50 - 10;
    self.sendBtn.frame = CGRectMake(x, self.previewBtn.originY, 50, 30);
    self.sendBtn.enabled = NO;
    
    self.selectedCountBtn.size = CGSizeMake(25, 25);
    x = self.sendBtn.originX - 5 - 15;
    self.selectedCountBtn.center = CGPointMake(x, self.sendBtn.center.y);
}

#pragma mark - Lazy Load

- (UIButton *)sendBtn
{
    if (_sendBtn == nil) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setTitle:@"Send" forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sendBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [self addSubview:_sendBtn];
    }
    return _sendBtn;
}


- (UIButton *)previewBtn
{
    if (_previewBtn == nil) {
        _previewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_previewBtn setTitle:@"Preview" forState:UIControlStateNormal];
        _previewBtn.titleLabel.font = [UIFont systemFontOfSize:15.];
        [_previewBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_previewBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [self addSubview:_previewBtn];
    }
    return _previewBtn;
}

- (UIButton *)selectedCountBtn
{
    if (_selectedCountBtn == nil) {
        _selectedCountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectedCountBtn setBackgroundImage:[UIImage imageNamed:@"sendcount"] forState:UIControlStateNormal];
        [_selectedCountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_selectedCountBtn];
    }
    return _selectedCountBtn;
}

@end
