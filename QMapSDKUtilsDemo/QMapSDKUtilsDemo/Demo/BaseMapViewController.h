//
//  BaseMapViewController.h
//  QMapSDKUtilsDemo
//
//  Created by 薛程 on 2018/11/27.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QMapKit/QMapKit.h>

@interface BaseMapViewController : UIViewController <QMapViewDelegate>

@property (nonatomic, strong, nullable) QMapView *mapView;

@end
