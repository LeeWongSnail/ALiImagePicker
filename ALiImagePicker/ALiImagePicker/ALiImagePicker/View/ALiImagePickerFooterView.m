//
//  ALiImagePickerFooterView.m
//  ALiImagePicker
//
//  Created by LeeWong on 2016/10/20.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "ALiImagePickerFooterView.h"

@interface ALiImagePickerFooterView ()

@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *updateTimeLabel;

@end

@implementation ALiImagePickerFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI
{
    self.tipLabel.center = CGPointMake(self.center.x, 5);
    self.tipLabel.size = CGSizeMake(SCREEN_W, 25);
    self.updateTimeLabel.center = CGPointMake(self.center.x , CGRectGetMaxY(self.tipLabel.frame) + 5);
    self.updateTimeLabel.size = CGSizeMake(SCREEN_W, 25);
}

- (void)configFooterViewImageCount:(NSInteger)imageCount videoCount:(NSInteger)videoCount updateTime:(NSString *)aTime
{
    self.tipLabel.text = [NSString stringWithFormat:@"%ld张照片,%ld个视频",(long)imageCount,(long)videoCount];
    self.updateTimeLabel.text = @"刚刚";
}

#pragma mark - Lazy Load
- (UILabel *)tipLabel
{
    if (_tipLabel == nil) {
        _tipLabel = [[UILabel alloc] init];
        [self addSubview:_tipLabel];
    }
    return _tipLabel;
}

- (UILabel *)updateTimeLabel
{
    if (_updateTimeLabel == nil) {
        _updateTimeLabel = [[UILabel alloc] init];
        [self addSubview:_updateTimeLabel];
    }
    return _updateTimeLabel;
}
@end
