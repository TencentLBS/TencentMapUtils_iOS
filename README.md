## TencentMapUtils_iOS 地图组件库 

## 配置
这个工具库必须配合腾讯地图 sdk 使用，所以必须在工程中[集成腾讯地图sdk](https://lbs.qq.com/ios_v1/guide-3d.html)。除了腾讯地图 sdk 申请的权限外此组件库不需要额外的权限和配置参数。

### 组件库 QMapSDKUtils.framework
* 目前组件库开放小车平滑移动能力，可在QMUAnnotationAnimator.h中查看。

### 小车平滑移动组件

	+ (void) translateWithAnnotationView:(QAnnotationView *) annotationView 
				   locations:(NSArray<id<QMULocation>> *) locations 
				    duration:(CFTimeInterval) duration 
			       rotateEnabled:(BOOL) needRotate 

#### 参数列表
* annotationView 平滑移动的对象
* locations	 平滑移动需要经过的经纬度坐标点串
* duration	 平滑移动时间
* needRotate	 平滑移动过程中annotationView是否需要沿移动方向执行旋转动画

#### 使用说明

1.	使用前需在AppDelegate.m中配置Key，需要使用拥有导航权限的Key。
2.	平滑移动组件支持传入地图SDK的QAnnotationView或其子类，通过设置经纬度坐标点串和移动时间，使得该View可以按照点串路线进行平滑动画移动。 
3.	若设置needRotate为YES，则在移动过程中，View自身的方向也会根据路线进行调整，使得View的上部与移动方向保持一致。
4.	若需要在动画过程中停止动画，可调用View的layer进行操作。
