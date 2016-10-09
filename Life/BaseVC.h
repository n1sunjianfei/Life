//
//  BaseVC.h
//  Life
//
//  Created by 孙建飞 on 16/9/21.
//  Copyright © 2016年 sjf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "WeatherView.h"
//#import "PlayView.h"
#import "JF_LoadingView.h"

@interface BaseVC : UIViewController<PlayViewDelegate>
@property(nonatomic,assign) BOOL isPlayViewShow;
@property(nonatomic,strong) UIView *weather;
@property(nonatomic,strong) JF_LoadingView *loading;
@property(nonatomic,strong) PlayView *play;
-(void)animateIn;
-(void)animateOut;
-(void)show;
@end
