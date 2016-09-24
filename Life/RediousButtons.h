//
//  SixButton.h
//  zzProject
//
//  Created by 孙建飞 on 16/5/12.
//  Copyright © 2016年 YunFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RediousButtonsDelegate <NSObject>

-(void)clickButton:(UIButton*)sender;


@end

@interface RediousButtons : UIView


@property(nonatomic,copy) NSMutableArray *tempLengthArr;

@property(nonatomic,copy) NSArray *titleItem;

@property(nonatomic,assign) float totalLength;

@property(nonatomic,assign) float midEdage;

@property(nonatomic,strong)UIView *movingView;

@property(nonatomic,strong) id <RediousButtonsDelegate> delegate;

@property(nonatomic,strong) UIButton *preSender;

@property(nonatomic,strong) UIScrollView *scrollView;

-(instancetype)initWithFrame:(CGRect)frame AndTitleItem:(NSArray*)titleItem andSubTitleItem:(NSArray*)subTitleItem;


@end
