//
//  FrameViewController.h
//  PageViewDemo
//
//  Created by Hao Zheng on 5/23/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "FrameViewController.h"
#import "EParentViewController.h"


@class EP_firstViewController;
@class EP_secondViewController;
@class EP_thirdViewController;
@class EP_forthViewController;

#define TARBAR_HEIGHT 50
#define UPPOINT CGPointMake(160.0f, 543.0f)
#define BOTTOMPOINT CGPointMake(160.0f, 593.0f)


@interface FrameViewController () <EParentVCDelegate>

@property (nonatomic,strong) EP_firstViewController *VC1;
@property (nonatomic,strong) EP_secondViewController *VC2;
@property (nonatomic,strong) EP_thirdViewController *VC3;
@property (nonatomic,strong) EP_forthViewController *VC4;

@property (strong, nonatomic) NSMutableArray *menu;


@end

@implementation FrameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    //init all the viewControllers
    self.VC1 = [self.storyboard instantiateViewControllerWithIdentifier:@"vc1"];
    self.VC2 = [self.storyboard instantiateViewControllerWithIdentifier:@"vc2"];
    self.VC3 = [self.storyboard instantiateViewControllerWithIdentifier:@"vc3"];
    self.VC4 = [self.storyboard instantiateViewControllerWithIdentifier:@"vc4"];
    self.menu = [NSMutableArray arrayWithObjects:self.VC1, self.VC2,self.VC3,self.VC4, nil];
    for(int i = 0;i<[self.menu count];i++){
        EParentViewController *tmp = self.menu[i];
        tmp.pageIndex = i;
        tmp.delegate = self;
    }
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageVC"];
    self.pageViewController.dataSource = self;
    
    //assign the which view to be the first to show
    UIViewController *startingVC = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingVC];
    
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];

    
    [self.view bringSubviewToFront:self.tabbarView];
    
    
}

-(void)checkTabbarStatus:(NSUInteger)index{
    if(index == 0){
        [self hideTabbarView];
    }else{
        [self showTabbarView];
    }
}


-(void)showTabbarView{
    if(CGPointEqualToPoint(self.tabbarView.center, BOTTOMPOINT)){
        [UIView animateWithDuration:0.6 animations:^{   //go up
            self.tabbarView.center = UPPOINT;
            self.tabbarView.alpha = 1;
        }];
    }

}

-(void)hideTabbarView{
    if(CGPointEqualToPoint(self.tabbarView.center, UPPOINT)){
        [UIView animateWithDuration:0.5 animations:^{   //go down
            self.tabbarView.center = BOTTOMPOINT;
            self.tabbarView.alpha = 0.8;
        }];
    }
}


-(void)dealloc{
     NSLog(@"dealloc...");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"toggleTabbar" object:nil];
}

//tab button click
- (IBAction)clickBtn:(UIButton *)sender {
    NSLog(@"tag: %d", sender.tag);
    NSUInteger index = sender.tag;
    
    [self checkTabbarStatus:index];
    
    UIViewController *startingVC = [self viewControllerAtIndex:index];
    NSArray *viewControllers = @[startingVC];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}


- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    NSLog(@"VC index: %d",index);
    
    if (([self.menu count] == 0) || (index >= [self.menu count])) {
        return nil;
    }
  
    //[self evaluateTarbar:index];
    return self.menu[index];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((EParentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((EParentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.menu count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}


//- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
//{
//    return [self.pageTitles count];
//}

//- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
//{
//    return 0;
//}

@end
