//
//  PlayHistory.h
//  Life
//
//  Created by 孙建飞 on 16/10/16.
//  Copyright © 2016年 sjf. All rights reserved.
//

#import "BaseVC.h"

@interface PlayHistory : BaseVC<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property(nonatomic,copy) NSMutableArray *dataArr;
@property(nonatomic,copy) NSString *type;
@end
