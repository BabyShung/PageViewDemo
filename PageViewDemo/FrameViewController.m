//
//  ViewController.m
//  PageViewDemo
//
//  Created by Simon on 24/11/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "FrameViewController.h"

#define TARBAR_HEIGHT 50

@interface FrameViewController ()

@property (nonatomic,strong) UIViewController *VC1;
@property (nonatomic,strong) UIViewController *VC2;
@property (nonatomic,strong) UIViewController *VC3;
@property (nonatomic,strong) UIViewController *VC4;

@property (strong, nonatomic) NSMutableArray *menu;

@end

@implementation FrameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Create the data model
    _pageTitles = @[@"Over 200 Tips and Tricks", @"Discover Hidden Features", @"Bookmark Favorite Tip", @"Free Regular Update"];
    _pageImages = @[@"page1.png", @"page2.png", @"page3.png", @"page4.png"];
    
    //init all the viewControllers
    self.VC1 = [self.storyboard instantiateViewControllerWithIdentifier:@"ContentViewController"];
    self.VC2 = [self.storyboard instantiateViewControllerWithIdentifier:@"ContentViewController"];
    self.VC3 = [self.storyboard instantiateViewControllerWithIdentifier:@"ContentViewController"];
    self.VC4 = [self.storyboard instantiateViewControllerWithIdentifier:@"ContentViewController"];
    self.menu = [NSMutableArray arrayWithObjects:self.VC1, self.VC2,self.VC3,self.VC4, nil];
    for(int i = 0;i<[self.menu count];i++){
        ContentViewController *tmp = self.menu[i];
        tmp.imageFile = self.pageImages[i];
        tmp.titleText = self.pageTitles[i];
        tmp.pageIndex = i;
    }
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageVC"];
    self.pageViewController.dataSource = self;
    
    UIViewController *startingVC = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingVC];
    
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - TARBAR_HEIGHT);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];

}

- (IBAction)startWalkthrough:(id)sender {
    UIViewController *startingVC = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingVC];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    NSLog(@"VC index: %d",index);
    
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
  
    return self.menu[index];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((ContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((ContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

//
//- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
//{
//    return [self.pageTitles count];
//}

//- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
//{
//    return 0;
//}

@end
