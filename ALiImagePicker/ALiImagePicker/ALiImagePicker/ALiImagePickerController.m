//
//  ALiImagePickerController.m
//  ALiImagePicker
//
//  Created by LeeWong on 2016/10/15.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "ALiImagePickerController.h"
#import "ALiImageBrowserController.h"
#import "ALiImagePickerBottomBar.h"
#import "ALiImagePickerFooterView.h"
#import "ALiImagePickerService.h"
#import "ALiAssetGroupsView.h"
#import "UIButton+ALi.h"
#import "ALiImageCell.h"

#define kBottomBarHeight  44.

static  NSString *kArtImagePickerCellIdentifier = @"ALiImageCell";
static  NSString *kArtAssetsFooterViewIdentifier = @"ALiImagePickFooterView";
#define kSizeThumbnailCollectionView  ([UIScreen mainScreen].bounds.size.width-10)/4
@interface ALiImagePickerController () <UICollectionViewDelegate,UICollectionViewDataSource,ALiImageCellDelegate>

//UI
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) ALiAssetGroupsView *assetGroupView;
@property (nonatomic, strong) ALiImagePickerBottomBar *bottomBar;
@property (nonatomic, strong) ALiImagePickerFooterView *footerView;
@property (nonatomic, strong) UIView *overlayView;
@property (nonatomic, strong) UIButton *touchButton;
@property (nonatomic, strong) UIButton *titleButton;

//Data
@property (nonatomic, strong) NSArray *assets;

@property (nonatomic, strong) NSMutableArray *selectAssets;


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

- (void)groupViewDidSelected:(NSDictionary *)collection
{
    // 获得某个相簿中的所有PHAsset对象
    WEAKSELF(weakSelf);
    [[ALiImagePickerService shared] fetchAssetsWithMediaType:EALiPickerResourceTypeImage groupTitle:collection[kPHTitle] completion:^(NSString *title, NSArray *assets) {
        weakSelf.assets = assets;
        dispatch_async(dispatch_get_main_queue(), ^{
            //先收起
            [weakSelf hideAssetsGroupView];
            //在更新数据
            [weakSelf.collectionView reloadData];
            
            //更新标题
            [weakSelf.titleButton setTitle:title forState:UIControlStateNormal];            
        });
    }];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addSelectAssets:(ALiAsset *)asset
{
    if (asset.isSelected) {
        [self.selectAssets addObject:asset];
    } else {
        [self.selectAssets removeObject:asset];
    }
    if (self.selectAssets.count == 0) {
        self.bottomBar.previewBtn.enabled = NO;
        self.bottomBar.sendBtn.enabled = NO;
        self.bottomBar.selectedCountBtn.hidden = YES;
    } else {
        self.bottomBar.previewBtn.enabled = YES;
        self.bottomBar.sendBtn.enabled = YES;
        self.bottomBar.selectedCountBtn.hidden = NO;
        [self.bottomBar.selectedCountBtn setTitle:[NSString stringWithFormat:@"%tu",self.selectAssets.count] forState:UIControlStateNormal];
    }
}

- (void)previewSelectAsset
{
    //看大图
    ALiImageBrowserController *browserVc = [[ALiImageBrowserController alloc] init];
    
    WEAKSELF(weakSelf);
    browserVc.photoChooseBlock = ^(NSArray *assets){
        weakSelf.selectAssets = [assets mutableCopy];
    };
    
    browserVc.allAssets = self.selectAssets;
    browserVc.selectedAsset = self.selectAssets;
    browserVc.curIndex = 0;
    [self.navigationController pushViewController:browserVc animated:YES];
}

- (void)sendSelectAsset
{
    if (self.photoChooseBlock) {
        self.photoChooseBlock(self.selectAssets);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Load Data

- (void)fetchImagesInLibary
{
    WEAKSELF(weakSelf);
    [[ALiImagePickerService shared] fectchAssetsWithMediaType:EALiPickerResourceTypeImage completion:^(NSString *title,NSArray *assets) {
        weakSelf.assets = assets;
        [weakSelf.titleButton setTitle:title forState:UIControlStateNormal];
        [weakSelf.collectionView reloadData];
    }];
}

- (void)fetchPhotoLibaryCategory
{
    //获取某一组的内容
    WEAKSELF(weakSelf);
    [[ALiImagePickerService shared] fetchImageGroupWithTypes:self.sourceType completion:^(NSArray *arr) {
        if (arr.count > 0) {
            weakSelf.assetGroupView.assetsGroups = arr;
            weakSelf.titleButton.enabled = YES;
        } else {
            weakSelf.titleButton.enabled = NO;
        }
        [weakSelf.collectionView reloadData];
    }];
    
    
}

#pragma mark - Load View

- (void)buildUI
{
    self.selectAssets = [NSMutableArray array];
    self.collectionView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - kBottomBarHeight);
    self.bottomBar.frame = CGRectMake(0, SCREEN_H - kBottomBarHeight, SCREEN_W, kBottomBarHeight);
    [self.bottomBar.previewBtn addTarget:self action:@selector(previewSelectAsset) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBar.sendBtn addTarget:self action:@selector(sendSelectAsset) forControlEvents:UIControlEventTouchUpInside];
    [self setUpProperties];
}


- (void)setUpProperties
{
    self.navigationItem.titleView = self.titleButton;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
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

- (void)dealloc
{
    NSLog(@"%s",__func__);
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
    cell.delegate = self;
    [cell configImageCell:asset];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        self.footerView = (ALiImagePickerFooterView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                withReuseIdentifier:kArtAssetsFooterViewIdentifier
                                                                                    forIndexPath:indexPath];
        if (self.sourceType == EALiPickerResourceTypeImage) {
            [self.footerView configFooterViewImageCount:0 videoCount:self.assets.count updateTime:nil];
        } else {
            [self.footerView configFooterViewImageCount:self.assets.count videoCount:0 updateTime:nil];
        }
        reusableView = self.footerView;
    } else if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
    }
    
    return reusableView;
}


#pragma mark - ALiImageCellDelegate

- (void)imageDidSelect:(ALiAsset *)asset select:(BOOL)isSelect
{
    [self addSelectAssets:asset];
}

- (void)imageDidTapped:(ALiAsset *)asset select:(BOOL)isSelect
{
    //看大图
    ALiImageBrowserController *browserVc = [[ALiImageBrowserController alloc] init];
    WEAKSELF(weakSelf);
    browserVc.photoChooseBlock = ^(NSArray *assets){
        weakSelf.selectAssets = [assets mutableCopy];
        if (weakSelf.selectAssets.count > 0) {
            weakSelf.bottomBar.previewBtn.enabled = YES;
            weakSelf.bottomBar.sendBtn.enabled = YES;
        } else {
            weakSelf.bottomBar.previewBtn.enabled = NO;
            weakSelf.bottomBar.sendBtn.enabled = NO;
        }
        [weakSelf.bottomBar.selectedCountBtn setTitle:[NSString stringWithFormat:@"%tu",weakSelf.selectAssets.count] forState:UIControlStateNormal];
        [weakSelf.collectionView reloadData];
    };
    
    browserVc.allAssets = [NSMutableArray arrayWithArray:self.assets];
    browserVc.selectedAsset = self.selectAssets;
    browserVc.curIndex = [self.assets indexOfObject:asset];
    [self.navigationController pushViewController:browserVc animated:YES];
}

#pragma mark - Lazy Load

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[ALiImageCell class] forCellWithReuseIdentifier:kArtImagePickerCellIdentifier];
        [_collectionView registerClass:[ALiImagePickerFooterView class]
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
      _layout.footerReferenceSize = CGSizeMake(SCREEN_W, 65);  //设置footer大小
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
        _assetGroupView.groupSelectedBlock = ^(NSDictionary *collection){
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

- (ALiImagePickerBottomBar *)bottomBar
{
    if (_bottomBar == nil) {
        _bottomBar = [[ALiImagePickerBottomBar alloc] init];
        [self.view addSubview:_bottomBar];
    }
    return _bottomBar;
}

@end
