//
//  MusicVC.m
//  Life
//
//  Created by 孙建飞 on 16/9/21.
//  Copyright © 2016年 sjf. All rights reserved.
//

#import "MusicVC.h"

@interface MusicVC ()

@end

@implementation MusicVC

-(void)awakeFromNib{
  //   self.scrollView.contentSize=CGSizeMake(320, SCREEN_HEIGHT*2);
}
-(NSArray*)singgerArr{
    if (!_singgerArr) {
        _singgerArr=[[NSArray alloc]initWithObjects:@"薛之谦", @"周杰伦",@"陈奕迅",@"好妹妹乐队",@"严艺丹",@"郁可唯",@"庄心妍",@"张靓颖",nil];
    }
    return _singgerArr;
}
-(NSArray*)singgerIDArr{
    if (!_singgerIDArr) {
        _singgerIDArr=[[NSArray alloc]initWithObjects:@"2517",@"7994",@"1077",@"31514359",@"449075",@"1581",@"28646904",@"1026", nil];
    }
    return _singgerIDArr;
}
-(NSArray*)colorsArr{
    if (!_colorsArr) {
        _colorsArr=[[NSArray alloc]initWithObjects:
        [UIColor colorWithRed:250/255.0 green:235/255.0 blue:215/255.0 alpha:1.0],
        [UIColor colorWithRed:210/255.0 green:255/255.0 blue:255/255.0 alpha:1.0],
        [UIColor colorWithRed:255/255.0 green:222/255.0 blue:173/255.0 alpha:1.0],
        [UIColor colorWithRed:135/255.0 green:38/255.0 blue:87/255.0 alpha:1.0],
        [UIColor colorWithRed:61/255.0 green:89/255.0 blue:171/255.0 alpha:1.0],
        [UIColor colorWithRed:218/255.0 green:165/255.0 blue:105/255.0 alpha:1.0],
        [UIColor colorWithRed:65/255.0 green:105/255.0 blue:225/255.0 alpha:1.0],
        [UIColor colorWithRed:135/255.0 green:206/255.0 blue:235/255.0 alpha:1.0],
        [UIColor colorWithRed:0/255.0 green:255/255.0 blue:0/255.0 alpha:1.0],
        [UIColor colorWithRed:46/255.0 green:139/255.0 blue:87/255.0 alpha:1.0],

    nil];
}
return _colorsArr;
}
-(NSArray*)songListArr{
    if (!_songListArr) {
        _songListArr=[[NSArray alloc]initWithObjects:
        [NSDictionary dictionaryWithObjectsAndKeys:@"新歌榜",@"title",@"1",@"value", nil],
        [NSDictionary dictionaryWithObjectsAndKeys:@"热歌榜",@"title",@"2",@"value",nil],
        [NSDictionary dictionaryWithObjectsAndKeys:@"爵士",@"title",@"12",@"value", nil],
        [NSDictionary dictionaryWithObjectsAndKeys:@"流行",@"title",@"16",@"value", nil],
        [NSDictionary dictionaryWithObjectsAndKeys:@"欧美金曲",@"title",@"21",@"value", nil],
        [NSDictionary dictionaryWithObjectsAndKeys:@"经典老歌",@"title",@"22",@"value", nil],
        [NSDictionary dictionaryWithObjectsAndKeys:@"情歌对唱",@"title",@"23",@"value", nil],
        [NSDictionary dictionaryWithObjectsAndKeys:@"影视金曲",@"title",@"24",@"value", nil],
        [NSDictionary dictionaryWithObjectsAndKeys:@"网络歌曲",@"title",@"25",@"value", nil],
                      nil];
    }
    return _songListArr;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden=NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithTitle:@"展示" style:UIBarButtonItemStylePlain target:self action:@selector(show)];
    self.navigationController.navigationItem.rightBarButtonItem=rightBtn;
    self.title=@"听音乐";
   // self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.jpg"]];
    self.view.backgroundColor=BACKGROUND_COLOR;
    [self addSinger];
    [self addSongsList];
    [self addPlayHistoryView];
    self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, 600);
    self.searchbar.delegate=self;
}

-(void)addSinger{
    UILabel *singger=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, 30)];
    singger.text=@"歌手:";
    singger.textColor=[UIColor blackColor];
    [self.scrollView addSubview:singger];
    float midedge=(SCREEN_WIDTH-60*4)/5;
    float width=60;
    
    for (int i=0; i<8; i++) {
        //
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag=i;
        [btn setTitle:[self.singgerArr objectAtIndex:i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(Player:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame=CGRectMake(midedge+i%4*(width+midedge),singger.frame.size.height+singger.frame.origin.y+10+i/4*(80+10), width, 80);
        [self.scrollView addSubview:btn];
        //
        UIImageView *image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]]];
        image.frame=CGRectMake(midedge+i%4*(width+midedge), singger.frame.size.height+singger.frame.origin.y+10+i/4*(80+10), width, width);
        [self.scrollView addSubview:image];
        //
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(midedge+i%4*(width+midedge), singger.frame.size.height+singger.frame.origin.y+70+i/4*(80+10), width, 20)];
        label.text=[self.singgerArr objectAtIndex:i];
        label.textAlignment=1;
        [self.scrollView addSubview:label];
        //
    }
}
-(void)addSongsList{
    UILabel *singger=[[UILabel alloc]initWithFrame:CGRectMake(10, 230, 300, 30)];
    singger.text=@"榜单：";
    singger.textColor=[UIColor blackColor];
    [self.scrollView addSubview:singger];
    float midedge=15;
    float width=(SCREEN_WIDTH-midedge*5)/3;
    
    for (int i=0; i<self.songListArr.count; i++) {
        //
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag=i;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:[[self.songListArr objectAtIndex:i] valueForKey:@"title"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(getList:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame=CGRectMake(midedge+i%3*(width+midedge),singger.frame.size.height+singger.frame.origin.y+10+i/3*(30+10), width, 30);
        btn.backgroundColor=[self.colorsArr objectAtIndex:i];
        btn.layer.masksToBounds=YES;
        btn.layer.cornerRadius=10;
        btn.layer.borderWidth=1;
        btn.layer.borderColor=[UIColor clearColor].CGColor;
        [self.scrollView addSubview:btn];
    //
    }
}
-(void)addPlayHistoryView{
    //
    UILabel *playHis=[[UILabel alloc]initWithFrame:CGRectMake(10, 400, 300, 30)];
    playHis.text=@"播放：";
    playHis.textColor=[UIColor blackColor];
    [self.scrollView addSubview:playHis];
    //
    UIButton *playHisBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [playHisBtn setTitle:@"查看播放记录" forState:UIControlStateNormal];
    [playHisBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [playHisBtn setFrame:CGRectMake(20, playHis.frame.origin.y+playHis.frame.size.height, SCREEN_WIDTH-40, 40)];
    playHisBtn.backgroundColor=[self.colorsArr objectAtIndex:1];
    playHisBtn.layer.masksToBounds=YES;
    playHisBtn.layer.cornerRadius=10;
    playHisBtn.layer.borderWidth=1;
    playHisBtn.layer.borderColor=[UIColor clearColor].CGColor;
    [playHisBtn addTarget:self action:@selector(showPlayHistory:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:playHisBtn];
    //
    UIButton *clearHisBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [clearHisBtn setTitle:@"清空缓存和播放记录" forState:UIControlStateNormal];
    [clearHisBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [clearHisBtn setFrame:CGRectMake(20, playHisBtn.frame.origin.y+playHisBtn.frame.size.height+10, SCREEN_WIDTH-40, 40)];
    clearHisBtn.backgroundColor=[self.colorsArr objectAtIndex:2];
    clearHisBtn.layer.masksToBounds=YES;
    clearHisBtn.layer.cornerRadius=10;
    clearHisBtn.layer.borderWidth=1;
    clearHisBtn.layer.borderColor=[UIColor clearColor].CGColor;
    [clearHisBtn addTarget:self action:@selector(clearPlayHistory:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:clearHisBtn];
    
    ////
    UIButton *download=[UIButton buttonWithType:UIButtonTypeCustom];
    [download setTitle:@"本地音乐" forState:UIControlStateNormal];
    [download setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [download setFrame:CGRectMake(20, clearHisBtn.frame.origin.y+clearHisBtn.frame.size.height+10, SCREEN_WIDTH-40, 40)];
    download.backgroundColor=[self.colorsArr objectAtIndex:7];
    download.layer.masksToBounds=YES;
    download.layer.cornerRadius=10;
    download.layer.borderWidth=1;
    download.layer.borderColor=[UIColor clearColor].CGColor;
    [download addTarget:self action:@selector(DownloadHistory:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:download];
    
}
-(void)showPlayHistory:(UIButton*)sender{
    
    NSString *path=[self getLocalPlayHistoryPlistPath];
    NSMutableArray *arr=[NSMutableArray arrayWithContentsOfFile:path];
    if (arr.count>0) {
    //更新播放列表;
        PlayHistory *history=[[PlayHistory alloc]init];
        history.title=@"播放记录";
        // Do any additional setup after loading the view from its nib.
        history.type=@"history";
        history.dataArr=arr;
        [self.navigationController pushViewController:history animated:YES];
    }else{
        NSLog(@"播放记录为空");
    }
}

-(void)clearPlayHistory:(UIButton*)sender{
    NSString *path= [self getLocalFilePath] ;
    NSString *path1=[path stringByAppendingPathComponent:@"/lrc"];
    NSString *path2=[path stringByAppendingPathComponent:@"/default/com.hackemist.SDWebImageCache.default"];
    NSString *path3=[path stringByAppendingPathComponent:@"/gif"];
    NSString *path4=[path stringByAppendingPathComponent:@"/playHistoryList.plist"];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    //歌词文件
    NSDirectoryEnumerator *myDirectoryEnumerator1 = [fileManager enumeratorAtPath:path1];//文件夹
    NSString *filename1;
    CGFloat lrcSize=0;
    while((filename1=[myDirectoryEnumerator1 nextObject]))     //遍历当前目录
        
    {
        if([[filename1 pathExtension] isEqualToString:@"lrc"])  //取得后缀名为lrc的文件名
        {
            NSString *filePath=[path1 stringByAppendingPathComponent:filename1];
            CGFloat temsize=  [[fileManager attributesOfItemAtPath:filePath error:nil] fileSize];
            lrcSize=lrcSize+temsize;
        }
    }
    
    //图片文件
    NSDirectoryEnumerator *myDirectoryEnumerator2 = [fileManager enumeratorAtPath:path2];//文件夹
    NSString *filename2;
    CGFloat imageSize=0;
    while((filename2=[myDirectoryEnumerator2 nextObject]))     //遍历当前目录
        
    {
        if(filename2!=nil)  //取得后缀名为lrc的文件名
        {
            NSString *filePath=[path2 stringByAppendingPathComponent:filename2];
            CGFloat temsize=  [[fileManager attributesOfItemAtPath:filePath error:nil] fileSize];
            imageSize=imageSize+temsize;
        }
    }
    
    //gif图片文件
    NSDirectoryEnumerator *myDirectoryEnumerator3 = [fileManager enumeratorAtPath:path3];//文件夹
    NSString *filename3;
    CGFloat gifSize=0;
    while((filename3=[myDirectoryEnumerator3 nextObject]))     //遍历当前目录
        
    {
        if(filename3!=nil)  //取得后缀名为lrc的文件名
        {
            NSString *filePath=[path3 stringByAppendingPathComponent:filename3];
            CGFloat temsize=  [[fileManager attributesOfItemAtPath:filePath error:nil] fileSize];
            gifSize=gifSize+temsize;
        }
    }
    //
    CGFloat playhisSize=[[NSData dataWithContentsOfFile:path4] length];
    
    NSString *lrcStr;
    NSString *imageStr;
    NSString *hisStr;

    if (lrcSize/1024>1024) {
        lrcStr=[NSString stringWithFormat:@"%.2fMb",lrcSize/1024/1024];
    }else{
        lrcStr=[NSString stringWithFormat:@"%.2fKb",lrcSize/1024];
    }
    if ((imageSize+gifSize)/1024>1024) {
        imageStr=[NSString stringWithFormat:@"%.2fMb",(imageSize+gifSize)/1024/1024];
    }else{
        imageStr=[NSString stringWithFormat:@"%.2fKb",(imageSize+gifSize)/1024];
    }
    if (playhisSize/1024>1024) {
        hisStr=[NSString stringWithFormat:@"%.2fMb",playhisSize/1024/1024];
    }else{
        hisStr=[NSString stringWithFormat:@"%.2fKb",playhisSize/1024];
    }
    NSString *message=[NSString stringWithFormat:@"图片文件：%@\n歌词文件：%@\n播放记录：%@",imageStr,lrcStr,hisStr];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"确定要清除缓存吗！" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"清除图片",@"清除歌词",@"清除播放记录",@"清除所有", nil];
    [alert show];
 
}
-(void)DownloadHistory:(UIButton*)sender{
    NSString *path=[JsonNetwork getLocalDownloadHistoryPlistPath];
    NSMutableArray *arr=[NSMutableArray arrayWithContentsOfFile:path];
    if (arr.count>0) {
        //更新播放列表;
        PlayHistory *history=[[PlayHistory alloc]init];
        history.title=@"本地文件";
        history.type=@"download";
        history.dataArr=arr;
        [self.navigationController pushViewController:history animated:YES];
    }else{
        NSLog(@"播放记录为空");
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path= [self getLocalFilePath] ;
    NSString *path1=[path stringByAppendingPathComponent:@"/lrc"];
    NSString *path2=[path stringByAppendingPathComponent:@"/default/com.hackemist.SDWebImageCache.default"];
    NSString *path3=[path stringByAppendingPathComponent:@"/gif"];
    NSString *path4=[path stringByAppendingPathComponent:@"/playHistoryList.plist"];
    NSString *title=[alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"取消"]) {
//        NSLog(@"取消");

    }else if ([title isEqualToString:@"清除歌词"]){
        [fileManager removeItemAtPath:path1 error:nil];
    }else if ([title isEqualToString:@"清除图片"]){
        [fileManager removeItemAtPath:path2 error:nil];
        [fileManager removeItemAtPath:path3 error:nil];        
    }else if ([title isEqualToString:@"清除播放记录"]){
        [fileManager removeItemAtPath:path4 error:nil];
    }else if ([title isEqualToString:@"清除所有"]){
        [fileManager removeItemAtPath:path1 error:nil];
        [fileManager removeItemAtPath:path2 error:nil];
        [fileManager removeItemAtPath:path3 error:nil];
        [fileManager removeItemAtPath:path4 error:nil];
    }
}
/*http://tingapi.ting.baidu.com/v1/restserver/ting*/
//获取歌手的歌曲
- (IBAction)Player:(UIButton *)sender {
   
    [self pushWithTitle:sender.titleLabel.text andType:nil andSingerId:self.singgerIDArr[sender.tag]];
}
-(void)pushWithTitle:(NSString*)title andType:(NSString*)type andSingerId:(NSString*)singerId{
    if (![Netaccess isWifiAccess]&&![Netaccess isWanAccess]) {
        [self addAlertView];
    }else{
    
    self.playlistVC=[[PlaylistVC alloc]init];
    self.playlistVC.title=title;
    self.playlistVC.singerId=singerId;
    self.playlistVC.type=type;
    [self.navigationController pushViewController:self.playlistVC animated:YES];
    }
}
//获取榜单歌曲
-(void)getList:(UIButton*)sender{

    [self pushWithTitle:sender.titleLabel.text andType:[self.songListArr[sender.tag] valueForKey:@"value"] andSingerId:nil];
}
- (IBAction)cancel:(UIButton *)sender {
    [self.searchbar resignFirstResponder];
    self.cancelButton.hidden=YES;
    self.searchbar.text=nil;
}

/*
 searchBar 协议方法
 */
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.cancelButton.hidden=NO;
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.cancelButton.hidden=YES;
    [searchBar resignFirstResponder];
    [self pushWithTitle:searchBar.text andType:nil andSingerId:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 获取文件路径
 */
-(NSString *)getLocalFilePath{
    
    NSArray *arr=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path=[arr objectAtIndex:0];

 //       NSLog(@"%@",path);
    return path;
}

@end
