//
//  PointClusterViewController.h
//  QMapScenarioDemo
//
//  Created by Zhang Tian on 2019/9/24.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "BaseMapViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TypedClustableAnnotation : QMUAnnotation

// male, female or other custom values.
@property (nonatomic, assign) int type;

@end

@interface PointClusterViewController : BaseMapViewController

@end

NS_ASSUME_NONNULL_END
