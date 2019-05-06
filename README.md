## TencentMapUtils_iOS 地图组件库 
### 小车平滑移动组件

	+ (void) translateWithAnnotationView:(QAnnotationView *) annotationView 
				   locations:(NSArray<id<QMULocation>> *) locations 
				    duration:(CFTimeInterval) duration 
			       rotateEnabled:(BOOL) needRotate 

#### Parameters
* annotationView 平滑移动的对象
* locations	 平滑移动需要经过的经纬度坐标点串
* duration	 平滑移动时间
* needRotate	 平滑移动过程中annotationView是否需要沿移动方向执行旋转动画


平滑移动组件支持传入地图SDK的QAnnotationView或其子类，通过设置移动的经纬度坐标点串和移动时间，使得该View可以按照点串路线进行平滑的动画移动。 
若设置needRotate为YES，则在移动过程中，View自身的方向也会根据路线进行调整，使得View的上部与移动方向保持一致。
若需要在动画时间过程中停止动画，可调用View的layer进行操作。
