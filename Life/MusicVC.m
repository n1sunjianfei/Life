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
    self.title=@"听音乐";
   // self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.jpg"]];
    self.view.backgroundColor=BACKGROUND_COLOR;
    [self addSinger];
    [self addSongsList];
    self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, 400);
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
/*http://tingapi.ting.baidu.com/v1/restserver/ting*/
//获取歌手的歌曲
- (IBAction)Player:(UIButton *)sender {
  //  NSString *searchStr=[@"薛之谦" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *baseStr=[NSString stringWithFormat:@"http://tingapi.ting.baidu.com/v1/restserver/ting?format=json&calback=&from=webapp_music&method=baidu.ting.artist.getSongList&tinguid=%@&limits=20&use_cluster=1&order=2",self.singgerIDArr[sender.tag]];
    NSString *urlStr=[baseStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //method=baidu.ting.billboard.billList&type=1&size=10&offset=0
    NSLog(@"%@",urlStr);
    
    NSURL *url=[NSURL URLWithString:urlStr];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new ] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
      //  NSDictionary *datadic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (data) {
            NSDictionary *dic=  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         //   NSDictionary *songDic=[dic valueForKey:@"song"];
           // NSLog(@"%@",songDic);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.playlistVC=[[PlaylistVC alloc]init];
                self.playlistVC.dic=dic;
                self.playlistVC.title=sender.titleLabel.text;
             //   [self.playlistVC loadSongInfo];
                [self.navigationController pushViewController:self.playlistVC animated:YES];
            });
        }
        if (connectionError) {
            NSLog(@"%@",connectionError);
        }
    }];
}
//获取榜单歌曲
-(void)getList:(UIButton*)sender{
    NSString *baseStr=[NSString stringWithFormat:@"http://tingapi.ting.baidu.com/v1/restserver/ting?format=json&calback=&from=webapp_music&method=baidu.ting.billboard.billList&type=%@&size=20&offset=0",[self.songListArr[sender.tag] valueForKey:@"value"]];
    NSString *urlStr=[baseStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //method=baidu.ting.billboard.billList&type=1&size=10&offset=0
    NSLog(@"%@",urlStr);
    
    NSURL *url=[NSURL URLWithString:urlStr];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new ] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        //  NSDictionary *datadic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (data) {
            NSDictionary *dic=  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
           // NSDictionary *songList=[dic valueForKey:@"song_list"];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.playlistVC=[[PlaylistVC alloc]init];
                self.playlistVC.dic=dic;
                self.playlistVC.title=sender.titleLabel.text;
             //   [self.playlistVC loadSongInfo];
                [self.navigationController pushViewController:self.playlistVC animated:YES];
            });
          //  NSDictionary *songDic=[dic valueForKey:@"song"];
           //  NSLog(@"%@",dic);
        }
        if (connectionError) {
            NSLog(@"%@",connectionError);
        }
    }];
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
    
    NSString *baseStr=[NSString stringWithFormat:@"http://tingapi.ting.baidu.com/v1/restserver/ting?format=json&calback=&from=webapp_music&method=baidu.ting.search.catalogSug&query=%@",searchBar.text];
    NSString *urlStr=[baseStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //method=baidu.ting.billboard.billList&type=1&size=10&offset=0
    NSLog(@"%@",urlStr);
    
    NSURL *url=[NSURL URLWithString:urlStr];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new ] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data) {
            NSDictionary *dic=  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
          //  NSDictionary *songDic=[dic valueForKey:@"song"];
           //  NSLog(@"搜索的歌曲信息。。。。%@",dic);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.playlistVC=[[PlaylistVC alloc]init];
                self.playlistVC.dic=dic;
                self.playlistVC.title=searchBar.text;
                searchBar.text=nil;
             //   [self.playlistVC loadSongInfo];
                [self.navigationController pushViewController:self.playlistVC animated:YES];
            });
        }
        if (connectionError) {
            NSLog(@"%@",connectionError);
        }
    }];
    
}

-(void)push{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
