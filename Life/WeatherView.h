//
//  WeatherView.h
//  Life
//
//  Created by 孙建飞 on 16/9/21.
//  Copyright © 2016年 sjf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Constant.h"
#import "PlayView.h"

@interface WeatherView : UIView<CLLocationManagerDelegate>
+(UIView*)shareWeatherView;
//-(instancetype)init;
@property(nonatomic,strong) CLLocationManager *locationManager;

@property(nonatomic,retain) NSString *city;
@property(nonatomic,assign) BOOL isWeather;
@property(nonatomic,strong) UILabel *cityLabel;
@property(nonatomic,strong) UILabel *weatherLale;
@end
