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

@property (nonatomic, strong) UIButton *takePhotoBtn;

@property (nonatomic, strong) ALiAsset *asset;

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
    self.takePhotoBtn.frame = self.bounds;
    self.imageView.frame = self.bounds;
    self.checkBtn.rightTop = self.imageView.rightTop;
}


- (void)configImageCell:(ALiAsset *)asset 
{
    if ([asset isKindOfClass:[ALiAsset class]]) {
        self.asset = asset;
        [self.imageView setImage:[asset thumbnailWithSize:self.bounds.size]];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.contentView.backgroundColor = [UIColor colorWithRed:236/255. green:236/255. blue:236/255. alpha:1];
        [self.checkBtn setSelected:asset.isSelected];
        self.checkBtn.hidden = NO;
        self.imageView.hidden = NO;
        self.takePhotoBtn.hidden = YES;
    } else if ([asset isKindOfClass:[NSString class]] && [(NSString *)asset isEqualToString:@"takephoto"]) {
        self.asset = asset;
        self.checkBtn.hidden = YES;
        self.takePhotoBtn.hidden = NO;
        self.imageView.hidden = YES;
    }
    
}

- (void)checkBtnDidClick
{
    [self.checkBtn setSelected:!self.checkBtn.isSelected];
    self.asset.selected = self.checkBtn.isSelected;
    if ([self.delegate respondsToSelector:@selector(imageDidSelect:select:)]) {
        [self.delegate imageDidSelect:self.asset select:self.checkBtn.isSelected];
    }
}

- (void)tapImage
{
    if ([self.delegate respondsToSelector:@selector(imageDidTapped:select:)]) {
        [self.delegate imageDidTapped:self.asset select:self.checkBtn.isSelected];
    }
}

#pragma mark - Lazy Load

- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
        [_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage)]];
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (UIButton *)checkBtn
{
    if (_checkBtn == nil) {
        _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage  *img = [UIImage imageNamed:@"photo_check_default"];
        UIImage  *imgH = [UIImage imageNamed:@"photo_check_selected"];
        [_checkBtn setImage:img forState:UIControlStateNormal];
        [_checkBtn setImage:imgH forState:UIControlStateSelected];
        [self.imageView addSubview:_checkBtn];
        [_checkBtn addTarget:self action:@selector(checkBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        _checkBtn.size = CGSizeMake(20, 20);
    }
    return _checkBtn;
}


- (UIButton *)takePhotoBtn
{
    if (_takePhotoBtn == nil) {
        _takePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_takePhotoBtn setImage:[UIImage imageNamed:@"imagepicker_compose_photograph"] forState:UIControlStateNormal];
        [_takePhotoBtn setBackgroundImage:[UIImage imageNamed:@"imagepicker_compose_photograph_bg"] forState:UIControlStateNormal];
        [_takePhotoBtn addTarget:self action:@selector(tapImage) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_takePhotoBtn];
    }
    return _takePhotoBtn;
}

@end
