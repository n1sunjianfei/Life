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
/*
 获取歌曲列表信息
 */
-(void)loadSongInfo{
    //datasource添加数据
    if (self.type.length==0&&self.singerId.length==0) {//查询歌曲
        self.isSongId=YES;
        if (!([[self.dic valueForKey:@"song"] class]==[NSNull class])) {
            [self.dataSource addObjectsFromArray:[self.dic valueForKey:@"song"]];
            
        }else{
            NSLog(@"没有更多数据了");
            [self.mainTableView.mj_footer endRefreshing];
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
            return;
        }
        NSLog(@"datasouce count 3==%lu",(unsigned long)self.dataSource.count);

    }
    

    //获取歌曲info信息并添加到songinfo数组中
    for (int i=self.offset; i<self.dataSource.count; i++) {
        NSString *baseStr;
        if (self.isSongId) {//
            baseStr=[NSString stringWithFormat:@"http://tingapi.ting.baidu.com/v1/restserver/ting?format=json&calback=&from=webapp_music&method=baidu.ting.song.play&songid=%@",[self.dataSource[i] valueForKey:@"songid"] ];
            //NSLog(@"songid");
        }else{//
            //NSLog(@"song_id");
            baseStr=[NSString stringWithFormat:@"http://tingapi.ting.baidu.com/v1/restserver/ting?format=json&calback=&from=webapp_music&method=baidu.ting.song.play&songid=%@",[self.dataSource[i] valueForKey:@"song_id"] ];
        }
        
        NSString *urlStr=[baseStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            if (data) {
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

                [self.songinfoArr addObject:dic];
                [self.mainTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mainTableView.mj_footer endRefreshing];
                });
            }
        }
         ];
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden=YES;
    
}

- (void)viewDidLoad {
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
    [self netWorkWithUrl:[self createUrlstring] andTitle:self.title];

    self.playViewController=[[PlayViewController alloc]init];
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
    urlStr=[baseStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"生成的urlStr是：%@",urlStr);
    
    return urlStr;
}
///////
-(void)netWorkWithUrl:(NSString*)urlStr andTitle:(NSString*)title{
    NSURL *url=[NSURL URLWithString:urlStr];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new ] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data) {
            self.dic=  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            [self performSelectorOnMainThread:@selector(loadSongInfo) withObject:nil waitUntilDone:YES];
        }
        if (connectionError) {
            NSLog(@"%@",connectionError);
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
    return self.songinfoArr.count;
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
    NSDictionary *dic=self.songinfoArr[indexPath.row];
    NSDictionary *info=[dic valueForKey:@"songinfo"];
        cell.textLabel.text=[NSString stringWithFormat:@"%@--%@",[info valueForKey:@"author"],[info valueForKey:@"title"]];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[info valueForKey:@"pic_small"]] placeholderImage:[UIImage imageNamed:@"0.jpg"]];
//    }
    cell.backgroundColor=BACKGROUND_COLOR;
    //cell.imageView.image=[UIImage imageNamed:@"1.jpg"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *index=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    NSString *title=self.title;
    self.dicTransport=[NSMutableDictionary dictionaryWithObjectsAndKeys:self.songinfoArr,@"array", index,@"index",title,@"title",self.tabBarController.selectedIndex,@"lastvc",nil];
    NSLog(@"跳转%@",title);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"jumpToPlayVC" object:nil userInfo:self.dicTransport];
    self.tabBarController.selectedIndex=2;
}

@end
