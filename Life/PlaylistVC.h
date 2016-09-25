//
//  PlaylistVC.h
//  Life
//
//  Created by 孙建飞 on 16/9/22.
//  Copyright © 2016年 sjf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "PlayViewController.h"
#import "MJRefresh.h"
@interface PlaylistVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property(nonatomic,copy) NSDictionary *dic;
@property(nonatomic,copy) NSMutableArray *dataSource;
@property(nonatomic,copy) NSMutableArray *songinfoArr;
@property(nonatomic,strong) PlayViewController *playViewController;

@property(nonatomic,retain) NSMutableDictionary *dicTransport;//传给下一个对象的

@property(nonatomic,assign) int offset;//当前加载的数据量（偏移量），刷新加载新数据用

@property(nonatomic,assign) BOOL isSongId;//区分数据内是songid还是song_id
//上一个控制器传递过来的参数
@property(nonatomic,copy) NSString *urlStr;
@property(nonatomic,copy) NSString *uid;
@property(nonatomic,copy) NSString *singerId;
@property(nonatomic,copy) NSString *type;
-(void)loadSongInfo;
@end
