//
//  ClusterDemoViewController.m
//  RSBaiDuMapDemo
//
//  Created by WhatsXie on 2017/7/12.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

#import "ClusterDemoViewController.h"

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

#import "BMKClusterManager.h"

/*
 *点聚合Annotation
 */
@interface ClusterAnnotation : BMKPointAnnotation

///所包含annotation个数
@property (nonatomic, assign) NSInteger size;

@end

@implementation ClusterAnnotation

@synthesize size = _size;

@end

/*
 *点聚合AnnotationView
 */
@interface ClusterAnnotationView : BMKPinAnnotationView {
    
}

@property (nonatomic, assign) NSInteger size;
@property (nonatomic, strong) UILabel *label;

@end

@implementation ClusterAnnotationView

@synthesize size = _size;
@synthesize label = _label;

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBounds:CGRectMake(0.f, 0.f, 22.f, 22.f)];
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 22.f, 22.f)];
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont systemFontOfSize:11];
        _label.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_label];
        self.alpha = 0.85;
    }
    return self;
}

- (void)setSize:(NSInteger)size {
    _size = size;
    if (_size == 1) {
        self.label.hidden = YES;
        self.pinColor = BMKPinAnnotationColorRed;
        return;
    }
    self.label.hidden = NO;
    if (size > 20) {
        self.label.backgroundColor = [UIColor redColor];
    } else if (size > 10) {
        self.label.backgroundColor = [UIColor purpleColor];
    } else if (size > 5) {
        self.label.backgroundColor = [UIColor blueColor];
    } else {
        self.label.backgroundColor = [UIColor greenColor];
    }
    _label.text = [NSString stringWithFormat:@"%ld", size];
}

@end


@interface ClusterDemoViewController ()<BMKMapViewDelegate>{
    BMKClusterManager *_clusterManager;//点聚合管理类
    NSInteger _clusterZoom;//聚合级别
    NSMutableArray *_clusterCaches;//点聚合缓存标注
    BMKCircle* circle;
}
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@end

@implementation ClusterDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.navigationController.navigationBar.translucent = NO;
    }
    
    [self addOverlayView];
    
    _clusterCaches = [[NSMutableArray alloc] init];
    for (NSInteger i = 3; i < 22; i++) {
        [_clusterCaches addObject:[NSMutableArray array]];
    }
    
    //点聚合管理类
    _clusterManager = [[BMKClusterManager alloc] init];
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(39.915, 116.404);
    //向点聚合管理类中添加标注
    for (NSInteger i = 0; i < 20; i++) {
        double lat =  (arc4random() % 100) * 0.001f;
        double lon =  (arc4random() % 100) * 0.001f;
        BMKClusterItem *clusterItem = [[BMKClusterItem alloc] init];
        clusterItem.coor = CLLocationCoordinate2DMake(coor.latitude + lat, coor.longitude + lon);
        [_clusterManager addClusterItem:clusterItem];
    }
}
- (void)addOverlayView {
    // 添加圆形覆盖物
    if (circle == nil) {
        CLLocationCoordinate2D coor;
        coor.latitude = 39.96729;
        coor.longitude = 116.449021;
        circle = [BMKCircle circleWithCenterCoordinate:coor radius:10000];
    }
    [_mapView addOverlay:circle];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}
- (void)viewDidUnload {
    [super viewDidUnload];
}
- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}

//更新聚合状态
- (void)updateClusters {
    _clusterZoom = (NSInteger)_mapView.zoomLevel;
    @synchronized(_clusterCaches) {
        __block NSMutableArray *clusters = [_clusterCaches objectAtIndex:(_clusterZoom - 3)];
        
        if (clusters.count > 0) {
            [_mapView removeAnnotations:_mapView.annotations];
            [_mapView addAnnotations:clusters];
        } else {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                ///获取聚合后的标注
                __block NSArray *array = [_clusterManager getClusters:_clusterZoom];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    for (BMKCluster *item in array) {
                        ClusterAnnotation *annotation = [[ClusterAnnotation alloc] init];
                        annotation.coordinate = item.coordinate;
                        annotation.size = item.size;
                        annotation.title = [NSString stringWithFormat:@"我是%ld个", item.size];
                        [clusters addObject:annotation];
                    }
                    [_mapView removeAnnotations:_mapView.annotations];
                    [_mapView addAnnotations:clusters];
                });
            });
        }
    }
}

#pragma mark - BMKMapViewDelegate

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    //普通annotation
    NSString *AnnotationViewID = @"ClusterMark";
    ClusterAnnotation *cluster = (ClusterAnnotation*)annotation;
    ClusterAnnotationView *annotationView = [[ClusterAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    annotationView.size = cluster.size;
    annotationView.draggable = YES;
    annotationView.annotation = cluster;
    return annotationView;
}

/**
 *当点击annotation view弹出的泡泡时，调用此接口
 *@param mapView 地图View
 *@param view 泡泡所属的annotation view
 */
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view {
    if ([view isKindOfClass:[ClusterAnnotationView class]]) {
        ClusterAnnotation *clusterAnnotation = (ClusterAnnotation*)view.annotation;
        if (clusterAnnotation.size > 1) {
            [mapView setCenterCoordinate:view.annotation.coordinate];
            [mapView zoomIn];
        }
    }
}

/**
 * 地图初始化完毕时会调用此接口
 * @param mapView 地图View
 */
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    [self updateClusters];
}

/**
 *地图渲染每一帧画面过程中，以及每次需要重绘地图时（例如添加覆盖物）都会调用此接口
 * @param mapView 地图View
 * @param status 此时地图的状态
 */
- (void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus *)status {
    if (_clusterZoom != 0 && _clusterZoom != (NSInteger)mapView.zoomLevel) {
        [self updateClusters];
    }
}

#pragma mark implement BMKMapViewDelegate

//根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay {
    if ([overlay isKindOfClass:[BMKCircle class]])
    {
        BMKCircleView* circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
        circleView.fillColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.2];
        circleView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.2];
        circleView.lineWidth = 1.0;
        
        return circleView;
    }
    return nil;
}

@end
