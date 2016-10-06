//
//  NewsVC.h
//  Life
//
//  Created by 孙建飞 on 16/9/21.
//  Copyright © 2016年 sjf. All rights reserved.
//

#import "BaseVC.h"
#import "SixButton.h"
#import "Constant.h"
#import "NewsCellFirst.h"
#import "NewsCellSecond.h"
#import "UIImageView+WebCache.h"
#import "JF_LoadingView.h"
@interface NewsVC : BaseVC<SixButtonDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy) NSArray *buttonTitleArr;
@property(nonatomic,copy) NSArray *typeArr;
@property(nonatomic,retain) NSString *urlFirst;
@property(nonatomic,retain) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property(nonatomic,strong) UIView *webContainer;

@end
