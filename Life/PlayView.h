//
//  PlayView.h
//  Life
//
//  Created by 孙建飞 on 16/10/6.
//  Copyright © 2016年 sjf. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>

#import <MediaPlayer/MediaPlayer.h>

#import "UIImageView+WebCache.h"

#import "PlaylistTableView.h"

#import "Constant.h"

@interface PlayView : UIView<PlaylistTableViewDelegate>
+(PlayView*)shareWeatherView;
-(instancetype)init;
-(void)reload:(NSMutableDictionary *)dic;

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
-(void)addAnimation;


@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIView *downView;
- (IBAction)hidePlaylistTableView:(UIButton *)sender;

- (IBAction)sliderValueChange:(id)sender;
- (IBAction)showPlayList:(UIButton *)sender;
- (IBAction)lastMusic:(UIButton*)sender;
- (IBAction)playMusic:(UIButton *)sender;
- (IBAction)nextMusic:(UIButton *)sender;
- (IBAction)changePlayOrder:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *lrcLabel;


@end
