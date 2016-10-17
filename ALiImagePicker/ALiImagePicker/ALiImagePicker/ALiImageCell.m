//
//  ALiImageCell.m
//  ALiImagePicker
//
//  Created by LeeWong on 2016/10/17.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "ALiImageCell.h"
#import "ALiImagePickerService.h"
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
}


- (void)configImageCell:(ALiAsset *)asset
{
    WEAKSELF(weakSelf);
    [[ALiImagePickerService shared] ali_fetchImageForAsset:asset completion:^(UIImage *image, NSDictionary *info) {
        [weakSelf.imageView setImage:image];
    }];
}

#pragma mark - Lazy Load

- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (UIButton *)checkBtn
{
    if (_checkBtn == nil) {
        _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkBtn setImage:[UIImage imageNamed:@"imagepicker_photo_check_default"] forState:UIControlStateNormal];
        [_checkBtn setImage:[UIImage imageNamed:@"imagepicker_photo_check_selected"] forState:UIControlStateSelected];
        [self.imageView addSubview:_checkBtn];
        _checkBtn.size = CGSizeMake(20, 20);
        [_checkBtn setSelected:YES];
    }
    return _checkBtn;
}


@end
