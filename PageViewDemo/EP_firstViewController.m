//
//  EP_firstViewController.m
//  PageViewDemo
//
//  Created by Hao Zheng on 5/23/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "EP_firstViewController.h"

@interface EP_firstViewController ()

@end

@implementation EP_firstViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"did load 1!");
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self.delegate checkTabbarStatus:self.pageIndex];
}


@end
