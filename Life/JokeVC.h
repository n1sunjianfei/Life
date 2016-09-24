//
//  JokeVC.h
//  Life
//
//  Created by 孙建飞 on 16/9/21.
//  Copyright © 2016年 sjf. All rights reserved.
//

#import "BaseVC.h"
#import "RediousButtons.h"
#import "JokeCellFirst.h"
#import "JokeCellSecond.h"
#import "JF_LoadingView.h"
#import "Constant.h"

#import "MJRefresh.h"
@interface JokeVC : BaseVC<RediousButtonsDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property(nonatomic,copy) NSArray *titleItemArr;

@property(nonatomic,copy) NSArray *urlArr;

@property(nonatomic,copy) NSMutableArray *dataSource;

//@property(nonatomic,copy) NSData *gifData;
@property(nonatomic,copy) NSMutableArray *gifDataArr;

@property(nonatomic,strong) JF_LoadingView *loadingView;

@property(nonatomic,strong) UIView *webContainer;

@property(nonatomic,assign) int currentSelectedTag;

@property(nonatomic,assign) int pageNum;

@end
