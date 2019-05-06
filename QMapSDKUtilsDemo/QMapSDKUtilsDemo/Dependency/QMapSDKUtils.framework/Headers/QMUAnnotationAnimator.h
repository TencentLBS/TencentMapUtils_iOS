//
//  QMUAnnotationAnimator.h
//  QMapSDKUtils
//
//  Created by 薛程 on 2019/1/8.
//  Copyright © 2019年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <QMapKit/QAnnotationView.h>

/**
 * @brief  位置协议.
 */
@protocol QMULocation <NSObject>

@required

/**
 * @brief  经纬度信息.
 */
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

/**
 * @brief  平滑移动控制类.
 */
@interface QMUAnnotationAnimator : NSObject

/**
 * @brief  执行平滑移动动画. 该方法支仅持地图在2D正北状态下进行.
 * @param annotationView  平滑移动的对象
 * @param locations     平滑移动需要经过的经纬度坐标点串
 * @param duration        平滑移动时间
 * @param needRotate      平滑移动过程中annotationView是否需要沿移动方向执行旋转动画
 */
+ (void)translateWithAnnotationView:(QAnnotationView *)annotationView
                          locations:(NSArray<id <QMULocation> > *)locations
                           duration:(CFTimeInterval)duration
                      rotateEnabled:(BOOL)needRotate;

@end



