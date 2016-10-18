//
//  ALiImageBrowserTopToolBar.m
//  ALiImagePicker
//
//  Created by LeeWong on 2016/10/18.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "ALiImageBrowserTopToolBar.h"

@interface ALiImageBrowserTopToolBar ()
@property (nonatomic, strong) UIVisualEffectView *effectView;
@end

@implementation ALiImageBrowserTopToolBar

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
        [self.effectView addSubview:_backBtn];
    }
    
    return _backBtn;
}

- (UIButton *)selectBtn
{
    if (_selectBtn == nil) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setImage:[UIImage imageNamed:@"selected_normal"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"selected_selected"] forState:UIControlStateSelected];
        [self.effectView addSubview:_selectBtn];
    }
    return _selectBtn;
}

- (UIVisualEffectView *)effectView
{
    if (_effectView == nil) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        [self addSubview:_effectView];
        
    }
    return _effectView;
}

@end
