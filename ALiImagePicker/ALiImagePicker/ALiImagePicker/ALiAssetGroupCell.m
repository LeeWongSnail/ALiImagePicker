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
        [self thumbnailView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma makr - setter

//- (void)setAssetsGroup:(ALAssetsGroup *)assetsGroup{
//    if (_assetsGroup != assetsGroup) {
//        _assetsGroup = assetsGroup;
//        self.thumbnailView.assetsGroup = _assetsGroup;
//        self.assetsNameLabel.text = [_assetsGroup valueForProperty:ALAssetsGroupPropertyName];
//        [self.assetsNameLabel sizeToFit];
//        self.assetsNameLabel.originX = self.thumbnailView.rightTop.x + 18;
//        self.assetsNameLabel.leftBottom = CGPointMake(self.assetsNameLabel.leftBottom.x, self.thumbnailView.center.y - 2);
//        
//        self.assetsCountLabel.text = [NSString stringWithFormat:@"%ld", (long)[_assetsGroup numberOfAssets]];
//        [self.assetsCountLabel sizeToFit];
//        self.assetsCountLabel.originX =self.assetsNameLabel.leftTop.x;
//        self.assetsCountLabel.originY = self.assetsNameLabel.leftBottom.y + 4;
//    }
//}
//
//- (void)setIsSelected:(BOOL)isSelected{
//    _isSelected = isSelected;
//    self.checkImageView.hidden = !isSelected;
//}

#pragma makr - getter
- (UIImageView *)thumbnailView{
    if (!_thumbnailView) {
        _thumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 4, 70, 74)];
        _thumbnailView.backgroundColor = [UIColor clearColor];
        _thumbnailView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
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
