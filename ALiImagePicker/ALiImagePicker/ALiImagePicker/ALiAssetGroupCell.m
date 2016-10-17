//
//  ArtAssetGroupCell.m
//  DesignBox
//
//  Created by leoliu on 15/8/28.
//  Copyright (c) 2015年 GK. All rights reserved.
//

#import "ALiAssetGroupCell.h"
#import "UIView+ALi.h"
@interface ALiAssetGroupCell()

@property (nonatomic, strong) UIImageView *thumbnailView;
@property (nonatomic, strong) UILabel     *assetsNameLabel;
@property (nonatomic, strong) UILabel     *assetsCountLabel;
@property (nonatomic, strong) UIImageView   *checkImageView;

@end


@implementation ALiAssetGroupCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor = [UIColor redColor];
        [self buildUI];
    }
    return self;
}

- (void)buildUI
{
    self.thumbnailView.frame = CGRectMake(8, 4, 50, 50);
    CGFloat nameY = self.thumbnailView.originY;
    CGFloat nameX = CGRectGetMaxX(self.thumbnailView.frame) + 10;
    self.assetsNameLabel.frame = CGRectMake(nameX, nameY, 50, 20);
    [self.assetsNameLabel sizeToFit];
    
    CGFloat countY = CGRectGetMaxY(self.assetsCountLabel.frame) + 10;
    
    self.assetsCountLabel.frame = CGRectMake(nameX, countY, 50, 20);
    [self.assetsCountLabel sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma makr - setter

- (void)setAssetsGroup:(PHAssetCollection *)assetsGroup
{
    _assetsGroup = assetsGroup;
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetsGroup options:nil];
    
    [[PHImageManager defaultManager] requestImageForAsset:assets.firstObject targetSize:CGSizeMake(70, 74) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        [self.imageView setImage:result];
    }];
    
    self.assetsNameLabel.text = assetsGroup.localizedTitle;
    self.assetsCountLabel.text = [NSString stringWithFormat:@"%tu",assets.count];
}


#pragma makr - getter
- (UIImageView *)thumbnailView{
    if (!_thumbnailView) {
        _thumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 4, 70, 74)];
        _thumbnailView.backgroundColor = [UIColor clearColor];
        _thumbnailView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        _thumbnailView.contentMode = UIViewContentModeScaleAspectFill;
        _thumbnailView.clipsToBounds = YES;
        [self.contentView addSubview:_thumbnailView];
    }
    return _thumbnailView;
}

- (UIImageView *)checkImageView{
    if (!_checkImageView) {
        _checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"picker_photo_filter_checked"]];
        _checkImageView.backgroundColor = [UIColor clearColor];
        _checkImageView.rightTop = CGPointMake(self.thumbnailView.frame.size.width - 3, _checkImageView.rightTop.y);
        _checkImageView.leftBottom = CGPointMake(_checkImageView.leftBottom.x, self.thumbnailView.size.height - 3);
        [self.thumbnailView addSubview:_checkImageView];
    }
    return _checkImageView;
}

- (UILabel *)assetsNameLabel{
    if (!_assetsNameLabel) {
        _assetsNameLabel = [[UILabel alloc] init];
        _assetsNameLabel.backgroundColor = [UIColor clearColor];
        _assetsNameLabel.textColor = [UIColor blackColor];
        _assetsNameLabel.font = [UIFont systemFontOfSize:17.0f];
        [self.contentView addSubview:_assetsNameLabel];
    }
    return _assetsNameLabel;
}

- (UILabel *)assetsCountLabel{
    if (!_assetsCountLabel) {
        _assetsCountLabel = [[UILabel alloc] init];
        _assetsCountLabel.backgroundColor = [UIColor clearColor];
        _assetsCountLabel.textColor = [UIColor blackColor];
        _assetsCountLabel.font = [UIFont systemFontOfSize:12.0f];
        [self.contentView addSubview:_assetsCountLabel];
    }
    return _assetsCountLabel;
}
@end
