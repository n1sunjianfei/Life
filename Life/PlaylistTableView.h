//
//  PlaylistTableView.h
//  MusicTestDemo
//
//  Created by 孙建飞 on 16/4/8.
//  Copyright © 2016年 sjf. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "PlaylistCellModel.h"
//#import "36KeWebImage.h"

#import "UIImageView+WebCache.h"

@protocol PlaylistTableViewDelegate <NSObject>

-(void)PlaySelectedMusic:(int)index;

@end

@interface PlaylistTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) id <PlaylistTableViewDelegate>
delegate_playlistTableView;

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;
@property(nonatomic,strong)NSMutableArray *dataArr;

//



@end
