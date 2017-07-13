//
//  RouteSearchDemoViewController.h
//  RSBaiDuMapDemo
//
//  Created by WhatsXie on 2017/7/12.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKGeometry.h>

@interface RouteSearchDemoViewController : UIViewController{
    IBOutlet UITextField* _startCityText;
    IBOutlet UITextField* _startAddrText;
    IBOutlet UITextField* _endCityText;
    IBOutlet UITextField* _endAddrText;
}

@end
