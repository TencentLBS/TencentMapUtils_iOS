//
//  PointClusterViewController.m
//  QMapScenarioDemo
//
//  Created by Zhang Tian on 2019/9/24.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "PointClusterViewController.h"

@implementation TypedClustableAnnotation

- (id)copyWithZone:(nullable NSZone *)zone
{
    TypedClustableAnnotation* copy = [[super copyWithZone:zone] init];
    copy.type = self.type;
    return self;
}

/// 可根据自己的业务需要来决定是否重载和如何实现重载.
- (BOOL)isEqual:(id)object
{
    if (self.type != [(TypedClustableAnnotation*)object type])
    {
        return NO;
    }
    
    return [super isEqual:object];
}

@end

@interface PointClusterViewController () <QMUClusterProtocol>

@property (nonatomic, strong) QMUClusterManager *manager;

@property (nonatomic, strong) NSMutableArray *originAnnotations;

@property (nonatomic, assign) BOOL isCustom;

@end

@implementation PointClusterViewController

- (void)handleTestAction {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择聚合类型" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    __weak typeof(self) weakSelf = self;
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"默认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.isCustom = NO;
        [self.manager clearAnnotations];
        [self addClusters];
        [weakSelf.manager refreshCluster];
    }];
    UIAlertAction *customAction = [UIAlertAction actionWithTitle:@"自定义" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.isCustom = YES;
        [self.manager clearAnnotations];
        [self addClusters];
        [weakSelf.manager refreshCluster];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:defaultAction];
    [alertController addAction:customAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (NSString *)testTitle {
    return @"切换";
}

#pragma mark - QMUClusterProtocol

- (BOOL)clusterAnnotation:(QMUAnnotation*)anno1 withAnnotation:(QMUAnnotation*)anno2
{
    return YES;
}

#pragma mark - QMapViewDelegate

- (void)mapView:(QMapView *)mapView regionDidChangeAnimated:(BOOL)animated gesture:(BOOL)bGesture
{
    // 需要在合适的时机调用刷新接口，比如视野变动
    [self.manager refreshCluster];
}

- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation
{
    if ([annotation isKindOfClass:[QMUClusterAnnotation class]])
    {
        QMUClusterAnnotation* clusterAnnotation = (QMUClusterAnnotation*)annotation;
        
        if (clusterAnnotation.count > 1)
        {
            static NSString *clusterReuseIndetifier = @"cluster";
            
            QMUClusterAnnotationView *annotationView = (QMUClusterAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:clusterReuseIndetifier];
            if (annotationView == nil)
            {
                annotationView = [[QMUClusterAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:clusterReuseIndetifier];
            }
            
            annotationView.backgroundColor = [UIColor colorWithRed:0.5 green:0.6 blue:0.45 alpha:0.8];
            annotationView.displayText.text = [[NSNumber numberWithUnsignedInteger:clusterAnnotation.count] stringValue];
            
            if (clusterAnnotation.count >= 100)
            {
                annotationView.displayText.text = [[[NSNumber numberWithUnsignedInteger:clusterAnnotation.count / 100 * 100] stringValue] stringByAppendingString:@"+"];
                annotationView.backgroundColor = [UIColor colorWithRed:0.8 green:0.3 blue:0.3 alpha:0.8];
            }
            else if (clusterAnnotation.count >= 10)
            {
                annotationView.displayText.text = [[[NSNumber numberWithUnsignedInteger:clusterAnnotation.count / 10 * 10] stringValue] stringByAppendingString:@"+"];
                annotationView.backgroundColor = [UIColor colorWithRed:0.9 green:0.5 blue:0.2 alpha:0.7];
            }
            
            if (_isCustom) {
                if (clusterAnnotation.count > 30) {
                    annotationView.image = [UIImage imageNamed:@"hongbao"];
                    annotationView.backgroundColor = [UIColor clearColor];
                    annotationView.bounds               = CGRectMake(0, 0, 30, 40);
                } else {
                    annotationView.bounds               = CGRectMake(0, 0, self.manager.distance, self.manager.distance);
                    annotationView.layer.cornerRadius   = self.manager.distance / 2;
                }
            } else {
                annotationView.bounds               = CGRectMake(0, 0, self.manager.distance, self.manager.distance);
                annotationView.layer.cornerRadius   = self.manager.distance / 2;
            }
            
            return annotationView;
            
        }
        else
        {
            static NSString *hippoReuseIndetifier = @"clusterOrigin";
            QAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:hippoReuseIndetifier];
            if (annotationView == nil)
            {
                annotationView = [[QMUClusterAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:hippoReuseIndetifier];
                
            }
            
            annotationView.canShowCallout               = YES;
            annotationView.image                        = [UIImage imageNamed:@"QMapKit.bundle/SDKResources/redPin"];
            annotationView.rightCalloutAccessoryView    = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            
            return annotationView;
            
        }
    }
    
    return nil;
}

#pragma mark - Clusters

- (NSArray<TypedClustableAnnotation *> *)loadClusterData
{
    self.originAnnotations = [NSMutableArray array];
    
    // 从 resource 文件 cluster.txt 读取点
    NSString *filePath      = [[NSBundle mainBundle] pathForResource:@"cluster"
                                                              ofType:@"txt"];
    
    NSString *fileContent   = [NSString stringWithContentsOfFile:filePath
                                                        encoding:NSUTF8StringEncoding
                                                           error:nil];
    
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"\n"];
    NSArray *lines = [fileContent componentsSeparatedByCharactersInSet:characterSet];
    
    CLLocationDegrees latitude;
    CLLocationDegrees longitude;
    CGFloat hotValue;
    
    double scanedDouble;
    for (int i = 0; i < [lines count]; i++)
    {
        NSArray* lineDatas = [lines[i] componentsSeparatedByString:@"\t"];
        
        if (lineDatas.count < 2)
        {
            continue;
        }
        
        int j = 0;
        NSScanner *scanner = [NSScanner scannerWithString:(NSString *)lineDatas[j]];
        [scanner scanDouble:&scanedDouble];
        longitude = scanedDouble;
        
        j++;
        scanner = [NSScanner scannerWithString:(NSString *)lineDatas[j]];
        [scanner scanDouble:&scanedDouble];
        latitude = scanedDouble;
        
        j++;
        scanner = [NSScanner scannerWithString:(NSString *)lineDatas[j]];
        [scanner scanDouble:&scanedDouble];
        hotValue = scanedDouble;
        
        TypedClustableAnnotation* annotation = [[TypedClustableAnnotation alloc] init];
        annotation.coordinate   = CLLocationCoordinate2DMake(latitude, longitude);
        annotation.type         = hotValue;
        
        [self.originAnnotations addObject:annotation];
    }
    
    return self.originAnnotations;
}

- (void)addClusters
{
    NSArray *clusterData = [self loadClusterData];
    [self.manager addAnnotations:clusterData];
}

#pragma mark - Setup

- (void)setupClusterManager
{
    self.manager = [[QMUClusterManager alloc] initWithMap:self.mapView];
    
    self.manager.delegate = self;
    self.manager.distance = 56;
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _isCustom = NO;
    
    [self setupClusterManager];
    
    [self addClusters];
}

@end
