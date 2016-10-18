//
//  PlaylistVC.m
//  Life
//
//  Created by 孙建飞 on 16/9/22.
//  Copyright © 2016年 sjf. All rights reserved.
//

#import "PlaylistVC.h"

@interface PlaylistVC ()

@end

@implementation PlaylistVC

#pragma arguments--懒加载数组初始化
-(NSMutableArray*)songinfoArr{
    if (!_songinfoArr) {
        _songinfoArr=[[NSMutableArray alloc]init];
      //  NSLog(@"%ld",_songinfoArr.count);
    }
    return _songinfoArr;
}
-(NSMutableDictionary*)dicTransport{
    if (!_dicTransport) {
        _dicTransport=[[NSMutableDictionary alloc]init];
    }
    return _dicTransport;
}
-(NSMutableArray*)dataSource{
    if (!_dataSource) {
        _dataSource=[[NSMutableArray alloc]init];
    }
    return _dataSource;
}
-(void)addDataSources{
    
    
    //datasource添加数据
    if (self.type.length==0&&self.singerId.length==0) {//查询歌曲
        self.isSongId=YES;
        if (!([[self.dic valueForKey:@"song"] class]==[NSNull class])) {
            [self.dataSource addObjectsFromArray:[self.dic valueForKey:@"song"]];
            
        }else{
            NSLog(@"没有更多数据了");
            [self.mainTableView.mj_footer endRefreshing];
            [self.loading stop];
            [self.mainTableView reloadData];
            return;
        }
        NSLog(@"datasouce count1==%lu",(unsigned long)self.dataSource.count);
        
    }
    if(self.type.length>0){//排行榜歌曲
        self.isSongId=NO;
        
        if (!([[self.dic valueForKey:@"song_list"] class]==[NSNull class])) {
            [self.dataSource addObjectsFromArray:[self.dic valueForKey:@"song_list"]];
            
        }else{
            NSLog(@"没有更多数据了");
            [self.mainTableView.mj_footer endRefreshing];
            [self.loading stop];
            [self.mainTableView reloadData];
            return;
        }
        NSLog(@"datasouce count 2==%lu",(unsigned long)self.dataSource.count);
        
    }
    if (self.singerId.length>0) {//歌手歌曲
        self.isSongId=NO;
        if (!([[self.dic valueForKey:@"songlist"] class]==[NSNull class])) {
            [self.dataSource addObjectsFromArray:[self.dic valueForKey:@"songlist"]];
            
        }else{
            NSLog(@"没有更多数据了");
            [self.mainTableView.mj_footer endRefreshing];
            [self.loading stop];
            [self.mainTableView reloadData];
            return;
        }
        NSLog(@"datasouce count 3==%lu",(unsigned long)self.dataSource.count);
        
    }
    [self.mainTableView.mj_footer endRefreshing];
    [self.loading stop];
    [self.mainTableView reloadData];
    
}

-(void)viewWillAppear:(BOOL)animated{

    NSLog(@"appear");
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden=YES;
    self.weather.hidden=YES;
    [self netWorkWithUrl:[self createUrlstring] andTitle:self.title];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.weather.hidden=NO;
}
- (void)viewDidLoad {
    NSLog(@"didload");
    [super viewDidLoad];
    //
    if (!(self.type.length==0&&self.singerId==0)) {
        self.mainTableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                self.offset+=20;
                //NSLog(@"footer数据数量：%ld",self.dataSource.count);
                [self netWorkWithUrl:[self createUrlstring] andTitle:nil];
        }];
    }
    self.mainTableView.backgroundColor=BACKGROUND_COLOR;
  //  self.playViewController=[[PlayViewController alloc]init];
}
-(NSString*)createUrlstring{
    
    NSString *baseStr;
    NSString *urlStr;
    ///歌手
    if (self.singerId.length>0) {
      baseStr=[NSString stringWithFormat:@"http://tingapi.ting.baidu.com/v1/restserver/ting?format=json&calback=&from=webapp_music&method=baidu.ting.artist.getSongList&tinguid=%@&limits=20&use_cluster=1&order=2&offset=%d",self.singerId,self.offset];
    }
    //榜单
    if (self.type.length>0) {
        baseStr=[NSString stringWithFormat:@"http://tingapi.ting.baidu.com/v1/restserver/ting?format=json&calback=&from=webapp_music&method=baidu.ting.billboard.billList&type=%@&size=20&offset=%d",self.type,self.offset];
       
    }
    //搜索
    if (self.type.length==0&&self.singerId.length==0) {
        baseStr=[NSString stringWithFormat:@"http://tingapi.ting.baidu.com/v1/restserver/ting?format=json&calback=&from=webapp_music&method=baidu.ting.search.catalogSug&query=%@",self.title];
    }
//    urlStr=[baseStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   // NSLog(@"生成的urlStr是：%@",urlStr);
    urlStr=[JsonNetwork encodeUrlStrWithString:baseStr];
    return urlStr;
}
///////
-(void)netWorkWithUrl:(NSString*)urlStr andTitle:(NSString*)title{

    [self.loading begin];

    [JsonNetwork loadPlaylistWithUrlstr:urlStr block:^(NSDictionary *dic) {
        if (dic) {
            self.dic=dic;
            [self performSelectorOnMainThread:@selector(addDataSources) withObject:nil waitUntilDone:YES];
        }else{
            [self.loading stop];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   // NSLog(@"ce");
    static NSString *ide=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ide];
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ide];
    }
//    NSDictionary *dic=self.songinfoArr[indexPath.row];
//    NSDictionary *info=[dic valueForKey:@"songinfo"];
    NSString *txt;
    if (self.type.length==0&&self.singerId.length==0) {
        txt=[NSString stringWithFormat:@"%@--%@",[self.dataSource[indexPath.row] valueForKey:@"artistname"],[self.dataSource[indexPath.row] valueForKey:@"songname"]];
    }else{
        txt=[NSString stringWithFormat:@"%@--%@",[self.dataSource[indexPath.row] valueForKey:@"author"],[self.dataSource[indexPath.row] valueForKey:@"title"]];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[self.dataSource[indexPath.row] valueForKey:@"pic_small"]] placeholderImage:[UIImage imageNamed:@"tem.png"]];
    }
    cell.textLabel.text=txt;

    cell.textLabel.textColor=Black_COLOR;
//    UIImageView *imageView=[[UIImageView alloc]init];
//    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[info valueForKey:@"pic_small"]] placeholderImage:[UIImage imageNamed:@"tem.png"]];

//    [imageView sd_setImageWithURL:[NSURL URLWithString:[info valueForKey:@"pic_small"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        UIImage *icon =imageView.image;
//        CGSize itemSize = CGSizeMake(65, 65);
//        UIGraphicsBeginImageContextWithOptions(itemSize, NO ,0.0);
//        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
//        [icon drawInRect:imageRect];
//        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//
//    }];

    cell.backgroundColor=BACKGROUND_COLOR;
   ;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *index=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    NSString *title=self.title;
    self.dicTransport=[NSMutableDictionary dictionaryWithObjectsAndKeys:self.dataSource,@"array", index,@"index",title,@"title",self.tabBarController.selectedIndex,@"lastvc",nil];
    NSLog(@"播放....%@",title);
   // [[NSNotificationCenter defaultCenter]postNotificationName:@"jumpToPlayVC" object:nil userInfo:self.dicTransport];
  //  self.tabBarController.selectedIndex=2;
//    PlayView *play=[PlayView sharePlayView];
//    play.delegate=self;
//    [self.view addSubview:play];
    self.play.delegate=self;
    [self show];
    NSLog(@"跳转");
    [self.play performSelector:@selector(reload:) withObject:self.dicTransport afterDelay:0.3];
}
-(void)removeFromSuperView{
    self.play=[PlayView sharePlayView];
    [self.play removeFromSuperview];
    self.isPlayViewShow=NO;
    self.tabBarController.tabBar.hidden=YES;
    self.navigationItem.rightBarButtonItem.title=@"显示";
    [self animateOut];
}
@end
