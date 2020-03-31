//
//  SmoothMoveViewController.m
//  QMapScenarioDemo
//
//  Created by Zhang Tian on 2019/9/23.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "SmoothMoveViewController.h"

@implementation CarLocation

@end

@implementation RoutePolyline

@end

@implementation CarAnnotation

@end

@interface SmoothMoveViewController () <QMSSearchDelegate>

@property (nonatomic, strong) QMSSearcher *searcher;

@property (nonatomic, strong) RoutePolyline *routePolyline;

@property (nonatomic, strong) CarAnnotation *carAnnotation;

@property (nonatomic, strong) NSMutableArray<CarLocation *> *carLocations;

@end

@implementation SmoothMoveViewController

#pragma mark - Override

- (void)handleTestAction
{
    QAnnotationView *annotationView = [self.mapView viewForAnnotation:self.carAnnotation];
    
    [QMUAnnotationAnimator translateWithAnnotationView:annotationView locations:self.carLocations duration:360 rotateEnabled:YES];
}

- (NSString *)testTitle
{
    return @"开始";
}

#pragma mark - QMapViewDelegate

- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id <QAnnotation>)annotation
{
    if ([annotation isMemberOfClass:[CarAnnotation class]])
    {
        QAnnotationView *annotationView = [[QAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
        
        annotationView.transform    = CGAffineTransformMakeRotation(M_PI / 2);
        annotationView.image        = [UIImage imageNamed:@"car"];
        
        return annotationView;
    }
    
    return nil;
}

- (QOverlayView *)mapView:(QMapView *)mapView viewForOverlay:(id<QOverlay>)overlay
{
    if ([overlay isKindOfClass:[QPolyline class]])
    {
        RoutePolyline *routePolyline = (RoutePolyline *)overlay;
        
        QTexturePolylineView *polylineRender = [[QTexturePolylineView alloc] initWithPolyline:overlay];
        polylineRender.lineWidth    = 8;
        polylineRender.drawSymbol   = YES;
        polylineRender.segmentStyle = routePolyline.style;
        
        return polylineRender;
    }
    
    return nil;
}

#pragma mark - Route & Overlay

- (void)addCarAnnotationWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (!CLLocationCoordinate2DIsValid(coordinate))
    {
        return;
    }
    
    self.carAnnotation = [[CarAnnotation alloc] init];
    self.carAnnotation.coordinate = coordinate;

    [self.mapView addAnnotation:self.carAnnotation];
}

- (void)addRoutePolylineWithRoutePlan:(QMSRoutePlan *)routePlan
{
    NSArray *polyline = routePlan.polyline;
    
    CLLocationCoordinate2D coordinates[polyline.count];
    
    for (int i = 0; i < polyline.count; i++)
    {
        CLLocationCoordinate2D coordinate;
        NSValue *value = polyline[i];
        [value getValue:&coordinate];
        
        coordinates[i] = coordinate;
        
        CarLocation *carLocation = [[CarLocation alloc] init];
        carLocation.coordinate = coordinate;
        [self.carLocations addObject:carLocation];
    }
    
    RoutePolyline *routePolyline = [[RoutePolyline alloc] initWithCoordinates:coordinates count:polyline.count];
    
    QSegmentStyle *segmentStyle = [[QSegmentStyle alloc] init];
    segmentStyle.startIndex         = 0;
    segmentStyle.endIndex           = (int)polyline.count - 1;
    segmentStyle.colorImageIndex    = 1;
    
    routePolyline.style = @[segmentStyle];
    
    [self.mapView addOverlay:routePolyline];
    
    [self.mapView setVisibleMapRect:routePolyline.boundingMapRect edgePadding:UIEdgeInsetsMake(40, 40, 40, 40) animated:YES];
}

#pragma mark - QMSSearchDelegate

- (void)searchWithDrivingRouteSearchOption:(QMSDrivingRouteSearchOption *)drivingRouteSearchOption didRecevieResult:(QMSDrivingRouteSearchResult *)drivingRouteSearchResult
{
    QMSRoutePlan *routePlan = drivingRouteSearchResult.routes.firstObject;
    
    if (routePlan == nil)
    {
        return;
    }
    
    [self addRoutePolylineWithRoutePlan:routePlan];
    [self addCarAnnotationWithCoordinate:self.carLocations.firstObject.coordinate];
}

#pragma mark - Route Search

- (void)searchDrivingRoute
{
    QMSDrivingRouteSearchOption *option = [[QMSDrivingRouteSearchOption alloc] init];
    [option setPolicyWithType:QMSDrivingRoutePolicyTypeLeastDistance];
    [option setFrom:@"40.040415,116.273511"];
    [option setTo:@"39.953099,116.369802"];
    
    [self.searcher searchWithDrivingRouteSearchOption:option];
}

#pragma mark - Setup

- (void)setupSelf
{
    self.searcher = [[QMSSearcher alloc] initWithDelegate:self];
    
    self.carLocations = [NSMutableArray array];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.mapView.rotateEnabled = NO;
//    self.mapView.overlookingEnabled = NO;
    
    [self setupSelf];
    
    [self searchDrivingRoute];
    
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(40.040415,116.273511) animated:YES];
}

@end
