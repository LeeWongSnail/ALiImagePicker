//
//  ALiImageBrowserController.m
//  ALiImagePicker
//
//  Created by LeeWong on 2016/10/18.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "ALiImageBrowserController.h"
#import "ALiSingleImageController.h"
#import "ALiImageBrowserTopToolBar.h"
#import "ALiImageBrowserBottomToolBar.h"
#import "ALiAsset.h"

@interface ALiImageBrowserController () <UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property (nonatomic, strong) UIPageViewController *pageViewController;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) ALiImageBrowserTopToolBar *topToolBar;

@property (nonatomic, strong) ALiImageBrowserBottomToolBar *bottomToolBar;

@end

@implementation ALiImageBrowserController

#pragma mark - 点击Select
- (void)selectImageDidClick:(UIButton *)aButton
{
    [aButton setSelected:!aButton.isSelected];
    [self configSelectButton:aButton];
}


- (void)configSelectButton:(UIButton *)aButton
{
    ALiAsset *asset = self.allAssets[self.currentIndex];
    
    if (asset.isFullImage && aButton.isSelected) {
//        [self.bottomToolBar.fullImageBtn setSelected:aButton.isSelected];
//        [self configFullImageButton:aButton];
    }
    
    if (![self.selectedAsset containsObject:asset]) {
        [self.selectedAsset addObject:asset];
    } else {
        [self.selectedAsset removeObject:asset];
    }
    
    if (self.selectedAsset.count > 0) {
//        [self.bottomToolBar.selectedCountBtn setTitle:[NSString stringWithFormat:@"%tu",self.selectedAsset.count] forState:UIControlStateSelected];
    } else {
//        [self.bottomToolBar.selectedCountBtn setTitle:@"" forState:UIControlStateNormal];
    }
}

#pragma mark - 点击FullImage

- (void)fullImageDidClick:(UIButton *)aButton
{
    [aButton setSelected:!aButton.isSelected];
     ALiAsset *asset = self.allAssets[self.currentIndex];
    
    if (aButton.isSelected) {
        asset.fullImage = YES;
    } else {
        asset.fullImage = NO;
    }
    
    if (![self.selectedAsset containsObject:asset] && asset.fullImage) {
        [self configSelectButton:aButton];
    } else {
        [self configFullImageButton:aButton];
    }
    
}

- (void)configFullImageButton:(UIButton *)aButton
{
    [self.bottomToolBar.fullTitleButton setSelected:aButton.isSelected];
    if (aButton.isSelected) {
        [self.bottomToolBar.fullTitleButton setTitle:@"Full Image(2.3M)" forState:UIControlStateSelected];
    } else {
        [self.bottomToolBar.fullTitleButton setTitle:@"Full Image" forState:UIControlStateSelected];
    }
}

//点击发送
- (void)sendImage:(UIButton *)button
{
    if (self.photoChooseBlock) {
        self.photoChooseBlock([self.selectedAsset copy]);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)back
{
        if (self.photoChooseBlock) {
            self.photoChooseBlock([self.selectedAsset copy]);
        }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configToolBarEventHandler
{
    [self.topToolBar.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [self.topToolBar.selectBtn addTarget:self action:@selector(selectImageDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.bottomToolBar.fullImageBtn addTarget:self action:@selector(fullImageDidClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.bottomToolBar.fullTitleButton addTarget:self action:@selector(fullImageDidClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.bottomToolBar.sendBtn addTarget:self action:@selector(sendImage:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.bottomToolBar.selectedCountBtn addTarget:self action:@selector(sendImage:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Load View

- (void)initPageViewController
{
    CGRect rect = [UIScreen mainScreen].bounds;
    self.pageViewController.view.frame = CGRectMake(0, 0, rect.size.width + 20, rect.size.height);
    ALiSingleImageController *initialViewController = [self viewControllerAtIndex:self.curIndex];
    NSArray *viewControllers = nil;
    if (initialViewController) {
        viewControllers = [NSArray arrayWithObject:initialViewController];
    } else {
        viewControllers = [NSArray array];
    }
    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
}

- (void)buildUI
{
    self.topToolBar.frame = CGRectMake(0, 0, SCREEN_W, 64);
    self.view.backgroundColor = [UIColor blackColor];    
    [self initPageViewController];
    [self configToolBarEventHandler];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self buildUI];
    if (self.selectedAsset == nil) {
        self.selectedAsset = [NSMutableArray array];
    }
    self.currentIndex = self.curIndex;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

#pragma mark - Private Method

- (NSUInteger)getCount{
    
    return self.allAssets.count;
}

- (id)contentAtIndex:(NSUInteger) index{
    
    return self.allAssets[index];
}

- (ALiSingleImageController *)viewControllerAtIndex:(NSUInteger)index {
    if (([self getCount] == 0) || (index >= [self getCount])) {
        return nil;
    }
    ALiSingleImageController *dataViewController = [[ALiSingleImageController alloc] init];
    ALiAsset *asset = self.allAssets[index];
    dataViewController.asset = asset;
    
    //显示这张图片是否被选中的状态
    if ([self.selectedAsset containsObject:asset]) {
        if (asset.fullImage) {
//            [self.bottomToolBar.fullImageBtn setSelected:YES];
            [self configFullImageButton:self.bottomToolBar.fullImageBtn];
        }
        [self.topToolBar.selectBtn setSelected:YES];
        [self configSelectButton:self.topToolBar.selectBtn];
    }else {
//        [self.bottomToolBar.fullImageBtn setSelected:NO];
        [self.topToolBar.selectBtn setSelected:NO];
    }
    
    dataViewController.view.tag = index;
    dataViewController.view.backgroundColor = [UIColor clearColor] ;
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(ALiSingleImageController *)viewController {
    return viewController.view.tag;
}

#pragma mark - UIPageViewControllerDelegate,UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController:(ALiSingleImageController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    UIViewController * vc = [self viewControllerAtIndex:index];
    vc.view.backgroundColor = [UIColor clearColor];
    return vc;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController:(ALiSingleImageController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self getCount]) {
        return nil;
    }
    UIViewController *vc = [self viewControllerAtIndex:index];
    vc.view.backgroundColor = [UIColor clearColor] ;
    return vc ;
}

#pragma mark -UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        self.currentIndex = [self indexOfViewController:(ALiSingleImageController *)[self.pageViewController.viewControllers objectAtIndex:0]];
    }
}

#pragma mark - Lazy Load

- (UIPageViewController *)pageViewController{
    if (!_pageViewController) {
        
        NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey: UIPageViewControllerOptionSpineLocationKey];
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options: options];
        _pageViewController.dataSource = self;
        _pageViewController.delegate = self;
        
        [self addChildViewController:_pageViewController];
        [self.view addSubview:[_pageViewController view]];
    }
    return _pageViewController;
}

- (ALiImageBrowserTopToolBar *)topToolBar
{
    if (_topToolBar == nil) {
        _topToolBar = [[ALiImageBrowserTopToolBar alloc] init];
        [self.pageViewController.view addSubview:_topToolBar];
        [self.pageViewController.view bringSubviewToFront:_topToolBar];
    }
    return _topToolBar;
}


- (ALiImageBrowserBottomToolBar *)bottomToolBar
{
    if (_bottomToolBar == nil) {
        _bottomToolBar = [[ALiImageBrowserBottomToolBar alloc] init];
        [self.pageViewController.view addSubview:_bottomToolBar];
        [self.pageViewController.view bringSubviewToFront:_bottomToolBar];
    }
    return _bottomToolBar;
}

@end
