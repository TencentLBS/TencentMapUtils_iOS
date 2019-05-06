//
//  BaseSynchroViewController.m
//  QMapSDKUtilsDemo
//
//  Created by 薛程 on 2018/11/27.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import "BaseMapViewController.h"

@implementation BaseMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupMap];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)setupMap
{
    self.mapView = [[QMapView alloc] initWithFrame:self.view.bounds];
    
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = NO;
    self.mapView.rotateEnabled = NO;
    self.mapView.overlookingEnabled = NO;
    
    [self.view addSubview:self.mapView];
}


@end
