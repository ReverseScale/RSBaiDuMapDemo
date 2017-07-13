//
//  SimpleMapViewController.h
//  RSBaiDuMapDemo
//
//  Created by WhatsXie on 2017/7/11.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface SimpleMapViewController : UIViewController<BMKMapViewDelegate>{
    IBOutlet BMKMapView* _mapView;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl* segment;
@end
