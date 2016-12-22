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
    ALiAsset *asset = self.allAssets[self.currentIndex];
    asset.selected = !asset.isSelected;
    if (asset.selected) {
        [self.selectedAsset addObject:asset];
    } else {
        [self.selectedAsset removeObject:asset];
    }
    [self configSelectCountBtn:asset.isSelected];
}

#pragma mark - 点击FullImage

- (void)fullImageDidClick:(UIButton *)aButton
{
    [aButton setSelected:!aButton.isSelected];
    ALiAsset *asset = self.allAssets[self.currentIndex];
    asset.fullImage = !asset.isFullImage;
    [self.bottomToolBar.fullTitleButton setSelected:asset.isFullImage];
    if (asset.isFullImage) {
        [self.bottomToolBar.fullTitleButton setTitle:[NSString stringWithFormat:@"Full Image(%.2lfM)",asset.imageSize] forState:UIControlStateSelected];
    } else {
        [self.bottomToolBar.fullTitleButton setTitle:@"Full Image" forState:UIControlStateNormal];
    }
    if (!asset.isSelected) {
        asset.selected = asset.isFullImage;
        [self.topToolBar.selectBtn setSelected:asset.isSelected];
        [self.selectedAsset addObject:asset];
    }
    [self configSelectCountBtn:asset.isSelected];
}

- (void)configSelectCountBtn:(BOOL)isAdd
{
    NSInteger count = [[self.bottomToolBar.selectedCountBtn currentTitle] integerValue] + (isAdd? 1 : -1);
    if (count > 0) {
        [self.bottomToolBar.selectedCountBtn setSelected:YES];
        [self.bottomToolBar.selectedCountBtn setTitle:[NSString stringWithFormat:@"%tu",count] forState:UIControlStateSelected];
        self.bottomToolBar.selectedCountBtn.hidden = NO;
    } else {
        [self.bottomToolBar.selectedCountBtn setSelected:NO];
        self.bottomToolBar.selectedCountBtn.hidden = YES;
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
    
    [self.bottomToolBar.fullImageBtn addTarget:self action:@selector(fullImageDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomToolBar.fullTitleButton addTarget:self action:@selector(fullImageDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomToolBar.sendBtn addTarget:self action:@selector(sendImage:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomToolBar.selectedCountBtn addTarget:self action:@selector(sendImage:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Load View

- (void)configCurrentPageToolUI:(ALiAsset *)asset
{
    [self.topToolBar.selectBtn setSelected:asset.isSelected];
    [self.bottomToolBar.fullTitleButton setSelected:asset.isFullImage];
    [self.bottomToolBar.fullImageBtn setSelected:asset.isFullImage];
}

- (void)initPageViewController
{
    CGRect rect = [UIScreen mainScreen].bounds;
    self.pageViewController.view.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
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
    self.bottomToolBar.frame = CGRectMake(0, SCREEN_H-64, SCREEN_W, 64);
    self.view.backgroundColor = [UIColor blackColor];
    [self initPageViewController];
    [self configToolBarEventHandler];
    self.topToolBar.pageLabel.text = [NSString stringWithFormat:@"%tu/%tu",self.curIndex,self.allAssets.count-1];
    if (self.selectedAsset.count > 0) {
        [self.bottomToolBar.selectedCountBtn setSelected:YES];
        [self.bottomToolBar.selectedCountBtn setTitle:[NSString stringWithFormat:@"%tu",self.selectedAsset.count] forState:UIControlStateSelected];
        self.bottomToolBar.sendBtn.enabled = YES;
    } else {
        self.bottomToolBar.sendBtn.enabled = NO;
    }
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
    if ([self.allAssets[index] isKindOfClass:[NSString class]]) {
        //如果是拍照按钮
        return nil;
    }
    ALiAsset *asset = self.allAssets[index];
    ALiSingleImageController *dataViewController = [[ALiSingleImageController alloc] init];
    dataViewController.asset = asset;
    
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
        ALiAsset *asset = self.allAssets[self.currentIndex];
        [self configCurrentPageToolUI:asset];
        self.topToolBar.pageLabel.text = [NSString stringWithFormat:@"%tu/%tu",self.currentIndex+1,self.allAssets.count];
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
