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
    //NSLog(@"appear");
    // 开始接受远程控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    //
    self.weather=[WeatherView shareWeatherView];
    [self.view addSubview:self.weather];
}
- (void)viewDidLoad {
    
    //        //系统版本大于7.0时设置，解决覆盖问题
    //        if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
    //            self.edgesForExtendedLayout = UIRectEdgeNone;
    //           // self.extendedLayoutIncludesOpaqueBars = NO;
    //          //  self.modalPresentationCapturesStatusBarAppearance = NO;
    //        }
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithTitle:@"展示" style:UIBarButtonItemStylePlain target:self action:@selector(show)];
    self.navigationItem.rightBarButtonItem=rightBtn;

    self.navigationController.navigationBar.translucent = NO;
    [super viewDidLoad];
    self.loading=[[JF_LoadingView alloc]init];

    [self.view addSubview:self.loading];
    
}
-(void)show{
    if (self.isPlayViewShow) {
        PlayView *play=[PlayView sharePlayView];
        [play removeFromSuperview];
        self.isPlayViewShow=NO;
        self.tabBarController.tabBar.hidden=NO;
        self.navigationItem.rightBarButtonItem.title=@"显示";
        [self animateOut];
    }else{
        PlayView *play=[PlayView sharePlayView];
        [self.view addSubview:play];
        self.isPlayViewShow=YES;
        self.tabBarController.tabBar.hidden=YES;
        self.navigationItem.rightBarButtonItem.title=@"隐藏";
        [play addAnimation];
        [self animateIn];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    // 开始接受远程控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    //[self.weather removeFromSuperview];
}
// 重写父类成为响应者方法
- (BOOL)canBecomeFirstResponder
{
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)animateIn{
    //动画效果
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.3;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromRight;
    [self.view.layer addAnimation:animation forKey:@"animation"];
}
-(void)animateOut{
    //动画效果
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.3;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromLeft;
    [self.view.layer addAnimation:animation forKey:@"animation"];
}

//重写父类方法，接受外部事件的处理
- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    PlayView *play=[PlayView sharePlayView];
    NSLog(@"remote");
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) { // 得到事件类型
                
            case UIEventSubtypeRemoteControlTogglePlayPause: // 暂停 ios6
                [play playMusic:nil]; // 调用你所在项目的暂停按钮的响应方法 下面的也是如此
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:  // 上一首
                
                [play lastMusic:nil];
                break;
                
            case UIEventSubtypeRemoteControlNextTrack: // 下一首
                [play nextMusic:nil];
                break;
                
            case UIEventSubtypeRemoteControlPlay: //播放
                [play playMusic:nil];
                NSLog(@"play");
                break;
                
            case UIEventSubtypeRemoteControlPause: // 暂停 ios7
                [play playMusic:nil];
                NSLog(@"pause");
                break;
                
            default:
                break;
        }
    }
}
@end
