//
//  AnnotationAnimatorViewController.m
//  QMapSDKUtilsDemo
//
//  Created by 薛程 on 2019/1/9.
//  Copyright © 2019年 tencent. All rights reserved.
//

#import "AnnotationAnimatorViewController.h"
#import <TNKNavigationKit/TNKNavigationKit.h>
#import <QMapSDKUtils/QMUMapUtils.h>
#import "TrafficPolyline.h"
#import "CarAnnotation.h"

#define Degree2Radian(degree) ( M_PI * (degree) / 180 )

@interface AnnotationAnimatorViewController ()

@property (nonatomic, strong) TNKCarNaviManager *searcher;

@property (nonatomic, strong) TrafficPolyline *trafficLine;

@property (nonatomic, strong) CarAnnotation *driverPoint;

@property (nonatomic, strong) NSArray <TNKCoordinatePoint *> *points;

@end

@implementation AnnotationAnimatorViewController

- (void)setNavigationItem
{
    UIBarButtonItem *action = [[UIBarButtonItem alloc] initWithTitle:@"平滑移动"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(startTranslateAnimation)];
    self.navigationItem.rightBarButtonItem = action;
}

- (void)startTranslateAnimation
{
    [QMUAnnotationAnimator translateWithAnnotationView:[self.mapView viewForAnnotation:self.driverPoint]
                                             locations:self.points duration:500 rotateEnabled:YES];
}

- (void)setupSearcher
{
    self.searcher = [[TNKCarNaviManager alloc]init];
}

- (void)setupAnnotation
{
    self.driverPoint = [[CarAnnotation alloc] init];
    self.driverPoint.coordinate = self.points.firstObject.coordinate;

    [self.mapView addAnnotation:self.driverPoint];
}

- (TrafficPolyline *)polylineForNaviResult:(TNKCarRouteSearchResult *)result
{
    if (result.routes.count == 0)
    {
        NSLog(@"route.count = 0");
        return nil;
    }
    TNKCarRouteSearchRoutePlan *plan = result.routes[0];
    TNKCarRouteSearchRouteLine *line = plan.line;
    
    NSArray<TNKCarRouteSearchRouteSegmentStyle*> *steps = line.segmentStyles;
    int count = (int)line.coordinatePoints.count;
    CLLocationCoordinate2D *coordinateArray = (CLLocationCoordinate2D*)malloc(sizeof(CLLocationCoordinate2D)*count);
    
    for (int i = 0; i < count; ++i)
    {
        coordinateArray[i] = [(TNKCoordinatePoint*)[line.coordinatePoints objectAtIndex:i] coordinate];
    }
    
    NSMutableArray* routeLineArray = [NSMutableArray array];
    for (TNKCarRouteSearchRouteSegmentStyle *seg in steps) {
        QSegmentStyle *subLine = [[QSegmentStyle alloc] init];
        subLine.startIndex = (int)seg.startNum;
        subLine.endIndex   = (int)seg.endNum;
        subLine.colorImageIndex = [self transformColorIndex:seg.colorIndex];
        [routeLineArray addObject:subLine];
    }
    
    // 创建路线,一条路线由一个点数组和线段数组组成
    TrafficPolyline *routeOverlay = [[TrafficPolyline alloc] initWithCoordinates:coordinateArray count:count arrLine:routeLineArray];
    
    free(coordinateArray);
    
    return routeOverlay;
}

- (int)transformColorIndex:(NSUInteger)index
{
    switch (index)
    {
        case 0:
            return 4;
        case 1:
            return 3;
        case 2:
            return 2;
        case 3:
            return 1;
        case 4:
            return 9;
        default:
            return 1;
    }
}

- (QMapRect)visibleMapRectForNaviResult:(TNKCarRouteSearchResult *)result
{
    NSAssert(result.routes.count != 0, @"route count 0 error");
    
    TNKCarRouteSearchRoutePlan *plan = result.routes[0];
    TNKCarRouteSearchRouteLine *line = plan.line;
    
    QMapPoint points[line.coordinatePoints.count];
    
    for(int i=0;i<line.coordinatePoints.count;++i)
    {
        points[i] = QMapPointForCoordinate(line.coordinatePoints[i].coordinate);
    }
    
    return QBoundingMapRectWithPoints(points, line.coordinatePoints.count);
}

- (QOverlayView *)mapView:(QMapView *)mapView viewForOverlay:(id<QOverlay>)overlay
{
    if ([overlay isKindOfClass:[TrafficPolyline class]])
    {
        TrafficPolyline *tl = (TrafficPolyline*)overlay;
        QTexturePolylineView *polylineRender = [[QTexturePolylineView alloc] initWithPolyline:overlay];
        polylineRender.segmentStyle = tl.arrLine;
        polylineRender.borderColor = [UIColor colorWithRed:0 green:0.8 blue:0 alpha:0.15];
        polylineRender.lineWidth   = 10;
        polylineRender.borderWidth = 1;
        polylineRender.drawSymbol = YES;
        polylineRender.strokeColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:.248];
        
        return polylineRender;
    }

    return nil;
}

- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation
{
    if ([annotation isMemberOfClass:[CarAnnotation class]])
    {
        QAnnotationView *annotationView = [[QAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
        
        annotationView.transform = CGAffineTransformMakeRotation(Degree2Radian(40));
        
        UIImage *img = [UIImage imageNamed:@"map_icon_driver"];
        
        annotationView.image = img;
        
        return annotationView;
    }

    return nil;
}

- (void)searchRoute
{
    TNKSearchNaviPoi *start = [[TNKSearchNaviPoi alloc] init];
    start.coordinate = CLLocationCoordinate2DMake(39.974697,116.301672);
    
    TNKSearchNaviPoi *dest = [[TNKSearchNaviPoi alloc] init];
    dest.coordinate = CLLocationCoordinate2DMake(39.896835,116.319423);
    
    TNKCarRouteSearchOption *option = [[TNKCarRouteSearchOption alloc] init];
    option.avoidTrafficJam = YES;
    
    TNKCarRouteSearchRequest *request = [[TNKCarRouteSearchRequest alloc] init];
    request.startPoint = start;
    request.destinationPoint = dest;
    request.searchOption = option;
    
    __weak __typeof(self) weakSelf = self;
    
    [self.searcher searchNavigationRoutesWithRequest:request completion:^(TNKCarRouteSearchResult *result, NSError *error) {
        
        if(error == nil)
        {
            weakSelf.trafficLine = [weakSelf polylineForNaviResult:result];
            
            weakSelf.points = result.routes[0].line.coordinatePoints;
            
            [weakSelf.mapView addOverlay:weakSelf.trafficLine];
            
            QMapRect mapRect = [weakSelf visibleMapRectForNaviResult:result];
            
            [weakSelf.mapView setVisibleMapRect:mapRect edgePadding:UIEdgeInsetsMake(80, 40, 80, 40) animated:NO];
            
            [weakSelf setupAnnotation];
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationItem];
    
    [self setupSearcher];
    
    [self searchRoute];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
