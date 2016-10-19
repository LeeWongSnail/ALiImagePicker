//
//  ALiImageBrowserController.m
//  ALiImagePicker
//
//  Created by LeeWong on 2016/10/18.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "ALiImageBrowserController.h"
#import "ALiSingleImageController.h"

@interface ALiImageBrowserController () <UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property (nonatomic, strong) UIPageViewController *pageViewController;

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation ALiImageBrowserController

#pragma mark - Load View

- (void)initPageViewController
{
    CGRect rect = [UIScreen mainScreen].bounds;
    self.pageViewController.view.frame = CGRectMake(0, 0, rect.size.width + 20, rect.size.height);
    ALiSingleImageController *initialViewController = [self viewControllerAtIndex:self.currentIndex];
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

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initPageViewController];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
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
//    id<ArtImageItemProtocol> item = [self contentAtIndex: index];
//    dataViewController.imageItem = [item getBigImage];
//    if ([item respondsToSelector:@selector(getThumbImage)]) {
//        dataViewController.imageThumbItem = [item getThumbImage];
//    }
//    dataViewController.delegate = self;
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
        //        self.pageLabel.text = [NSString stringWithFormat:@"%@ / %@", @(self.currentIndex + 1), @([self getCount])];
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

@end
