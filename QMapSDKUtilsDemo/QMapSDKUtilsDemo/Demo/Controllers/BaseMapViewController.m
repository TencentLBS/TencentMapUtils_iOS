//
//  BaseMapViewController.m
//  QMapKitDebugging
//
//  Created by tabsong on 17/5/15.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "BaseMapViewController.h"

@interface BaseMapViewController ()

@property (nonatomic, strong, readwrite) QMapView *mapView;

@end

@implementation BaseMapViewController

#pragma mark - Override

- (void)handleTestAction
{
    
}

- (NSString *)testTitle
{
    return @"Test";
}

#pragma mark - Setup

- (void)setupNavigationBar
{
    self.navigationController.navigationBar.translucent = NO;
    
    UIBarButtonItem *testItem = [[UIBarButtonItem alloc] initWithTitle:[self testTitle]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(handleTestAction)];
    self.navigationItem.rightBarButtonItem = testItem;
}

- (void)setupMapView
{
    self.mapView = [[QMapView alloc]
                    initWithFrame:CGRectMake(0,
                                             0,
                                             CGRectGetWidth(self.view.frame),
                                             CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.navigationController.navigationBar.frame))];
    self.mapView.delegate = self;
    
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(39.901268, 116.403854);
    self.mapView.zoomLevel        = 11;
    
    [self.view addSubview:self.mapView];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavigationBar];
    
    [self setupMapView];
}

@end
