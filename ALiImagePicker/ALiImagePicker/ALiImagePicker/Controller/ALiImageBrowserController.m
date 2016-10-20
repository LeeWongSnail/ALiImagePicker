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

@interface ALiImageBrowserController () <UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property (nonatomic, strong) UIPageViewController *pageViewController;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) ALiImageBrowserTopToolBar *topToolBar;

@property (nonatomic, strong) ALiImageBrowserBottomToolBar *bottomToolBar;

@end

@implementation ALiImageBrowserController

//点击选中图片
- (void)selectImageAction:(UIButton *)button
{
    [self.topToolBar.selectBtn setSelected:!self.topToolBar.selectBtn.isSelected];
    [self.bottomToolBar.fullImageBtn setSelected:!self.bottomToolBar.fullImageBtn.isSelected];
    [self.bottomToolBar.fullTitleButton setSelected:!self.bottomToolBar.fullTitleButton.isSelected];
    
    //显示这张图片的信息
    if (button.isSelected) {
        [self.bottomToolBar.fullTitleButton setTitle:@"Full Image(2.3M)" forState:UIControlStateSelected];
        if (self.selectedAsset.count > 0) {
            [self.bottomToolBar.selectedCountBtn setTitle:[NSString stringWithFormat:@"%tu",self.selectedAsset.count] forState:UIControlStateSelected];
        } else {
            
            [self.bottomToolBar.selectedCountBtn setTitle:@"" forState:UIControlStateNormal];
        }
    } else {
        [self.bottomToolBar.fullTitleButton setTitle:@"Full Image" forState:UIControlStateSelected];
        
    }
    
    if (button.isSelected) {
        [self.selectedAsset addObject:[self.allAssets objectAtIndex:self.curIndex]];
    } else {
        [self.selectedAsset removeObject:[self.allAssets objectAtIndex:self.curIndex]];
    }
    
}

//点击原图
- (void)fullImageBtnAction:(UIButton *)button
{
    [self.bottomToolBar.fullImageBtn setSelected:!self.bottomToolBar.fullImageBtn.isSelected];
    [self.bottomToolBar.fullTitleButton setSelected:!self.bottomToolBar.fullTitleButton.isSelected];
    [self.topToolBar.selectBtn setSelected:!self.topToolBar.selectBtn.isSelected];
    
    //显示这张图片的信息
    if (button.isSelected) {
        [self.bottomToolBar.fullTitleButton setTitle:@"Full Image(2.3M)" forState:UIControlStateSelected];
        if (![self.selectedAsset containsObject:[self.allAssets objectAtIndex:self.curIndex]]) {
            [self.selectedAsset addObject:[self.allAssets objectAtIndex:self.curIndex]];
        }
    } else {
        [self.bottomToolBar.fullTitleButton setTitle:@"Full Image" forState:UIControlStateSelected];
        [self.selectedAsset addObject:[self.allAssets objectAtIndex:self.curIndex]];
    }
}

//点击发送
- (void)sendImage:(UIButton *)button
{
    if (self.photoChooseBlock) {
        self.photoChooseBlock([self.selectedAsset copy]);
    }
}

- (void)back
{
    //    if (self.photoChooseBlock) {
    //        self.photoChooseBlock(self)
    //    }
    [self.navigationController popViewControllerAnimated:YES];
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
    
    self.bottomToolBar.frame = CGRectMake(0, SCREEN_H-64, SCREEN_W, 64);
    
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
    dataViewController.asset = self.allAssets[index];
    
    if ([self.selectedAsset containsObject:self.allAssets[index]]) {
        [self selectImageAction:self.topToolBar.selectBtn];
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
        ALiAsset *asset = [self.allAssets objectAtIndex:self.currentIndex];
        if ([self.selectedAsset containsObject:asset]) {
            //设置为选中状态
            [self selectImageAction:self.topToolBar.selectBtn];
        }
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
