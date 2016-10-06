//
//  LoadingView.m
//  菊花旋转
//
//  Created by 孙建飞 on 16/4/12.
//  Copyright © 2016年 sjf. All rights reserved.
//

#import "JF_LoadingView.h"

@implementation JF_LoadingView

-(instancetype)init{
    
    self=[super init];
    
    if (self) {
        self.frame=CGRectMake(0, 0, JF_LoadingViewWidth, JF_LoadingViewHeight);
        self.backgroundColor=[UIColor colorWithRed:0.1 green:0.2 blue:0.3 alpha:0.5];
        self.loadingTitle=@"加载中....";
        self.hidden=YES;
    }
   
    return self;
}
/*
 开始旋转
*/
-(void)begin{
    //NSLog(@"begin");
    [self.superview bringSubviewToFront:self];
    self.hidden=NO;
    self.alpha=1;
    //图片;
    login=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    login.layer.masksToBounds=YES;
    login.layer.cornerRadius=login.frame.size.width/2;
    login.center=CGPointMake(JF_LoadingViewWidth/2, JF_LoadingViewHeight/2-40);
    login.image=[UIImage imageNamed:@"login.png"];
    [self addSubview:login];
    //标题；
    loadingTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, JF_LoadingViewWidth, 40)];
    loadingTitleLabel.center=CGPointMake(login.center.x, login.center.y+50) ;
    loadingTitleLabel.textColor=[UIColor colorWithRed:0.3 green:0.3 blue:0.2 alpha:0.9];
    loadingTitleLabel.textAlignment=1;
    loadingTitleLabel.text=self.loadingTitle;
    [self addSubview:loadingTitleLabel];
    //添加动画;
    [self addanimation];
}
/*
 停止旋转
 */
-(void)stop{
    [UIView animateWithDuration:1 animations:^{
        self.alpha=0;
    } completion:^(BOOL finished) {
       // NSLog(@"remove");
        self.hidden=YES;
        login=nil;
        loadingTitleLabel=nil;
        //[login removeFromSuperview];
       // [self removeFromSuperview];
    }];
    }

/*
 动画
 */
-(void)addanimation{

    CABasicAnimation* rotationAnimation;
    
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    
    rotationAnimation.cumulative = YES;
    
    rotationAnimation.repeatCount =1000;
    
    //rotationAnimation.repeatDuration=10;
    
    rotationAnimation.duration = 1;
    
    [login.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
}

@end
