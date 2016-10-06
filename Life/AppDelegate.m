//
//  AppDelegate.m
//  Life
//
//  Created by 孙建飞 on 16/9/21.
//  Copyright © 2016年 sjf. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    UITabBarController *rootTab= [[UITabBarController alloc]init];
    /*
     
     */
    UINavigationController *nav1=[[UINavigationController alloc]initWithRootViewController:[[MusicVC alloc]init]];
    
    nav1.tabBarItem.title=@"听音乐";
    nav1.tabBarItem.selectedImage=[[UIImage imageNamed:@"music_s.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav1.tabBarItem.image=[[UIImage imageNamed:@"music.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //nav1.tabBarItem.badgeValue=@"love";
    /*
     
     */
    UINavigationController *nav2=[[UINavigationController alloc]initWithRootViewController:[[ExpressVC alloc]init]];
    
    nav2.tabBarItem.title=@"查快递";
    nav2.tabBarItem.selectedImage=[[UIImage imageNamed:@"search_s.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav2.tabBarItem.image=[[UIImage imageNamed:@"search.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //nav1.tabBarItem.badgeValue=@"love";
    /*
     
     
     */
    UINavigationController *nav3=[[UINavigationController alloc]initWithRootViewController:[[NewsVC alloc]init]];
    
    nav3.tabBarItem.title=@"看新闻";
    nav3.tabBarItem.selectedImage=[[UIImage imageNamed:@"news_s.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav3.tabBarItem.image=[[UIImage imageNamed:@"news.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //nav1.tabBarItem.badgeValue=@"love";
    /*
     
     */
    UINavigationController *nav4=[[UINavigationController alloc]initWithRootViewController:[[JokeVC alloc]init]];
    
    nav4.tabBarItem.title=@"看笑话";
    nav4.tabBarItem.selectedImage=[[UIImage imageNamed:@"jokes_s.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav4.tabBarItem.image=[[UIImage imageNamed:@"jokes.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //nav1.tabBarItem.badgeValue=@"love";

    
    rootTab.viewControllers=@[nav1,nav2,nav3,nav4];
    self.window.rootViewController=rootTab;
    [self.window makeKeyAndVisible];
    
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //默认情况下扬声器播放
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
