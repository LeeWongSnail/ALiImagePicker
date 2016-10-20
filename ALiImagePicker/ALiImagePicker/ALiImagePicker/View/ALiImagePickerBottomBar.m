//
//  ALiImagePickerBottomBar.m
//  ALiImagePicker
//
//  Created by LeeWong on 2016/10/20.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "ALiImagePickerBottomBar.h"

@interface ALiImagePickerBottomBar ()

@property (nonatomic, strong) UIButton *previewBtn;

@property (nonatomic, strong) UIButton *sendBtn;

@end

@implementation ALiImagePickerBottomBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)buildUI
{
    self.previewBtn.frame = CGRectMake(10, 15, 80, 30);
    CGFloat x = SCREEN_W - 50 - 10;
    self.previewBtn.frame = CGRectMake(x, self.previewBtn.originY, 50, 30);
}

#pragma mark - Lazy Load

- (UIButton *)sendBtn
{
    if (_sendBtn == nil) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setTitle:@"Send" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
        [_sendBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self addSubview:_sendBtn];
    }
    return _sendBtn;
}


- (UIButton *)previewBtn
{
    if (_previewBtn == nil) {
        _previewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_previewBtn setTitle:@"Preview" forState:UIControlStateNormal];
        [_previewBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self addSubview:_previewBtn];
    }
    return _previewBtn;
}

@end
