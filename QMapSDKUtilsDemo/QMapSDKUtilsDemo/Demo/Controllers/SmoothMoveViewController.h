//
//  SmoothMoveViewController.h
//  QMapScenarioDemo
//
//  Created by Zhang Tian on 2019/9/23.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "BaseMapViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CarLocation : NSObject <QMULocation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

@interface RoutePolyline : QPolyline

@property (nonatomic, strong) NSArray<QSegmentStyle *> *style;

@end

@interface CarAnnotation : QPointAnnotation

@end

@interface SmoothMoveViewController : BaseMapViewController

@end

NS_ASSUME_NONNULL_END
