//
//  PlayViewController.h
//  MusicTestDemo
//
//  Created by 孙建飞 on 16/4/7.
//  Copyright © 2016年 sjf. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <AVFoundation/AVFoundation.h>

#import <MediaPlayer/MediaPlayer.h>

#import "UIImageView+WebCache.h"

#import "PlaylistTableView.h"

#import "Constant.h"


@interface PlayViewController : UIViewController<PlaylistTableViewDelegate>

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic,assign)float startTime;

@property (strong, nonatomic) AVPlayer *player; //播放器对象
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (strong, nonatomic) id timeObserver; //视频播放时间观察者
@property (assign, nonatomic) NSInteger currentTime;//当前视频播放时间位置
@property(nonatomic,assign) NSInteger totalTime;//总时间；
//

@property(nonatomic,assign) BOOL iSplay;
 @property(nonatomic,assign)  BOOL isPlayListShow;//播放列表是否展示;

@property(nonatomic,retain) NSMutableArray *playlistArr;

@property(nonatomic,retain) NSArray *array;

@property(nonatomic,assign)  int currentNum;//当前播放的是哪个；

@property(nonatomic,strong) PlaylistTableView *playListTableView;

@property(nonatomic,copy) NSMutableDictionary *lrcDictionary;
@property(nonatomic,copy) NSString *last;
@property(nonatomic,copy) NSString *lastTitle;
@property(nonatomic,copy) NSMutableArray *timeArr;
@property(nonatomic,copy) NSMutableArray *stringArr;
@property(nonatomic,assign) int lastID;
-(void)addNotification;

@end
