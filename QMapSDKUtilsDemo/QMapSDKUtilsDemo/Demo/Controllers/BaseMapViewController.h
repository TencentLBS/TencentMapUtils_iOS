//
//  BaseMapViewController.h
//  QMapKitDemoNew
//
//  Created by tabsong on 17/5/11.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QMapKit/QMapKit.h>
#import <QMapKit/QMSSearchKit.h>
#import <QMapSDKUtils/QMUMapUtils.h>

@interface BaseMapViewController : UIViewController <QMapViewDelegate>

@property (nonatomic, strong, readonly) QMapView *mapView;

#pragma mark - Override

- (void)handleTestAction;

- (NSString *)testTitle;

@end
