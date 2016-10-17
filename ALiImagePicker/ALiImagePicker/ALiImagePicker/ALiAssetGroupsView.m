//
//  ArtAssetGroupsView.m
//  DesignBox
//
//  Created by leoliu on 15/8/28.
//  Copyright (c) 2015年 GK. All rights reserved.
//

#import "ALiAssetGroupsView.h"
#import "ALiAssetGroupCell.h"

@interface ALiAssetGroupsView()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView  *tableView;
@property (nonatomic, strong) NSIndexPath  *selectedIndexPath;

@end

static CGFloat kHeightAssetsGroupCell = 70.0;

@implementation ALiAssetGroupsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self tableView];
    }
    return self;
}



- (void)setAssetsGroups:(PHFetchResult *)assetsGroups
{
    NSMutableArray *arrM = [NSMutableArray array];
    [assetsGroups enumerateObjectsUsingBlock:^(PHAssetCollection *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:obj options:nil];
        if (assets.count > 0) {
            [arrM addObject:obj];
        }
    }];
    _assetsGroups = [arrM copy];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.assetsGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    ALiAssetGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ALiAssetGroupCell"];
    PHAssetCollection *assetsGroup = self.assetsGroups[indexPath.row];
    cell.assetsGroup = assetsGroup;
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHeightAssetsGroupCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectedIndexPath = indexPath;
    [self.tableView reloadData];
    PHAssetCollection *collection = self.assetsGroups[indexPath.row];

}


#pragma mark - getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.size.width, 4*kHeightAssetsGroupCell) style:UITableViewStylePlain];
        [_tableView registerClass:[ALiAssetGroupCell class] forCellReuseIdentifier:@"ALiAssetGroupCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
    }
    return _tableView;
}

- (UIButton *)touchButton{
    if (!_touchButton) {
        _touchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _touchButton.frame = CGRectMake(0, self.tableView.leftBottom.y, self.size.width, self.size.height -self.tableView.leftBottom.y);
//        [_touchButton addTarget:self action:@selector(cancelAssetsGroupSelect) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_touchButton];
    }
    return _touchButton;
}

@end
