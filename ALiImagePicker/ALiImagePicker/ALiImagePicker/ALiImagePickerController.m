//
//  ALiImagePickerController.m
//  ALiImagePicker
//
//  Created by LeeWong on 2016/10/15.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "ALiImagePickerController.h"
#import "ALiImagePickFooterView.h"
#import "ALiImagePickerService.h"
#import "UIButton+ALi.h"
#import "ALiAssetGroupsView.h"
#import "ALiImageCell.h"

static  NSString *kArtImagePickerCellIdentifier = @"ALiImageCell";
static  NSString *kArtAssetsFooterViewIdentifier = @"ALiImagePickFooterView";
#define kSizeThumbnailCollectionView  ([UIScreen mainScreen].bounds.size.width-10)/4
@interface ALiImagePickerController () <UICollectionViewDelegate,UICollectionViewDataSource>

//UI
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) ALiAssetGroupsView *assetGroupView;
@property (nonatomic, strong) UIView *overlayView;
@property (nonatomic, strong) UIButton *touchButton;
@property (nonatomic, strong) UIButton *titleButton;

//Data
@property (nonatomic, strong) NSArray *assets;
@property (nonatomic, strong) NSArray *groupTypes;

@end

@implementation ALiImagePickerController

#pragma mark - Custom Method

- (void)showAssetsGroupView
{
    [[UIApplication sharedApplication].keyWindow addSubview:self.touchButton];
    
    self.overlayView.alpha = 0.0f;
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.assetGroupView.originY = 0;
                         self.overlayView.alpha = 0.85f;
                     }completion:^(BOOL finished) {
                         
                     }];
}

- (void)hideAssetsGroupView
{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.assetGroupView.originY = -self.assetGroupView.size.height;
                         self.overlayView.alpha = 0.0f;
                     }completion:^(BOOL finished) {
                         [_touchButton removeFromSuperview];
                         _touchButton = nil;
                         
                         [_overlayView removeFromSuperview];
                         _overlayView = nil;
                     }];
    
}

- (void)assetsGroupsDidDeselected
{
    [self hideAssetsGroupView];
}

- (void)assetsGroupDidSelected
{
    [self showAssetsGroupView];
}

- (void)groupViewDidSelected:(PHAssetCollection *)collection
{
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:assets.count];
    [assets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ALiAsset *asset = [[ALiAsset alloc] init];
        asset.asset = obj;
        [arrM addObject:asset];
    }];
    self.assets = [arrM copy];
    //先收起
    [self hideAssetsGroupView];
    //在更新数据
    [self.collectionView reloadData];
    
    //更新标题
    [self.titleButton setTitle:collection.localizedTitle forState:UIControlStateNormal];
}

#pragma mark - Load Data

- (void)fetchImagesInLibary
{
   self.assets = [[ALiImagePickerService shared] ali_fectchAssetsWithMediaType:EALiPickerResourceTypeImage];
    [self.collectionView reloadData];
}

- (void)fetchPhotoLibaryCategory
{
    //获取某一组的内容
    WEAKSELF(weakSelf);
    [[ALiImagePickerService shared] ali_fetchImageGroupWithTypes:self.groupTypes completion:^(PHFetchResult *result) {
        if (result.count > 0) {
            weakSelf.assetGroupView.assetsGroups = result;
            weakSelf.titleButton.enabled = YES;
        } else {
            weakSelf.titleButton.enabled = NO;
        }
    }];
}

#pragma mark - Load View

- (void)buildUI
{
    self.collectionView.frame = self.view.bounds;
    [self setUpProperties];
}


- (void)setUpProperties
{
    self.groupTypes = @[@(PHAssetCollectionSubtypeSmartAlbumUserLibrary),  //相机胶卷
                        @(PHAssetCollectionSubtypeAlbumImported),      //照片图库
                        @(PHAssetCollectionSubtypeAlbumMyPhotoStream),  //我的照片流
                        @(PHAssetCollectionSubtypeAlbumRegular)];       //自建相册
    self.navigationItem.titleView = self.titleButton;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self buildUI];
    [self fetchImagesInLibary];
    [self fetchPhotoLibaryCategory];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALiAsset *asset = self.assets[indexPath.item];
    ALiImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kArtImagePickerCellIdentifier forIndexPath:indexPath];
    [cell configImageCell:asset];
    
    return cell;
}


#pragma mark - Lazy Load

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[ALiImageCell class] forCellWithReuseIdentifier:kArtImagePickerCellIdentifier];
        [_collectionView registerClass:[ALiImagePickFooterView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:kArtAssetsFooterViewIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_collectionView];

    }
    
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout
{
    if (_layout == nil) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumLineSpacing = 2.0;
        _layout.minimumInteritemSpacing = 2.0;
        _layout.itemSize = CGSizeMake(kSizeThumbnailCollectionView, kSizeThumbnailCollectionView);
        _layout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _layout;
}

- (ALiAssetGroupsView *)assetGroupView
{
    if (_assetGroupView == nil) {
        _assetGroupView = [[ALiAssetGroupsView alloc] initWithFrame:CGRectMake(0, -self.view.size.height, self.view.size.width, self.view.size.height)];
        _assetGroupView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [_assetGroupView.touchButton addTarget:self action:@selector(hideAssetsGroupView) forControlEvents:UIControlEventTouchUpInside];
        WEAKSELF(weakSelf);
        _assetGroupView.groupSelectedBlock = ^(PHAssetCollection *collection){
            [weakSelf groupViewDidSelected:collection];
        };
        [self.view addSubview:_assetGroupView];
        
    }
    return _assetGroupView;
}

- (UIView *)overlayView{
    if (!_overlayView) {
        _overlayView = [[UIView alloc] initWithFrame:self.view.bounds];
        _overlayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85f];
        [self.view insertSubview:_overlayView belowSubview:self.assetGroupView];
        
    }
    return _overlayView;
}

- (UIButton *)touchButton{
    if (!_touchButton) {
        _touchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _touchButton.frame = CGRectMake(0, 0, self.view.size.width, 64);
        [_touchButton setBackgroundColor:[UIColor clearColor]];
        [_touchButton addTarget:self action:@selector(assetsGroupsDidDeselected) forControlEvents:UIControlEventTouchUpInside];
    }
    return _touchButton;
}

- (UIButton *)titleButton{
    if (!_titleButton) {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleButton.frame = CGRectMake(0, 0, 120, 30);
        [_titleButton setImage:[UIImage imageNamed:@"imagepicker_navigationbar_arrow_down"] forState:UIControlStateNormal];
        [_titleButton setImage:[UIImage imageNamed:@"imagepicker_navigationbar_arrow_up"] forState:UIControlStateSelected];
        [_titleButton setTitle:@"所有照片" forState:UIControlStateNormal];
        [_titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_titleButton adjustImagePosition:EArtButtonImagePositionRight spacing:5];
        [_titleButton addTarget:self action:@selector(assetsGroupDidSelected) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleButton;
}

@end
