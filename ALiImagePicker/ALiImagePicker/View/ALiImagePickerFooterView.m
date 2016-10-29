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
    self.tipLabel.frame = CGRectMake(SCREEN_W/2. - 25, 15, SCREEN_W, 25);
    CGFloat y = CGRectGetMaxY(self.tipLabel.frame);
    self.updateTimeLabel.frame = CGRectMake(SCREEN_W/2. - 25, y, SCREEN_W, 25);
}

- (void)configFooterViewImageCount:(NSInteger)imageCount videoCount:(NSInteger)videoCount updateTime:(NSString *)aTime
{
    NSMutableString *str = [NSMutableString string];
    if (imageCount > 0) {
        [str appendString:[NSString stringWithFormat:@"%tu张照片",(long)imageCount]];
    }
    if (videoCount > 0) {
        [str appendString:[NSString stringWithFormat:@"%tu个视频",(long)videoCount]];
    }
    self.tipLabel.text = [str copy];
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
