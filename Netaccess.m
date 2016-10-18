//
//  Netaccess.m
//  test
//
//  Created by 孙建飞 on 16/10/17.
//  Copyright © 2016年 sjf. All rights reserved.
//

#import "Netaccess.h"

@implementation Netaccess

+(BOOL)isWifiAccess{
    Reachability *wifi=[Reachability reachabilityForLocalWiFi];
    if (wifi.currentReachabilityStatus!=NotReachable) {
        return YES;
    }else{
        return NO;
    }
}
+(BOOL)isWanAccess{
    Reachability *wan=[Reachability reachabilityForInternetConnection];
    if (wan.currentReachabilityStatus!=NotReachable) {
        return YES;
    }else{
        return NO;
    }
}

/*
//动态监测
 
 -(void)addReachabilityNotification{
 
 // start the notifier which will cause the reachability object to retain itself!
 NSLog(@"添加");
 
 [[NSNotificationCenter defaultCenter] addObserver:self
 selector:@selector(reachabilityChanged)
 name:kReachabilityChangedNotification
 object:nil];
 self.conn=[Reachability reachabilityForInternetConnection];
 [self.conn startNotifier];
 }
 
 - (void) reachabilityChanged{
 
 Reachability *reachWifi=[Reachability reachabilityForLocalWiFi];
 Reachability *reachWan=[Reachability reachabilityForInternetConnection];
 if ([reachWifi currentReachabilityStatus]!=NotReachable) {
 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"网络状态改变了哦！" message:@"切换到WiFi网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
 [alert show];
 }else if ([reachWan currentReachabilityStatus]!=NotReachable){
 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"网络状态改变了哦！" message:@"切换到2G/3G/4G网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
 [alert show];
 }else{
 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"网络状态改变了哦！" message:@"当前网络不可用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
 [alert show];
 }
 }

 */
@end
