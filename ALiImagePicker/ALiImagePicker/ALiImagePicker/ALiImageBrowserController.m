//
//  ALiImageBrowserController.m
//  ALiImagePicker
//
//  Created by LeeWong on 2016/10/18.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "ALiImageBrowserController.h"
#import "ALiImageBrowserTopToolBar.h"
#import "ALiImageBrowserBottomToolBar.h"
#import "ALiAsset.h"

@interface ALiImageBrowserController () <UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UITapGestureRecognizer *singleTap;

@property (nonatomic, strong) ALiImageBrowserTopToolBar *topToolBar;

@property (nonatomic, strong) ALiImageBrowserBottomToolBar *bottomToolBar;

@end

@implementation ALiImageBrowserController

#pragma mark - Custom Method

- (void)setAsset:(ALiAsset *)asset
{
    _asset = asset;
    
    CGSize imageSize = CGSizeMake(asset.asset.pixelWidth, asset.asset.pixelHeight);
    
    [[PHImageManager defaultManager] requestImageForAsset:asset.asset targetSize:imageSize contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        NSLog(@"%@",info);
        self.imageView.center = self.view.center;
        self.scrollView.contentSize = imageSize;
        self.imageView.size = CGSizeMake(asset.asset.pixelWidth, asset.asset.pixelHeight);
        [self setCenterImage:result];
    }];
}

//点击选中图片
- (void)selectImageAction:(UIButton *)button
{
    [self.topToolBar.selectBtn setSelected:!self.topToolBar.selectBtn.isSelected];
    [self fullImageBtnAction:button];
}

//点击原图
- (void)fullImageBtnAction:(UIButton *)button
{
    [self.bottomToolBar.fullImageBtn setSelected:!self.bottomToolBar.fullImageBtn.isSelected];
    [self.bottomToolBar.fullTitleButton setSelected:!self.bottomToolBar.fullTitleButton.isSelected];
    //显示这张图片的信息
    if (button.isSelected) {
        [self.bottomToolBar.fullTitleButton setTitle:@"Full Image(2.3M)" forState:UIControlStateSelected];
    } else {
        [self.bottomToolBar.fullTitleButton setTitle:@"Full Image" forState:UIControlStateSelected];

    }
}

//点击发送
- (void)sendImage:(UIButton *)button
{
    
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)configToolBarEventHandler
{
    [self.topToolBar.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [self.topToolBar.selectBtn addTarget:self action:@selector(selectImageAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomToolBar.fullImageBtn addTarget:self action:@selector(fullImageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomToolBar.fullTitleButton addTarget:self action:@selector(fullImageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomToolBar.sendBtn addTarget:self action:@selector(sendImage:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomToolBar.selectedCountBtn addTarget:self action:@selector(sendImage:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Load View

- (void)buildUI
{
    self.scrollView.frame = self.view.bounds;
    self.view.backgroundColor = [UIColor blackColor];
//    [self.view addGestureRecognizer:self.singleTap];
    
    self.topToolBar.frame = CGRectMake(0, 0, SCREEN_W, 64);
    
    self.bottomToolBar.frame = CGRectMake(0, SCREEN_H-64, SCREEN_W, 64);
    
    [self configToolBarEventHandler];
}


#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self buildUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}


- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer{
    
//    if ([self.delegate respondsToSelector:@selector(imageScrollViewTap:)]) {
//        [self.delegate imageScrollViewTap:self];
//    }
}


- (void)setCenterImage:(UIImage *)aImage
{
    CGSize boundsSize = self.view.bounds.size;// self.scrollView.bounds.size;
    CGSize aspectSize = [self aspectImage:self.asset];
    self.imageView.bounds = (CGRect) {{0.f, 0.f}, aspectSize};
    self.imageView.center = CGPointMake(boundsSize.width/2., boundsSize.height/2.);
    [self.scrollView addSubview:self.imageView];
    self.imageView.image = aImage;
    //保证新的图片按照原来放大比例
    self.scrollView.zoomScale = 1.0;
    self.scrollView.contentSize = [self aspectImage:self.asset];
}

- (CGSize)aspectImage:(ALiAsset *)imageInfo
{
    CGSize imageSize = CGSizeMake(imageInfo.asset.pixelWidth, imageInfo.asset.pixelHeight);
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    CGSize aspectSize = CGSizeZero;
    if (imageSize.width/width > imageSize.height / height) {
        aspectSize = CGSizeMake(width, width * imageSize.height / imageSize.width);
    } else {
        aspectSize = CGSizeMake(height * imageSize.width / imageSize.height, height);
    }
    return aspectSize;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGSize boundsSize = scrollView.bounds.size;
    CGRect imgFrame = self.imageView.frame;
    CGSize contentSize = scrollView.contentSize;
    CGPoint centerPoint = CGPointMake(contentSize.width/2, contentSize.height/2);
    // center horizontally
    if (imgFrame.size.width <= boundsSize.width)
    {
        centerPoint.x = boundsSize.width/2;
    }
    // center vertically
    if (imgFrame.size.height <= boundsSize.height)
    {
        centerPoint.y = boundsSize.height/2;
    }
    self.imageView.center = centerPoint;
}

#pragma mark - Lazy Load

- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

-(UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.maximumZoomScale = 2.0;
        _scrollView.minimumZoomScale = 0.5;
        _scrollView.delegate = self;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (UITapGestureRecognizer *)singleTap
{
    if (!_singleTap) {
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        _singleTap.numberOfTapsRequired = 1;
        _singleTap.numberOfTouchesRequired = 1;
    }
    return _singleTap;
}

- (ALiImageBrowserTopToolBar *)topToolBar
{
    if (_topToolBar == nil) {
        _topToolBar = [[ALiImageBrowserTopToolBar alloc] init];
        [self.view addSubview:_topToolBar];
        [self.view bringSubviewToFront:_topToolBar];
    }
    return _topToolBar;
}


- (ALiImageBrowserBottomToolBar *)bottomToolBar
{
    if (_bottomToolBar == nil) {
        _bottomToolBar = [[ALiImageBrowserBottomToolBar alloc] init];
        [self.view addSubview:_bottomToolBar];
        [self.view bringSubviewToFront:_bottomToolBar];
    }
    return _bottomToolBar;
}

@end
