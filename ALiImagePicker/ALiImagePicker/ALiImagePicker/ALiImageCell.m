//
//  ALiImageCell.m
//  ALiImagePicker
//
//  Created by LeeWong on 2016/10/17.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "ALiImageCell.h"
#import "ALiAsset.h"

@interface ALiImageCell ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIButton *checkBtn;

@end


@implementation ALiImageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}


- (void)buildUI
{
    self.imageView.frame = self.bounds;
    
    self.checkBtn.rightTop = self.imageView.rightTop;
    self.checkBtn.size = CGSizeMake(20, 20);
}


- (void)configImageCell:(ALiAsset *)asset
{
    
}

#pragma mark - Lazy Load

- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (UIButton *)checkBtn
{
    if (_checkBtn == nil) {
        _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_checkBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
        [self addSubview:_checkBtn];
        [self bringSubviewToFront:_checkBtn];
    }
    return _checkBtn;
}


@end
