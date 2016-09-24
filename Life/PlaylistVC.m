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
-(NSMutableArray*)songinfoArr{
    if (!_songinfoArr) {
        _songinfoArr=[NSMutableArray arrayWithArray:self.dataSource];
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


-(void)loadSongInfo{
    
    self.dataSource=[self.dic valueForKey:@"song"];
    if (self.dataSource!=NULL) {
         NSLog(@"%lu",(unsigned long)self.dataSource.count);
    }else{
        self.dataSource=
        [self.dic valueForKey:@"song_list"];
        if (self.dataSource==NULL) {
            self.dataSource= [self.dic valueForKey:@"songlist"];
        }
    }
    //没加载songinfo调用时
//    if (self.songinfoArr!=self.dataSource) {
//        
//        return;
//    }
    for (int i=0; i<self.dataSource.count; i++) {
        NSString *baseStr;
        if ([self.dataSource[i] valueForKey:@"song_id"]) {
            baseStr=[NSString stringWithFormat:@"http://tingapi.ting.baidu.com/v1/restserver/ting?format=json&calback=&from=webapp_music&method=baidu.ting.song.play&songid=%@",[self.dataSource[i] valueForKey:@"song_id"] ];
        }else{
            baseStr=[NSString stringWithFormat:@"http://tingapi.ting.baidu.com/v1/restserver/ting?format=json&calback=&from=webapp_music&method=baidu.ting.song.play&songid=%@",[self.dataSource[i] valueForKey:@"songid"] ];
        }
        
        NSString *urlStr=[baseStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    //   [self.songinfoArr removeAllObjects];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            if (data) {
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
             //   NSDictionary *songInfo=[dic valueForKey:@"songinfo"];
               // [self.songinfoArr insertObject:songInfo atIndex:i];
            //    [self.songinfoArr addObject:songInfo];
               // NSLog(@"%@",dic);
            //    NSLog(@"%lu",(unsigned long)self.songinfoArr.count);
                [self.songinfoArr replaceObjectAtIndex:i withObject:dic];
                [self.mainTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
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
    [self loadSongInfo];
    // Do any additional setup after loading the view from its nib.
    self.playViewController=[[PlayViewController alloc]init];
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
//    if (self.dataSource==[self.dic valueForKey:@"song"]) {
//        cell.textLabel.text=[NSString stringWithFormat:@"%@--%@",[self.dataSource[indexPath.row] valueForKey:@"artistname"],[self.dataSource[indexPath.row] valueForKey:@"songname"]];
//        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[[[self.dic valueForKey:@"album"] firstObject] valueForKey:@"artistpic"]] placeholderImage:[UIImage imageNamed:@"small.jpg"]];
//    }else{
    
    NSDictionary *dic=self.songinfoArr[indexPath.row];
    NSDictionary *info=[dic valueForKey:@"songinfo"];
        cell.textLabel.text=[NSString stringWithFormat:@"%@--%@",[info valueForKey:@"author"],[info valueForKey:@"title"]];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[info valueForKey:@"pic_small"]] placeholderImage:[UIImage imageNamed:@"0.jpg"]];
//    }
    
    //cell.imageView.image=[UIImage imageNamed:@"1.jpg"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    self.playViewController.currentNum=(int)indexPath.row;
//    self.playViewController.array=self.songinfoArr;
//    [self.navigationController pushViewController:self.playViewController animated:YES];
    
   // self.dicTransport=[NSMutableDictionary dictionaryWithObjectsAndKeys:self.songinfoArr,@"array",index,@"index",nil];
    NSString *index=[NSString stringWithFormat:@"%ld",(long)indexPath.row];


    NSString *title=self.title;
    self.dicTransport=[NSMutableDictionary dictionaryWithObjectsAndKeys:self.songinfoArr,@"array", index,@"index",title,@"title",self.tabBarController.selectedIndex,@"lastvc",nil];
    NSLog(@"跳转%@",title);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"jumpToPlayVC" object:nil userInfo:self.dicTransport];
    self.tabBarController.selectedIndex=2;
}

@end
