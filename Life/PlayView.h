//
//  PlayView.h
//  Life
//
//  Created by 孙建飞 on 16/10/6.
//  Copyright © 2016年 sjf. All rights reserved.
//
/*
 [self.slider setMinimumTrackImage:[UIImage imageNamed:@"slider_before.png"] forState:UIControlStateNormal];
 [self.slider setMaximumTrackImage:[UIImage imageNamed:@"slider_back.png"] forState:UIControlStateNormal];
 */
#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>

#import <MediaPlayer/MediaPlayer.h>

#import "UIImageView+WebCache.h"

#import "PlaylistTableView.h"

#import "Constant.h"

@protocol PlayViewDelegate <NSObject>

-(void)removeFromSuperView;

@end

@interface PlayView : UIView<PlaylistTableViewDelegate,UITableViewDelegate,UITableViewDataSource>
+(PlayView*)sharePlayView;
-(instancetype)init;
-(void)reload:(NSMutableDictionary *)dic;

@property(nonatomic,strong) id <PlayViewDelegate> delegate;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic,assign)float startTime;

@property (strong, nonatomic) AVPlayer *player; //播放器对象
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (strong, nonatomic) id timeObserver; //播放时间观察者

@property(nonatomic,assign) int currentLrcIndex;

@property (assign, nonatomic) NSInteger currentTime;//当前视频播放时间位置
@property(nonatomic,assign) NSInteger totalTime;//总时间；
@property(nonatomic,assign) NSInteger currentRowIndex;//总时间；

//
@property(nonatomic,assign) BOOL isSetPlayer;//是否正在初始化Player
@property(nonatomic,assign) BOOL isGetLrc;//是否正在加载歌词

@property(nonatomic,assign) BOOL iSplay;
@property(nonatomic,assign)  BOOL isPlayListShow;//播放列表是否展示;
@property(nonatomic,assign)  BOOL isLrcTableScrolling;//歌词列表是否正在滚动;

@property(nonatomic,retain) NSMutableArray *playlistArr;
@property(nonatomic,retain) NSDictionary *songDic;
@property(nonatomic,retain) NSString *file_Link;

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

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *hidePlayListButton;

@property(nonatomic,assign) int pageNum;
@property(nonatomic,strong) UITableView *lrcTable;
- (IBAction)swipe:(UISwipeGestureRecognizer *)sender;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *upButton;

@end
