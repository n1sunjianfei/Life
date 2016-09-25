//
//  LoadingView.h
//  菊花旋转
//
//  Created by 孙建飞 on 16/4/12.
//  Copyright © 2016年 sjf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JF_LoadingView : UIView

#define JF_LoadingViewWidth  [[UIScreen mainScreen]bounds].size.width
#define JF_LoadingViewHeight [[UIScreen mainScreen]bounds].size.height
{
  @private
    UIImageView *login;
    UILabel *loadingTitleLabel;
}

-(instancetype)init;
-(void)begin;
-(void)stop;


//@property(nonatomic,strong) UIImageView *login;
//@property(nonatomic,strong) UILabel *loadingTitleLabel;
@property(nonatomic,strong) NSString *loadingTitle;
@end
