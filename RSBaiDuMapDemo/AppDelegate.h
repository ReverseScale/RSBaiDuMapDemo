//
//  AppDelegate.h
//  RSBaiDuMapDemo
//
//  Created by WhatsXie on 2017/7/11.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, BMKGeneralDelegate>{
    UINavigationController *navigationController;
    BMKMapManager* _mapManager;
}

@property (strong, nonatomic) UIWindow *window;


@end

