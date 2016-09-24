//
//  PlayViewController.m
//  MusicTestDemo
//
//  Created by 孙建飞 on 16/4/7.
//  Copyright © 2016年 sjf. All rights reserved.
//

#import "PlayViewController.h"

@interface PlayViewController ()
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

@implementation PlayViewController
/*
添加通知(在appdelegate中就已经调用此方法了）
*/
-(void)addNotification{
    NSLog(@"add");
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reload:) name:@"jumpToPlayVC" object:nil];
    /*
     给AVPlayerItem添加播放完成通知
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}


/*
 播放完成通知
 */
- (void)playbackFinished:(NSNotification *)notification{
    NSLog(@"音乐播放完成.");
    [self nextMusic:nil];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    //NSLog(@"appear");
    [super viewWillAppear:animated];
    // 开始接受远程控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    //
    if(self.iSplay){
        [self addAnimation];
    }
    if (self.iSplay) {
        self.tabBarController.tabBar.hidden=YES;

    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 开始接受远程控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}
// 重写父类成为响应者方法
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)viewDidLoad {
    NSLog(@"playViewController");
    [super viewDidLoad];
   
    self.last=@"00:00";
    self.currentNum=-1;
    //title
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 60)];
    label.text=@"❤随悦动";
    label.textAlignment=1;
    label.font=[UIFont systemFontOfSize:20];
    self.navigationItem.titleView=label;
    self.currentTime = 0;
   //
    self.imageView.layer.masksToBounds=YES;
    self.imageView.layer.cornerRadius=75;
}

/*
通知方法，播放选中的音乐;
*/
-(void)reload:(NSNotification *)userInfo{
    if (self.playlistArr==NULL) {
        NSLog(@"初始化数组");
        self.playlistArr=[[NSMutableArray alloc]init];
    }
    self.playListTableView=[[PlaylistTableView alloc]initWithFrame:CGRectMake(0, self.imageView.frame.origin.y+self.imageView.frame.size.height, SCREEN_WIDTH-200, 0) style:UITableViewStyleGrouped];
   //
    NSDictionary *dic=userInfo.userInfo;
    NSArray *arr =[dic valueForKey:@"array"];
    NSString  *index=[dic valueForKey:@"index"];
    self.lastID=[[dic valueForKey:@"lastv"] intValue];
    NSString *title=[dic valueForKey:@"title"];

    //NSLog(@"%@",title);
    //
        UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithTitle:[NSString stringWithFormat:@"<%@",title] style:UIBarButtonItemStylePlain target:self action:@selector(backToLast)];
        self.navigationItem.leftBarButtonItem=back;

    int i=[index intValue];
    //NSLog(@"reload %d",i);

    self.playlistArr=[NSMutableArray arrayWithArray:arr];
    //更新播放列表;
    self.playListTableView=[[PlaylistTableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH,100, SCREEN_WIDTH-105,SCREEN_HEIGHT-100-self.downView.frame.size.height) style:UITableViewStylePlain];
    self.playListTableView.delegate_playlistTableView=self;
    self.playListTableView.dataArr=self.playlistArr;
    //NSLog(@"tbdata%lu",(unsigned long)_playListTableView.dataArr.count);
    [self.playListTableView reloadData];
   //判断选中的歌曲是否正在播放
    if (!(i==self.currentNum&&title==self.lastTitle)) {
        self.lastTitle=title;
        self.currentNum=i;
        NSLog(@"reload %d,title:%@",self.currentNum,self.lastTitle);

        [self.playButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [self configNowPlayingCenter];

        [self setPlayerAndPlayMusic];
    }
}
-(void)backToLast{
    self.tabBarController.selectedIndex=self.lastID;
}
/*
协议方法
*/
-(void)PlaySelectedMusic:(int)index{
    NSLog(@"sssle");
    if (self.currentNum!=index) {
        self.currentNum=index;

        [self setPlayerAndPlayMusic];
    }
    
}
/*
设置时间label
*/

-(void)setTimeLabel{
    NSLog(@"设置时间");
    NSLog(@"%ld",self.playlistArr.count);
    NSDictionary *dic=[self.playlistArr objectAtIndex:self.currentNum];
    NSDictionary *bitrate=[dic valueForKey:@"bitrate"];
    NSDictionary *songInfo=[dic valueForKey:@"songinfo"];
     self.totalTime=[[bitrate valueForKey:@"file_duration"] intValue];
    NSLog(@"%ld",(long)self.totalTime);
    self.currentTimeLabel.text=@"00:00";
    self.totalTimeLabel.text=[NSString stringWithFormat:@"%.2ld:%.2ld",self.totalTime/60,self.totalTime%60];
    NSLog(@"%@",self.totalTimeLabel.text);
    self.nameLabel.text=[songInfo valueForKey:@"title"];

    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[songInfo valueForKey:@"pic_big"]] placeholderImage:[UIImage imageNamed:@""]];
    
}
/*
 初始化播放器然后播放;
 */
-(void)setPlayerAndPlayMusic{
    [self.timer invalidate];
    self.timer=nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimeAndSliderValue) userInfo:nil repeats:YES];
    [self setMediaPlayer];
    [self.player play];
    [self configNowPlayingCenter];

    [self.playButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    self.iSplay=YES;
    [self setupNotification];//活跃度监听
    [self setTimeLabel];
    [self configNowPlayingCenter];
    [self analysisIrc];
}

/*
 视图已经消失;
 */

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.playListTableView removeFromSuperview];
    _isPlayListShow=NO;
   // NSLog(@"dissappear");
}
/*
 更新时间labe和slider
 */
-(void)updateTimeAndSliderValue{
    if (self.playerItem) {
        long long cur=self.playerItem.currentTime.value/self.playerItem.currentTime.timescale;
//        
        self.currentTimeLabel.text=[NSString stringWithFormat:@"%.2lld:%.2lld",cur/60,cur%60];
        NSDictionary *dic=[self.playlistArr objectAtIndex:self.currentNum];
        NSDictionary *bitrate=[dic valueForKey:@"bitrate"];
     //   NSDictionary *songInfo=[dic valueForKey:@"songinfo"];
        int total=[[bitrate valueForKey:@"file_duration"] intValue];
        self.slider.value=(float)cur/(float)total;
        if (self.timeArr) {
            //NSLog(@"歌词存在");
            
            //NSLog(@"%@",lrcString);
            if ([self.timeArr containsObject:self.currentTimeLabel.text]) {
              //  NSLog(@"更新");
                int index=(int)[self.timeArr indexOfObject:self.currentTimeLabel.text];
                //内容不为空时传值
                if (![[self.stringArr objectAtIndex:index] isEqual:@""]) {
                    NSLog(@"%@",[self.stringArr objectAtIndex:index]);
                    self.lrcLabel.text=[self.stringArr objectAtIndex:index];
                }
            }
        }
        
    }
    
}

/*
 初始化播放器;
 */
- (void)setMediaPlayer{
    [self.player seekToTime:CMTimeMakeWithSeconds(self.startTime, 1000)];//设置播放位置,1000 为帧率
    if (_playlistArr.count>0) {
        NSLog(@"初始化播放器");
        /*method=baidu.ting.song.play&songid=877578*/
        
        NSDictionary *dic=[self.playlistArr objectAtIndex:self.currentNum];
        NSDictionary *bitrate=[dic valueForKey:@"bitrate"];
        NSDictionary *songInfo=[dic valueForKey:@"songinfo"];
        
        NSString *urlStr=[bitrate valueForKey:@"file_link"];
        NSLog(@"%@",urlStr);
        NSURL *url=[NSURL URLWithString:urlStr];
            _playerItem=[AVPlayerItem playerItemWithURL:url];
        _player = [AVPlayer playerWithPlayerItem:_playerItem];
        _player.volume=1;
        
        NSURL *lrcUrl=[songInfo valueForKey:@"lrclink"];
    }
}

/*
 添加通知中心;
 */
-(void)setupNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
}
/*
 进入前台
 */
-(void)applicationDidBecomeActive:(NSNotification*)notification{
    NSLog(@"enter foreword");
    
}
/*
 进入后台
 */
-(void)applicationDidEnterBackground:(NSNotification*)notification{
    NSLog(@"enter background");
}
/*
 播放完成;
 */
-(void)playFinished{
    NSLog(@"finished");
}
/*
 滑动slider改变播放时间
 */

- (IBAction)sliderValueChange:(UISlider*)sender {
    NSDictionary *dic=[self.playlistArr objectAtIndex:self.currentNum];
    NSDictionary *bitrate=[dic valueForKey:@"bitrate"];
    NSDictionary *songInfo=[dic valueForKey:@"songinfo"];
    int total=[[bitrate valueForKey:@"file_duration"] intValue];
    long long tt=sender.value*total;
    CMTime cmtime=CMTimeMake(tt, 1);
    [self.player pause];
    [self.playerItem seekToTime:cmtime completionHandler:^(BOOL finished) {
        [self.player play];
        //NSLog(@"finish");
    }];
}
/*
隐藏播放列表；
 */
- (IBAction)hidePlaylistTableView:(UIButton *)sender {

    if (_isPlayListShow) {
        [UIView animateWithDuration:0.5 animations:^{
            _playListTableView.frame=CGRectMake(SCREEN_WIDTH,100, SCREEN_WIDTH-105,SCREEN_HEIGHT-100-self.downView.frame.size.height);
        } completion:^(BOOL finished) {
            [self.playListTableView removeFromSuperview];
            _isPlayListShow=NO;
        }];
    }
}

/*
 展示播放列表；
 */
- (IBAction)showPlayList:(UIButton *)sender {
   // NSLog(@"show");
    if (_playlistArr.count==0) {
        NSLog(@"播放列表为空");
        return;
    }
    if (_isPlayListShow) {
        [UIView animateWithDuration:0.5 animations:^{
            _playListTableView.frame=CGRectMake(SCREEN_WIDTH,100, SCREEN_WIDTH-105,SCREEN_HEIGHT-100-self.downView.frame.size.height );
            //self.playListTableView.alpha=1;
        } completion:^(BOOL finished) {
            [self.playListTableView removeFromSuperview];
            _isPlayListShow=NO;
        }];
        
    }else{
        
        [_playListTableView removeFromSuperview];
        _playListTableView=[[PlaylistTableView alloc]initWithFrame:CGRectMake(0, self.imageView.frame.origin.y+self.imageView.frame.size.height, SCREEN_WIDTH, 0) style:UITableViewStyleGrouped];
        _playListTableView.frame=CGRectMake(SCREEN_WIDTH,100, SCREEN_WIDTH-105,SCREEN_HEIGHT-100-self.downView.frame.size.height );
       _playListTableView.delegate_playlistTableView=self;
        NSLog(@"%ld",_playListTableView.dataArr.count);
       _playListTableView.dataArr=self.playlistArr;
        [_playListTableView reloadData];
        [self.view addSubview:_playListTableView];
        
        [UIView animateWithDuration:0.5 animations:^{
            _playListTableView.frame=CGRectMake(100, 100, SCREEN_WIDTH-105, SCREEN_HEIGHT-100-self.downView.frame.size.height);
            self.playListTableView.alpha=1;
        } completion:^(BOOL finished) {
            _isPlayListShow=YES;
            //选中当前播放；
        }];
    }
}
/*
 上一首
 */
- (IBAction)lastMusic:(id)sender {

    NSLog(@"%d",self.currentNum);
    
    if (_playlistArr.count<2) {//数量小于2，什么都不做直接返回；
        NSLog(@"只有一首歌曲");
        return;
    }
    //数量大于2，进行下一首；
    if (self.currentNum==0) {
        self.currentNum=(int)self.playlistArr.count-1;
    }else{
        self.currentNum--;
    }
  //  NSIndexPath *selectPath=[NSIndexPath indexPathForRow:self.currentNum inSection:0];
    
  //  [self.playListTableView selectRowAtIndexPath:selectPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    [self setPlayerAndPlayMusic];
}
/*
 下一首
 */
- (IBAction)nextMusic:(UIButton *)sender {
    

    if (_playlistArr.count<2) {
        NSLog(@"只有一首歌曲");
        return;
    }
    
    if (self.currentNum==self.playlistArr.count-1) {
        self.currentNum=0;
    }else{
        self.currentNum++;
    }

    [self setPlayerAndPlayMusic];
}

/*
 播放；
 */
- (IBAction)playMusic:(UIButton *)sender {
    
    if (self.iSplay) {
        [self.player pause];
        [sender setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        self.iSplay=!self.iSplay;
    }else{
        [self.player play];
        self.iSplay=!self.iSplay;
        [sender setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    }
}
/*
 改变播放顺序；
 */
- (IBAction)changePlayOrder:(UIButton *)sender {
    
}

//重写父类方法，接受外部事件的处理
- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    NSLog(@"remote");
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) { // 得到事件类型
                
            case UIEventSubtypeRemoteControlTogglePlayPause: // 暂停 ios6
                [self.player pause]; // 调用你所在项目的暂停按钮的响应方法 下面的也是如此
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:  // 上一首
                
                [self lastMusic:nil];
                break;
                
            case UIEventSubtypeRemoteControlNextTrack: // 下一首
                [self nextMusic:nil];
                break;
                
            case UIEventSubtypeRemoteControlPlay: //播放
                [self playMusic:nil];
                break;
                
            case UIEventSubtypeRemoteControlPause: // 暂停 ios7
                [self playMusic:nil];
                break;
                
            default:
                break;
        }
    }
}
//Now Playing Center可以在锁屏界面展示音乐的信息，也达到增强用户体验的作用。
////传递信息到锁屏状态下 此方法在播放歌曲与切换歌曲时调用即可

- (void)configNowPlayingCenter {
    NSLog(@"锁屏设置");
   // BASE_INFO_FUN(@"配置NowPlayingCenter");
    NSMutableDictionary * info = [NSMutableDictionary dictionary];
    //音乐的标题
    [info setObject:self.nameLabel.text forKey:MPMediaItemPropertyTitle];
    //音乐的艺术家
   NSString *author= [[self.playlistArr[self.currentNum] valueForKey:@"songinfo"] valueForKey:@"author"];
    [info setObject:author forKey:MPMediaItemPropertyArtist];
    //音乐的播放时间
    [info setObject:@(self.player.currentTime.value) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    //音乐的播放速度
    [info setObject:@(1) forKey:MPNowPlayingInfoPropertyPlaybackRate];
    //音乐的总时间
    [info setObject:@(self.totalTime) forKey:MPMediaItemPropertyPlaybackDuration];
    //音乐的封面
    MPMediaItemArtwork * artwork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"0.jpg"]];
    [info setObject:artwork forKey:MPMediaItemPropertyArtwork];
    //完成设置
    [[MPNowPlayingInfoCenter defaultCenter]setNowPlayingInfo:info];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//解析歌词文件
-(void)analysisIrc{
    _timeArr=[[NSMutableArray alloc]init];
    _stringArr=[[NSMutableArray alloc]init];
 
    NSDictionary *dic=[self.playlistArr objectAtIndex:self.currentNum];
    NSDictionary *songInfo=[dic valueForKey:@"songinfo"];
    NSString *lrcStr=[songInfo valueForKey:@"lrclink"];
    if ([NSData dataWithContentsOfFile:[self getLocalFilePath]]) {
        NSLog(@"本地歌词");
        self.lrcLabel.text=self.nameLabel.text;
        [self ana];
    }else{
   [NSURLConnection sendAsynchronousRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:lrcStr]] queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
       if (data) {
           [data writeToFile:[self getLocalFilePath] atomically:YES];
           NSLog(@"歌词准备完毕");
           [self performSelectorOnMainThread:@selector(ana) withObject:nil waitUntilDone:YES];
       }
      
   }];
    }
}
-(void)ana{
    self.lrcLabel.text=self.nameLabel.text;

    //   NSString *lynicPath = [[NSBundle mainBundle] pathForResource:@"vivalavida" ofType:@"lrc"];
    NSString *lyc = [NSString stringWithContentsOfFile:[self getLocalFilePath] encoding:NSUTF8StringEncoding error:nil];
    //   NSLog(@"歌词----%@",lyc);
    
    
    
    NSArray *lycArray = [lyc componentsSeparatedByString:@"\n"];
    for (int i = 0; i < [lycArray count]; i++) {
        
        NSString *lineString = [lycArray objectAtIndex:i];
        
        NSArray *lineArray = [lineString componentsSeparatedByString:@"]"];
        
        if ([lineArray[0] length] > 8) {
            
            NSString *str1 = [lineString substringWithRange:NSMakeRange(3, 1)];
            
            NSString *str2 = [lineString substringWithRange:NSMakeRange(6, 1)];
            
            if ([str1 isEqualToString:@":"] && [str2 isEqualToString:@"."]) {
                
                for (int i = 0; i < lineArray.count - 1; i++) {
                    
                    NSString *lrcString = [lineArray objectAtIndex:lineArray.count - 1];
                    
                    //分割区间求歌词时间
                    NSString *timeString =[[lineArray objectAtIndex:i] substringWithRange:NSMakeRange(1, 5)];
                    //NSString *timeString = [self timeToSecond:[[lineArray objectAtIndex:i] substringWithRange:NSMakeRange(1, 5)]];
//                    NSLog(@"词：%@",lrcString);
//                    NSLog(@"时：%@",timeString);
                    //
                    [_timeArr addObject:timeString];
                    [_stringArr addObject:lrcString];
                    //                    NSLog(@"%lu",(unsigned long)self.timeArr.count);
                    //                    NSLog(@"%lu",(unsigned long)self.stringArr.count);
                }
            }
        }
    }
}

-(NSString*)timeToSecond:(NSString*)second{
    
    NSString *str=[NSString stringWithFormat:@"%d",[second substringWithRange:NSMakeRange(0,2)].intValue*60-[self.last substringWithRange:NSMakeRange(0, 2)].intValue*60+[second substringWithRange:NSMakeRange(3,2)].intValue-[self.last substringWithRange:NSMakeRange(3, 2)].intValue];
    self.last=second;
  //  NSLog(@"秒%@",str);
    return str;
}
///*
//获取文件路径
//*/
-(NSString *)getLocalFilePath{

    NSArray *arr=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path=[arr objectAtIndex:0];
  //  NSString *filepath=[path stringByAppendingPathComponent:_selectedPlaylistCellModel.playUrl32];
    NSDictionary *dic=[self.playlistArr objectAtIndex:self.currentNum];
    NSDictionary *songInfo=[dic valueForKey:@"songinfo"];
     NSString *filepath=[NSString stringWithFormat:@"%@/%@-%@.lrc",path,[songInfo valueForKey:@"author"],[songInfo valueForKey:@"title"]];
    NSLog(@"%@",filepath);
    return filepath;
}
-(void)addAnimation{
    //图片动画旋转
    CABasicAnimation* rotationAnimation;
    
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    
    rotationAnimation.cumulative = YES;
    
    rotationAnimation.repeatCount =1000;
    
    //rotationAnimation.repeatDuration=10;
    
    rotationAnimation.duration = 20;
    
    [self.imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
@end
