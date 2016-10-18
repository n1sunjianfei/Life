//
//  PlayView.m
//  Life
//
//  Created by 孙建飞 on 16/10/6.
//  Copyright © 2016年 sjf. All rights reserved.
//

#import "PlayView.h"

@implementation PlayView

+(PlayView*)sharePlayView{
    static PlayView *playView=nil;
    if (playView==nil) {
        
        playView=[[PlayView alloc]init];
    }
    return playView;
}

-(instancetype)init{
    CGRect frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    self=[super initWithFrame:frame];
    if (self) {
        NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"PlayView" owner:nil options:nil];
        //第一个子视图是cell
        UIView *main=[arr objectAtIndex:0];
        main.frame=frame;
        self = (PlayView*)main;
        self.backgroundColor=BACKGROUND_COLOR;
//        NSLog(@"init");

        self.last=@"00:00";
        self.currentNum=-1;
        
        self.pageNum=0;
        //title
        self.lrcLabel.textColor=Blue_Text_COLOR;
        self.currentTimeLabel.textColor=Blue_Text_COLOR;
        self.totalTimeLabel.textColor=Blue_Text_COLOR;
        
        //
        [self.slider setMinimumTrackImage:[UIImage imageNamed:@"slider_blue.png"] forState:UIControlStateNormal];
        [self.slider setMaximumTrackImage:[UIImage imageNamed:@"slider_bg.png"] forState:UIControlStateNormal];
        [self.slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
        
        //
        //更改进度条高度
        self.progressView.transform = CGAffineTransformMakeScale(1.0f,3.0f);
        //
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 60)];
            label.text=@"❤随悦动";
            label.textAlignment=1;
            label.font=[UIFont systemFontOfSize:20];
           // self.navigationItem.titleView=label;
            self.currentTime = 0;
            //
            self.imageView.layer.masksToBounds=YES;
            self.imageView.layer.cornerRadius=75;
        //
        [self addNotification];
        //
        self.downloadBtn.layer.masksToBounds=YES;
        self.downloadBtn.layer.cornerRadius=4;
        //
        [self setupNotification];//活跃度监听

    }
    return self;
}

/*
 添加通知(在appdelegate中就已经调用此方法了）
 */
-(void)addNotification{
//    NSLog(@"addNotify");
   // [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reload:) name:@"jumpToPlayVC" object:nil];
    /*
     给AVPlayerItem添加播放完成通知
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAudioSessionEvent:) name:AVAudioSessionInterruptionNotification object:nil];
}


/*
 播放完成通知
 */
- (void)playbackFinished:(NSNotification *)notification{
    NSLog(@"音乐播放完成.");
    [self nextMusic:nil];
    
}
/*
 中断时调用
 */
- (void)onAudioSessionEvent:(NSNotification *)notification{
    if ([notification.name isEqualToString:AVAudioSessionInterruptionNotification]) {
        //Check to see if it was a Begin interruption
        if ([[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeBegan]]) {
            NSLog(@"Interruption began!");
            
        } else if([[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeEnded]]){
            NSLog(@"Interruption ended!");
            //Resume your audio
            [self.player play];
            
        }
    }
}

// 重写父类成为响应者方法
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

/*
 通知方法，播放选中的音乐;
 */
-(void)reload:(NSMutableDictionary *)dic{
    
    if (self.playlistArr==NULL) {
//        NSLog(@"初始化数组");
        self.playlistArr=[[NSMutableArray alloc]init];
    }
    self.playListTableView=[[PlaylistTableView alloc]initWithFrame:CGRectMake(0, self.imageView.frame.origin.y+self.imageView.frame.size.height, SCREEN_WIDTH-200, 0) style:UITableViewStyleGrouped];
    //NSDictionary *dic=userInfo.userInfo;
    NSArray *arr =[dic valueForKey:@"array"];
    NSString  *index=[dic valueForKey:@"index"];
    self.lastID=[[dic valueForKey:@"lastv"] intValue];
    NSString *title=[dic valueForKey:@"title"];
    int i=[index intValue];
    self.playlistArr=[NSMutableArray arrayWithArray:arr];
    //更新播放列表;
    self.playListTableView=[[PlaylistTableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH,100, SCREEN_WIDTH-105,SCREEN_HEIGHT-100-self.downView.frame.size.height) style:UITableViewStylePlain];
    self.playListTableView.delegate_playlistTableView=self;
    self.playListTableView.dataArr=self.playlistArr;
    //NSLog(@"tbdata%lu",(unsigned long)_playListTableView.dataArr.count);
    [self.playListTableView reloadData];

        if (![Netaccess isWifiAccess]&&![Netaccess isWanAccess]&&![self isLocalFile:i]) {//没网同时也不是本地文件
            [self addAlertView];
        }else{
            //判断选中的歌曲是否正在播放
            if (!(i==self.currentNum&&title==self.lastTitle)) {
                self.lastTitle=title;
                self.currentNum=i;
                //        NSLog(@"reload %d,title:%@",self.currentNum,self.lastTitle);
                
                [self.playButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
                // [self configNowPlayingCenter];
                [self setPlayerAndPlayMusic];
            }
        }
    
}
/*
 获取歌曲列表信息
 */
-(NSDictionary*)loadSongInfo{
    
    //获取歌曲info信息并添加到songinfo数组中
    NSString *songid;
    
        NSString *baseStr;
        if ([[self.playlistArr[self.currentNum] valueForKey:@"songid"] length]>0) {//
            songid=[self.playlistArr[self.currentNum] valueForKey:@"songid"];
            baseStr=[NSString stringWithFormat:@"http://tingapi.ting.baidu.com/v1/restserver/ting?format=json&calback=&from=webapp_music&method=baidu.ting.song.play&songid=%@", songid];
           // NSLog(@"songid");
        }else{//
            // NSLog(@"song_id");
            songid=[self.playlistArr[self.currentNum] valueForKey:@"song_id"];
            baseStr=[NSString stringWithFormat:@"http://tingapi.ting.baidu.com/v1/restserver/ting?format=json&calback=&from=webapp_music&method=baidu.ting.song.play&songid=%@", songid];
            // NSLog(@"b...%@",baseStr);
        }
    //是反本地有下载的文件
    NSDictionary *dic;
    if ([self isLocalFile:self.currentNum]) {
        NSLog(@"本地");
        NSString *songidPath=[NSString stringWithFormat:@"%@/%@.plist",[JsonNetwork getLocalDownloadDir],songid];
        
        dic=[NSDictionary dictionaryWithContentsOfFile:songidPath];
        return dic;
    }else{
        NSLog(@"网络");
        NSString *urlStr=[JsonNetwork encodeUrlStrWithString:baseStr];
        dic=[JsonNetwork loadSonginfoWithUrlstr:urlStr];
        return dic;
    }
 
}
/*
 协议方法
 */
-(void)PlaySelectedMusic:(int)index{
    
    if (![Netaccess isWifiAccess]&&![Netaccess isWanAccess]) {
        [self addAlertView];
    }else{
    if (self.currentNum!=index) {
        self.currentNum=index;
        [self setPlayerAndPlayMusic];
    }
    }
}
-(void)removePlaylistTable{
    [self hidePlaylistTableView:nil];
}
/*
 设置时间label
 */

-(void)setTimeLabel{
//    NSLog(@"设置时间");
//    NSLog(@"%ld",self.playlistArr.count);
//    NSDictionary *dic=[self.playlistArr objectAtIndex:self.currentNum];
    NSDictionary *bitrate=[self.songDic valueForKey:@"bitrate"];
    NSDictionary *songInfo=[self.songDic valueForKey:@"songinfo"];
    self.totalTime=[[bitrate valueForKey:@"file_duration"] intValue];
//    NSLog(@"%ld",(long)self.totalTime);
    self.currentTimeLabel.text=@"00:00";
    self.totalTimeLabel.text=[NSString stringWithFormat:@"%.2ld:%.2ld",self.totalTime/60,self.totalTime%60];
//    NSLog(@"%@",self.totalTimeLabel.text);
    self.nameLabel.text=[songInfo valueForKey:@"title"];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[songInfo valueForKey:@"pic_big"]] placeholderImage:[UIImage imageNamed:@"tem.png"]];
}
/*
 初始化播放器然后播放;
 */
-(void)setPlayerAndPlayMusic{
    
    self.songDic=[self loadSongInfo];
   
    NSString *path=[self getLocalPlayHistoryPlistPath];
    NSMutableArray *arr=[NSMutableArray arrayWithContentsOfFile:path];
    if ([arr containsObject:self.playlistArr[self.currentNum]]) {
        [arr removeObject:self.playlistArr[self.currentNum]];
//        NSLog(@"重新添加");
    }
    [arr addObject:self.playlistArr[self.currentNum]];
    [arr writeToFile:path atomically:YES];
    [self.timer invalidate];
    self.progressView.progress=0;
    [self setMediaPlayer];
}
/*
 初始化播放器;
 */
- (void)setMediaPlayer{
//    NSLog(@"s");
    if (self.playerItem!=nil) {
        [self removeObserverFromPlayerItem:self.playerItem];
        self.playerItem=nil;
    }
    [self.player seekToTime:CMTimeMakeWithSeconds(self.startTime, 1000)];//设置播放位置,1000 为帧率
    if (_playlistArr.count>0) {
//        NSLog(@"初始化播放器");
        /*method=baidu.ting.song.play&songid=877578*/
        
        NSDictionary *bitrate=[self.songDic valueForKey:@"bitrate"];
//        
        NSString *urlStr=[bitrate valueForKey:@"file_link"];
//        NSLog(@"%@",urlStr);
//        NSLog(@"m1");
        //
          dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.isSetPlayer=YES;
              NSDictionary *songinfo=[self.songDic valueForKey:@"songinfo"];
              NSString *filepath=[NSString stringWithFormat:@"%@/%@-%@.mp3",[JsonNetwork getLocalDownloadDir],[songinfo valueForKey:@"author"],[songinfo valueForKey:@"title"]];
              NSURL *url;
              if ([NSData dataWithContentsOfFile:filepath]) {
                  //NSLog(@"本地歌曲");
                  url=[NSURL fileURLWithPath:filepath];
                  dispatch_async(dispatch_get_main_queue(), ^{
                      [self setTimeLabel];
                      [self.downloadBtn setTitle:@"已下载" forState:UIControlStateNormal];
                      self.downloadBtn.enabled=NO;
                  });
                 
              }else{
                  url=[NSURL URLWithString:urlStr];
                  dispatch_async(dispatch_get_main_queue(), ^{
                      
                      [self.downloadBtn setTitle:@"下载" forState:UIControlStateNormal];
                      self.downloadBtn.enabled=YES;
                  });
              }
        _playerItem=[AVPlayerItem playerItemWithURL:url];
        _player = [AVPlayer playerWithPlayerItem:_playerItem];
        _player.volume=1;
//        NSLog(@"m2");

        [self performSelectorOnMainThread:@selector(finishSetPlayer) withObject:nil waitUntilDone:YES];
          });
    }
}
-(void)finishSetPlayer{
//    NSLog(@"m3");
    self.isSetPlayer=NO;
    [self addObserverToPlayerItem:self.playerItem];
    [self.player play];
    [self.playButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    self.iSplay=YES;
    [self configNowPlayingCenter];
    [self getIrc];
    [self addProgressObserver];//进度监听

}

//获取歌词文件
-(void)getIrc{

//    NSDictionary *dic=[self.playlistArr objectAtIndex:self.currentNum];
    NSDictionary *songInfo=[self.songDic valueForKey:@"songinfo"];
    NSString *lrcStr=[songInfo valueForKey:@"lrclink"];

    if (lrcStr.length==0) {//没有歌词文件
        [self ana];
    }else{
    if ([NSData dataWithContentsOfFile:[JsonNetwork getLocalFilePathWith:songInfo]]) {
      //  NSLog(@"本地歌词");
        self.isGetLrc=YES;
        [self ana];
    }else{
        self.isGetLrc=YES;
        [JsonNetwork getLrcWithUrlstr:lrcStr withSonginfo:songInfo block:^(NSDictionary *dic) {
            [self performSelectorOnMainThread:@selector(ana) withObject:nil waitUntilDone:YES];
        }];
    }
    }
}
//解析歌词
-(void)ana{

//    NSLog(@"ana");
    NSString *lyc = [NSString stringWithContentsOfFile:[JsonNetwork getLocalFilePathWith:[self.songDic valueForKey:@"songinfo"]] encoding:NSUTF8StringEncoding error:nil];
//    NSLog(@"歌词----%@",lyc);
    NSArray *lycArray = [lyc componentsSeparatedByString:@"\n"];
    NSMutableDictionary *temdic=[[NSMutableDictionary alloc]init];
    if (lycArray.count==1||lycArray.count==0) {//没有歌词的音乐
//        self.lrcLabel.text=@"该歌曲没有歌词,请欣赏！";
    }
    for (int i = 0; i < [lycArray count]; i++) {
        
        NSString *lineString = [lycArray objectAtIndex:i];
        
        NSArray *lineArray = [lineString componentsSeparatedByString:@"]"];

        if ([lineArray[0] length] > 8) {
            
            NSString *str1 = [lineString substringWithRange:NSMakeRange(3, 1)];
            
            NSString *str2 = [lineString substringWithRange:NSMakeRange(6, 1)];
            
            if ([str1 isEqualToString:@":"] && [str2 isEqualToString:@"."]) {
                
                for (int i = 0; i < lineArray.count - 1; i++) {
                    
                    NSString *lrcString = [lineArray objectAtIndex:lineArray.count - 1];
                    if ([[lineArray objectAtIndex:i] length]>8) {
                        
                        //分割区间求歌词时间
                        NSString *timeString =[[lineArray objectAtIndex:i] substringWithRange:NSMakeRange(1, 5)];
                        [temdic setValue:lrcString forKey:timeString];
//                        NSLog(@"词：%@",lrcString);
//                        NSLog(@"时：%@",timeString);
                    }

                    
                    
                    // NSLog(@"%lu",(unsigned long)self.timeArr.count);
                    // NSLog(@"%lu",(unsigned long)self.stringArr.count);
                }
            }
        }
    }
//    NSLog(@"ana");
    //开启子线程，查询是否正在滚动，滚动结束时添加新的lrcTable;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int i=0;
        do {
            [NSThread sleepForTimeInterval:0.1];

//            NSLog(@"是否正在滚动查询：1...%d次  %d",i+1,self.isLrcTableScrolling);
            //lrctable不滚动时添加新的
            if (self.isLrcTableScrolling==NO&&self.isSetPlayer==NO) {
//                NSLog(@"滚动结束");

                dispatch_async(dispatch_get_main_queue(), ^{
                    self.lrcLabel.text=@"正在加载歌词...";
                    [self addLrcTableWith:temdic];
                    self.currentLrcIndex=-3;
                    self.nextButton.enabled=YES;
                    self.upButton.enabled=YES;
                });
                break;
            }
            i++;
        } while (i<1000);
    });
    
}
-(void)addLrcTableWith:(NSMutableDictionary*)temdic{

//    NSLog(@"addLrcTable");
    _timeArr=[[NSMutableArray alloc]init];
    _stringArr=[[NSMutableArray alloc]init];
    [self.lrcTable removeFromSuperview];
    self.lrcTable=nil;
    
    //排序
    NSArray *arr=[temdic allKeys];
    if (arr.count>10) {
        NSArray *sortedArr=[arr sortedArrayUsingComparator:^NSComparisonResult(id   obj1, id   obj2) {
            return [obj1 compare:obj2];
        }];
        [self.timeArr addObjectsFromArray:sortedArr];
        for (int i=0; i<self.timeArr.count; i++) {
            //  NSLog(@"%@",self.timeArr[i]);
            if ([temdic valueForKey:self.timeArr[i]]!=nil) {
                [self.stringArr addObject:[temdic valueForKey:self.timeArr[i]]];
            }
        }
        
        if (self.pageNum==1&&self.stringArr.count>0) {
//            NSLog(@"contain");
            
            [self CreateTable];
            [self addSubview:self.lrcTable];
            
            if ([self.subviews containsObject:self.playListTableView]) {
                [self bringSubviewToFront:self.hidePlayListButton];
                [self bringSubviewToFront:self.playListTableView];
            }
        }
        self.isGetLrc=NO;
        self.timer=nil;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTimeAndSliderValue) userInfo:nil repeats:YES];
    }else{
        self.isGetLrc=NO;
        self.timer=nil;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTimeAndSliderValue) userInfo:nil repeats:YES];
    }

}
/*
 更新时间labe和slider
 */
-(void)updateTimeAndSliderValue{
    if (self.playerItem) {
        long long cur=self.playerItem.currentTime.value/self.playerItem.currentTime.timescale;
        //
        self.currentTimeLabel.text=[NSString stringWithFormat:@"%.2lld:%.2lld",cur/60,cur%60];
//        NSDictionary *dic=[self.playlistArr objectAtIndex:self.currentNum];
        NSDictionary *bitrate=[self.songDic valueForKey:@"bitrate"];
        //   NSDictionary *songInfo=[dic valueForKey:@"songinfo"];
        int total=[[bitrate valueForKey:@"file_duration"] intValue];
        self.slider.value=(float)cur/(float)total;
       // NSLog(@"lrc...");
        if (self.timeArr.count>2&&self.stringArr.count>2) {
            //NSLog(@"歌词存在");
//          static  int index=0;
            
            //NSLog(@"%@",lrcString);
            if ([self.timeArr containsObject:self.currentTimeLabel.text]) {
                self.currentLrcIndex=(int)[self.timeArr indexOfObject:self.currentTimeLabel.text];
                //内容不为空时传值
                if (![[self.stringArr objectAtIndex:self.currentLrcIndex] isEqual:@""]) {
                   // NSLog(@"%@",[self.stringArr objectAtIndex:index]);
                    self.lrcLabel.text=[self.stringArr objectAtIndex:self.currentLrcIndex];

                }
            }
            if (self.lrcTable!=nil&&self.stringArr.count>0) {
               
                if (self.isGetLrc!=YES) {
                    self.currentRowIndex=self.currentLrcIndex+5;
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:self.currentRowIndex inSection:0];
                    
                    [self.lrcTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                    
                    [self.lrcTable reloadData];
                }
            }
        }else{//没有歌词文件
            self.lrcLabel.text=@"该歌曲没有歌词,请欣赏！";
        }
    }
}
/*
 进度监听
 */
#pragma mark - KVO
- (void)addProgressObserver{
    AVPlayerItem *playerItem = self.player.currentItem;
    //这里设置每秒执行一次
    __weak __typeof(self) weakself = self;
    self.timeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        _currentTime=current;
        //float t=CMTimeGetSeconds(playerItem.)
        
        float total = CMTimeGetSeconds(playerItem.duration);
        _totalTime=total;
        //NSLog(@"当前已经播放%f",current);
        weakself.currentTime = current;
        if (current) {
           // [weakself setTime:(int)current withTotal:total];
        }
    }];
}

/*
给AVPlayerItem添加监控
*/
- (void)addObserverToPlayerItem:(AVPlayerItem *)playerItem{
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监控网络加载情况属性
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    //监听播放的区域缓存是否为空
    [playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    //缓存可以播放的时候调用
    [playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
}
/*
 给AVPlayerItem移除监控
 */
- (void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem{
    
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    AVPlayerItem *playerItem = object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
        if(status == AVPlayerStatusReadyToPlay){
            //  self.totalTime = CMTimeGetSeconds(playerItem.duration);
            CGFloat total=CMTimeGetSeconds(playerItem.duration);
            self.totalTime=total;
//            NSLog(@"开始播放,音频总长度:%.2f",total);
            [self setTimeLabel];
            if (self.player.rate==1) {
                [_player play];
            }
        }else if(status == AVPlayerStatusUnknown){
            NSLog(@"%@",@"AVPlayerStatusUnknown");
        }else if (status == AVPlayerStatusFailed){
            NSLog(@"%@",@"AVPlayerStatusFailed");
        }
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSArray *array = playerItem.loadedTimeRanges;
//@@@@@@@@
        
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
//        NSLog(@"缓冲：%f,total=%ld",totalBuffer,(long)self.totalTime);
        
        if (totalBuffer>0&&self.isGetLrc==NO) {
        }
        //更新progreView进度；
        if (self.totalTime!=0) {
            self.progressView.progress=totalBuffer/self.totalTime;
        }
        //
        if (self.currentTime < (startSeconds + durationSeconds + 8)&&self.player.rate==1) {
            [_player play];
        }
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
    if(self.iSplay){
        [self.playButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        
    }else{
        [self.playButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    }
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
//    NSDictionary *dic=[self.playlistArr objectAtIndex:self.currentNum];
//    NSDictionary *bitrate=[dic valueForKey:@"bitrate"];
//    NSDictionary *songInfo=[dic valueForKey:@"songinfo"];
//    int total=[[bitrate valueForKey:@"file_duration"] intValue];
//    self.totalTime
    long long tt=sender.value*self.totalTime;
    CMTime cmtime=CMTimeMake(tt, 1);
    [self.player pause];
    [self.playButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    [self.playerItem seekToTime:cmtime completionHandler:^(BOOL finished) {
        self.iSplay=YES;
        [self.playButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
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
            _playListTableView.frame=CGRectMake(0,SCREEN_HEIGHT, SCREEN_WIDTH,SCREEN_HEIGHT-200);
        } completion:^(BOOL finished) {
            [self sendSubviewToBack:self.hidePlayListButton];
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
    if (_isPlayListShow) {//out
        [UIView animateWithDuration:0.3 animations:^{
            _playListTableView.frame=CGRectMake(0,SCREEN_HEIGHT, SCREEN_WIDTH,SCREEN_HEIGHT-200-64);
            //self.playListTableView.alpha=1;
        } completion:^(BOOL finished) {
            [self.playListTableView removeFromSuperview];
            [self sendSubviewToBack:self.hidePlayListButton];

            _isPlayListShow=NO;
        }];
    }else{//in
        [self bringSubviewToFront:self.hidePlayListButton];
        [_playListTableView removeFromSuperview];
        _playListTableView=[[PlaylistTableView alloc]initWithFrame:CGRectMake(0, self.imageView.frame.origin.y+self.imageView.frame.size.height, SCREEN_WIDTH, 0) style:UITableViewStylePlain];
        _playListTableView.layer.masksToBounds=YES;
        _playListTableView.layer.cornerRadius=5;
        _playListTableView.frame=CGRectMake(0,SCREEN_HEIGHT, SCREEN_WIDTH,SCREEN_HEIGHT-200-64);
        _playListTableView.delegate_playlistTableView=self;
        _playListTableView.dataArr=self.playlistArr;
        [_playListTableView reloadData];
        [self addSubview:_playListTableView];
        
        [UIView animateWithDuration:0.3 animations:^{
            _playListTableView.frame=CGRectMake(0, 200, SCREEN_WIDTH, SCREEN_HEIGHT-200-64);
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
- (IBAction)lastMusic:(UIButton*)sender {
    int lastnum=self.currentNum;
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
    if (![Netaccess isWifiAccess]&&![Netaccess isWanAccess]&&![self isLocalFile:self.currentNum]) {//没网同时也不是本地文件
        [self addAlertView];
        self.currentNum=lastnum;
    }else{
    
    self.nextButton.enabled=NO;
    self.upButton.enabled=NO;
    [self setPlayerAndPlayMusic];
    }
}
/*
 下一首
 */
- (IBAction)nextMusic:(UIButton *)sender {
    int lastnum=self.currentNum;

    if (_playlistArr.count<2) {
        NSLog(@"只有一首歌曲");
        return;
    }
    
    if (self.currentNum==self.playlistArr.count-1) {
        self.currentNum=0;
    }else{
        self.currentNum++;
    }

        if (![Netaccess isWifiAccess]&&![Netaccess isWanAccess]&&![self isLocalFile:self.currentNum]) {//没网同时也不是本地文件
            [self addAlertView];
            self.currentNum=lastnum;
        }else{//有网或者是本地文件

            self.nextButton.enabled=NO;
            self.upButton.enabled=NO;
            [self setPlayerAndPlayMusic];
        }
}

/*
 播放；
 */
- (IBAction)playMusic:(UIButton *)sender {
    
    if (self.iSplay) {
        [self.player pause];
        [sender setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        self.iSplay=!self.iSplay;
        //self.tabBarController.tabBar.hidden=YES;
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


//Now Playing Center可以在锁屏界面展示音乐的信息，也达到增强用户体验的作用。
////传递信息到锁屏状态下 此方法在播放歌曲与切换歌曲时调用即可

- (void)configNowPlayingCenter {
//    NSLog(@"锁屏设置");
    // BASE_INFO_FUN(@"配置NowPlayingCenter");
    NSMutableDictionary * info = [NSMutableDictionary dictionary];
    //音乐的标题
    [info setObject:[[self.songDic valueForKey:@"songinfo"] valueForKey:@"title"] forKey:MPMediaItemPropertyTitle];
    //音乐的艺术家
    NSString *author= [[self.songDic valueForKey:@"songinfo"] valueForKey:@"author"];
    [info setObject:author forKey:MPMediaItemPropertyArtist];
    //音乐的播放时间
    [info setObject:@(self.player.currentTime.value) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    //音乐的播放速度
    [info setObject:@(1) forKey:MPNowPlayingInfoPropertyPlaybackRate];
    //音乐的总时间
    [info setObject:@(self.totalTime) forKey:MPMediaItemPropertyPlaybackDuration];

//        NSDictionary *dic=[self.playlistArr objectAtIndex:self.currentNum];
        NSDictionary *songInfo=[self.songDic valueForKey:@"songinfo"];

        NSURL *url=[NSURL URLWithString:[songInfo valueForKey:@"pic_big"]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data=[NSData dataWithContentsOfURL:url];
        
        UIImage *image=[UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (image) {
                //音乐的封面
                MPMediaItemArtwork * artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
                [info setObject:artwork forKey:MPMediaItemPropertyArtwork];
                //完成设置
                [[MPNowPlayingInfoCenter defaultCenter]setNowPlayingInfo:info];
            }
            
        });
    });
}


/*
 专辑图片旋转动画
 */
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


/*
 左右滑动响应
 */
- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
//    NSLog(@"swipe");
    if (sender.direction==UISwipeGestureRecognizerDirectionLeft) {//左滑
        if (self.pageNum<1) {
            self.pageNum++;
            self.pageControl.currentPage=self.pageNum;
            if (self.stringArr.count>0) {
                [self CreateTable];
            }
            [self addSubview:self.lrcTable];
            [self animateInWith:self.lrcTable];
            if ([self.subviews containsObject:self.playListTableView]) {
                [self sendSubviewToBack:self.lrcTable];
                [self sendSubviewToBack:self.imageView];
                [self sendSubviewToBack:self.lrcLabel];
                [self bringSubviewToFront:self.playListTableView];
            }
        }
    }else{//右滑
        if (self.pageNum==1) {
            CGPoint center=self.lrcTable.center;
            [UIView animateWithDuration:0.3 animations:^{
                self.lrcTable.center=CGPointMake(SCREEN_WIDTH*1.5, center.y);
            } completion:^(BOOL finished) {
                [self.lrcTable removeFromSuperview];
                self.pageNum--;
                self.pageControl.currentPage=self.pageNum;
            }];
            
            
        }else if (self.pageNum==0) {
            if ([self.subviews containsObject:self.playListTableView]) {
                [self removePlaylistTable];
            }
            [self.delegate removeFromSuperView];
        }
    }
}
/*
 动画效果进入
 */
-(void)animateInWith:(UIView*)view{
    //动画效果
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.3;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromRight;
    [view.layer addAnimation:animation forKey:@"animation"];
}
/*
 动画效果退出
 */
-(void)animateOutWith:(UIView*)view{
    //动画效果
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.3;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromLeft;
    [view.layer addAnimation:animation forKey:@"animation"];
}
/*
 *
 *歌词TableView
 *
 */
-(void)CreateTable{
    self.lrcTable=nil;
    self.lrcTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT-50-90-64-30) style:UITableViewStylePlain];
    self.lrcTable.backgroundColor=[UIColor clearColor];
    self.lrcTable.allowsSelection=NO;
    self.lrcTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.lrcTable.delegate=self;
    self.lrcTable.dataSource=self;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.stringArr.count+10;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.textAlignment=1;
        cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.backgroundColor=BACKGROUND_COLOR;
        cell.textLabel.alpha=0.8;
        cell.textLabel.numberOfLines=2;
        cell.textLabel.lineBreakMode=NSLineBreakByWordWrapping;
    }
    if (indexPath.row<5) {
        cell.textLabel.text=@"  ";
    }else if (indexPath.row-5<self.stringArr.count) {
        cell.textLabel.text=self.stringArr[indexPath.row-5];
    }else {
        cell.textLabel.text=@"  ";
    }

    if (cell.textLabel.text.length==0) {
        cell.textLabel.text=@"......";
    }else{
        
    }
    if (indexPath.row==self.currentRowIndex) {
        cell.textLabel.font=[UIFont systemFontOfSize:20];
        cell.textLabel.textColor=Purple_Text_COLOR;
        
    }else{
        cell.textLabel.font=[UIFont systemFontOfSize:15];

        cell.textLabel.textColor=[UIColor grayColor];

    }
   // NSLog(@"cell");
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.isLrcTableScrolling=YES;
   // NSLog(@"scolling");
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
  //  NSLog(@"end");
    self.isLrcTableScrolling=NO;

}
//-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    NSLog(@"手动停止滚动");
//}
//-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
//    NSLog(@"end zooming");
//}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
//    NSLog(@"begin 手动滚动");
    self.isLrcTableScrolling=YES;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    NSLog(@"end 手动滚动");
    self.isLrcTableScrolling=NO;
}

/*
 获取播放历史plist路径
 */
-(NSString *)getLocalPlayHistoryPlistPath{
    NSFileManager *manager=[NSFileManager defaultManager];
    NSArray *arr=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path=[arr objectAtIndex:0];
    NSString *dirPath=[path stringByAppendingPathComponent:@"/playHistoryList.plist"];
    if (![manager fileExistsAtPath:dirPath]) {
        NSMutableArray *imageDic=[[NSMutableArray alloc]init];
        [imageDic writeToFile:dirPath atomically:YES];
    }
//        NSLog(@"%@",dirPath);
    return dirPath;
}
///*
// 获取下载文件夹路径
// */
//-(NSString *)getLocalDownloadDir{
//    NSFileManager *manager=[NSFileManager defaultManager];
//    NSArray *arr=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *path=[arr objectAtIndex:0];
//    NSString *dirPath=[path stringByAppendingPathComponent:@"/Download"];
//    if (![manager fileExistsAtPath:dirPath]) {
//        [manager createDirectoryAtPath:dirPath withIntermediateDirectories:NO attributes:nil error:nil];
//    }
////    NSLog(@"%@",dirPath);
//    return dirPath;
//}
///*
// 获取下载列表路径
// */
//-(NSString *)getLocalDownloadHistoryPlistPath{
//    NSFileManager *manager=[NSFileManager defaultManager];
//    NSArray *arr=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *path=[arr objectAtIndex:0];
//    NSString *dirPath=[path stringByAppendingPathComponent:@"/Download/downloadList.plist"];
//    if (![manager fileExistsAtPath:dirPath]) {
//        NSMutableArray *downloadDic=[[NSMutableArray alloc]init];
//        [downloadDic writeToFile:dirPath atomically:YES];
//    }
////    NSLog(@"%@",dirPath);
//    return dirPath;
//}
-(void)addAlertView{
    UIAlertView *misNet=[[UIAlertView alloc]initWithTitle:@"网络不可用" message:@"去设置网络吧" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [misNet show];
}
- (IBAction)downloadSong:(UIButton *)sender {

    if ([Netaccess isWanAccess]||[Netaccess isWifiAccess]) {
        if (self.playerItem) {
            [sender setTitle:@"下载中" forState:UIControlStateNormal];
            sender.enabled=NO;
            [JsonNetwork downloadMp3With:self.playlistArr[self.currentNum] andSongdic:self.songDic block:^(NSDictionary *dic) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.downloadBtn setTitle:@"已下载" forState:UIControlStateNormal];
                    UIAlertView *misNet=[[UIAlertView alloc]initWithTitle:@"下载完成" message:@"可以本地播放咯" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [misNet show];
                });
            }];
        }
    }else{
        [self addAlertView];
    }
    
    
}
-(BOOL)isLocalFile:(int)index{
    NSString *filename;
    if ([[self.playlistArr[index] valueForKey:@"songid"] length]>0) {//
        filename=[NSString stringWithFormat:@"/%@.plist",[self.playlistArr[index] valueForKey:@"songid"]];
    }else{
        filename=[NSString stringWithFormat:@"%@/%@.plist",[JsonNetwork getLocalDownloadDir],[self.playlistArr[index] valueForKey:@"song_id"]];
    }
//    NSLog(@"%@",filename);
    
    if ([NSData dataWithContentsOfFile:filename]) {
        //本地
        return YES;
    }else{
        return NO;
    }
}
@end
