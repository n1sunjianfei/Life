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
@interface PlaylistVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property(nonatomic,copy) NSDictionary *dic;
@property(nonatomic,copy) NSArray *dataSource;
@property(nonatomic,copy) NSMutableArray *songinfoArr;
@property(nonatomic,strong) PlayViewController *playViewController;

@property(nonatomic,retain) NSMutableDictionary *dicTransport;

-(void)loadSongInfo;
@end
