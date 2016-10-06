//
//  WeatherView.m
//  Life
//
//  Created by 孙建飞 on 16/9/21.
//  Copyright © 2016年 sjf. All rights reserved.
//

#import "WeatherView.h"

@implementation WeatherView

+(UIView*)shareWeatherView{
    static WeatherView *weather=nil;
    if (weather==nil) {

        weather=[[WeatherView alloc]init];
    }
    return weather;
}
-(instancetype)init{
    if (self==[super initWithFrame:CGRectMake(5, 5,SCREEN_WIDTH-10, 40)]) {
       // self.backgroundColor=[UIColor grayColor];
        self.locationManager=[[CLLocationManager alloc]init];
        self.locationManager.delegate=self;
        [self.locationManager startUpdatingLocation];
        
        self.cityLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
       
       // self.dataLabel.backgroundColor=[UIColor blueColor];
        self.weatherLale=[[UILabel alloc]initWithFrame:CGRectMake(70, 0, 190, 30)];
        [self addSubview:self.cityLabel];
        [self addSubview:self.weatherLale];

        //
        UIButton *showPlayView=[UIButton buttonWithType:UIButtonTypeCustom];
        [showPlayView addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
        showPlayView.frame=CGRectMake(SCREEN_WIDTH-50, 5, 30, 30);
        showPlayView.titleLabel.text=@"显示";
        [self addSubview:showPlayView];
    }
    return self;
}
-(void)show{
    PlayView *play=[PlayView sharePlayView];
   
    [self.superview addSubview:play];
}
/*http://api.map.baidu.com/telematics/v3/weather?location=嘉兴&output=json&ak=5slgyqGDENN7Sy7pw29IUvrZ*/
/*
 *LocationManager的协议方法
 *
 */
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                
                [self.locationManager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription
                [self.locationManager requestAlwaysAuthorization];
            }
            break;
        default:
            break;
    }
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
   // NSLog(@"locating....");
    CLLocation *currentlocation=[locations lastObject];
    
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:currentlocation completionHandler:^(NSArray *placemarks, NSError *error) {
        //获得了定位
        if (placemarks.count>0) {
            CLPlacemark *placemark=[placemarks objectAtIndex:0];
         //   NSLog(@"name=%@",placemark.name);
            //定位城市名
           // NSString *city=nil;
           self.city=placemark.locality;
        //    NSLog(@"city=%@",self.city);
            if (self.city!=nil) {
                self.cityLabel.text=self.city;

            }
            [manager stopUpdatingLocation];
            if (self.isWeather==false) {
                
                [self loadWeather];
            }
        }
        else if (placemarks.count==0){
          //  NSLog(@"定位不可用");
        }
    }];
    
}

-(void)loadWeather{

  //  NSLog(@"load weather");
    NSString *str=[NSString stringWithFormat:@"http://op.juhe.cn/onebox/weather/query?cityname=%@&key=807c860cf95c4ccbb14c5c29ad45af99",[self.city stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    NSLog(@"%@",str);
//    NSLog(@"%s",[str UTF8String]);
    NSURL *url=[NSURL URLWithString:str];
    
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
      NSDictionary *dic=  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *resultDic= [dic valueForKey:@"result"];
        NSDictionary *datadic=[resultDic valueForKey:@"data"];
        NSDictionary *weatherDic= [datadic valueForKey:@"realtime"];
        
        
        NSDictionary *temDic=[weatherDic valueForKey:@"weather"];
        NSDictionary *windDic=[weatherDic valueForKey:@"wind"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.weatherLale.text=[NSString stringWithFormat:@"%@ %@℃ %@ %@",[temDic valueForKey:@"info"],[temDic valueForKey:@"temperature"],[windDic valueForKey:@"direct"],[windDic valueForKey:@"power"]];
        });
    }
     ];
    self.isWeather=YES;
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"error=%@",error);
}
@end
