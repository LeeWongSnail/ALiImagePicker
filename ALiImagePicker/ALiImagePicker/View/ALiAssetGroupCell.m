//
//  ArtAssetGroupCell.m
//  DesignBox
//
//  Created by leoliu on 15/8/28.
//  Copyright (c) 2015年 GK. All rights reserved.
//

#import "ALiAssetGroupCell.h"
#import "UIView+ALi.h"
#import "ALiAsset.h"

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
        [self buildUI];
    }
    return self;
}

- (void)buildUI
{
    self.thumbnailView.frame = CGRectMake(8, 4, 60, 60);
    CGFloat nameY = self.thumbnailView.originY;
    CGFloat nameX = CGRectGetMaxX(self.thumbnailView.frame) + 10;
    self.assetsNameLabel.frame = CGRectMake(nameX, nameY, 200, 20);
    
    CGFloat countY = CGRectGetMaxY(self.assetsNameLabel.frame) + 10;
    
    self.assetsCountLabel.frame = CGRectMake(nameX, countY, 100, 20);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma makr - setter

- (void)setAssetsGroup:(NSDictionary *)assetsGroup
{
    _assetsGroup = assetsGroup;
    ALiAsset *asset = assetsGroup[kPHImage];
    [self.thumbnailView setImage:[asset thumbnailWithSize:CGSizeMake(60, 60)]];
    self.assetsNameLabel.text = assetsGroup[kPHTitle];
    self.assetsCountLabel.text = [NSString stringWithFormat:@"%ld",[assetsGroup[kPHCount] longValue]];
}


#pragma makr - getter
- (UIImageView *)thumbnailView{
    if (!_thumbnailView) {
        _thumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 4, 60, 60)];
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
