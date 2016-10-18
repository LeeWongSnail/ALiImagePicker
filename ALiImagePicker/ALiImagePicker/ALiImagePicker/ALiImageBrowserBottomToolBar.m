//
//  ALiImageBrowserBottomToolBar.m
//  ALiImagePicker
//
//  Created by LeeWong on 2016/10/18.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "ALiImageBrowserBottomToolBar.h"

@interface ALiImageBrowserBottomToolBar ()

@property (nonatomic, strong) UIVisualEffectView *effectView;

@end

@implementation ALiImageBrowserBottomToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)buildUI
{
    self.effectView.frame = self.bounds;
    
    self.fullImageBtn.size = CGSizeMake(120, 32);
    [self.fullImageBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    self.fullImageBtn.originX = 15;
    self.fullImageBtn.originY = 15;
    
    self.sendBtn.size = CGSizeMake(50, 30);
    self.sendBtn.originY = self.fullImageBtn.originY;
    self.sendBtn.originX = SCREEN_W - 15 - 50;

    self.selectedCountBtn.size = CGSizeMake(30, 30);
    self.selectedCountBtn.originY = self.sendBtn.originY;
    self.selectedCountBtn.originX = self.sendBtn.originX - 5 - 30;
}

#pragma mark - Lazy Load

- (UIButton *)fullImageBtn
{
    if (_fullImageBtn == nil) {
        _fullImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullImageBtn setImage:[UIImage imageNamed:@"fullimage_normal"] forState:UIControlStateNormal];
        [_fullImageBtn setImage:[UIImage imageNamed:@"fullimage_selected"] forState:UIControlStateSelected];
        [_fullImageBtn setTitle:@"fullImage" forState:UIControlStateNormal];
        [_fullImageBtn setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
        [_fullImageBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _fullImageBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.effectView addSubview:_fullImageBtn];
    }
    return _fullImageBtn;
}


- (UIButton *)selectedCountBtn
{
    if (_selectedCountBtn == nil) {
        _selectedCountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectedCountBtn setImage:[UIImage imageNamed:@"sendcount"] forState:UIControlStateSelected];
        [_selectedCountBtn setTitle:@"" forState:UIControlStateNormal];
        [_selectedCountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.effectView addSubview:_selectedCountBtn];
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
        [self.effectView addSubview:_sendBtn];
    }
    return _sendBtn;
}

- (UIVisualEffectView *)effectView
{
    if (_effectView == nil) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        [self addSubview:_effectView];
        
    }
    return _effectView;
}

@end
