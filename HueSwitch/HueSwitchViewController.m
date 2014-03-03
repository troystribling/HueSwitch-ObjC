//
//  HueSwitchViewController.m
//  HueSwitch
//
//  Created by Troy Stribling on 3/1/14.
//  Copyright (c) 2014 gnos.us. All rights reserved.
//

#import "HueSwitchViewController.h"
#import "HueSwitchStatusViewController.h"
#import "HueSwitchScenesViewController.h"
#import "HueSwitchConfigureLocationViewController.h"

#define NUM
@interface HueSwitchViewController ()

@property(nonatomic, strong) UIPageViewController*  pageViewController;

@end

@implementation HueSwitchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    [self.pageViewController setViewControllers:@[[self.storyboard instantiateViewControllerWithIdentifier:@"HueSwitchStatusViewController"]]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private -

#pragma mark - UIPageViewControllerDataSource -

- (UIViewController*)pageViewController:(UIPageViewController*)pageViewController viewControllerAfterViewController:(UIViewController*)viewController {
    UIViewController* nextViewController = nil;
    if ([viewController isKindOfClass:[HueSwitchStatusViewController class]]) {
        nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HueSwitchScenesViewController"];
    } else if ([viewController isKindOfClass:[HueSwitchScenesViewController class]]) {
        nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HueSwitchConfigureLocationViewController"];
    } else if ([viewController isKindOfClass:[HueSwitchConfigureLocationViewController class]]) {
        nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HueSwitchConfigureAutoSwitchViewController"];
    } else {
        nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HueSwitchStatusViewController"];
    }
    return nextViewController;
}

- (UIViewController*)pageViewController:(UIPageViewController*)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    UIViewController* nextViewController = nil;
    if ([viewController isKindOfClass:[HueSwitchStatusViewController class]]) {
        nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HueSwitchConfigureAutoSwitchViewController"];
    } else if ([viewController isKindOfClass:[HueSwitchScenesViewController class]]) {
        nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HueSwitchStatusViewController"];
    } else  if ([viewController isKindOfClass:[HueSwitchConfigureLocationViewController class]]){
        nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HueSwitchScenesViewController"];
    } else {
        nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HueSwitchConfigureAutoSwitchViewController"];
    }
    return nextViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController*)pageViewController {
    return 4;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController*)pageViewController {
    return 0;
}

@end
