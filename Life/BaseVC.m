//
//  BaseVC.m
//  Life
//
//  Created by 孙建飞 on 16/9/21.
//  Copyright © 2016年 sjf. All rights reserved.
//

#import "BaseVC.h"

@interface BaseVC ()

@end

@implementation BaseVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.view addSubview:WeatherView.shareWeatherView];
}
- (void)viewDidLoad {
    
    //        //系统版本大于7.0时设置，解决覆盖问题
    //        if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
    //            self.edgesForExtendedLayout = UIRectEdgeNone;
    //           // self.extendedLayoutIncludesOpaqueBars = NO;
    //          //  self.modalPresentationCapturesStatusBarAppearance = NO;
    //        }
    self.navigationController.navigationBar.translucent = NO;
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
