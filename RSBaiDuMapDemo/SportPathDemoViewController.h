//
//  SportPathDemoViewController.h
//  RSBaiDuMapDemo
//
//  Created by WhatsXie on 2017/7/12.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface SportPathDemoViewController : UIViewController<BMKMapViewDelegate>
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@end
