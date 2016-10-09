//
//  PlaylistTableView.m
//  MusicTestDemo
//
//  Created by 孙建飞 on 16/4/8.
//  Copyright © 2016年 sjf. All rights reserved.
//

#import "PlaylistTableView.h"

@implementation PlaylistTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self=[super initWithFrame:frame style:style];
    if (self) {
        self.dataArr=[NSMutableArray new];
        
        self.delegate=self;
        self.dataSource=self;
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"a"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"a"];
        cell.backgroundColor=[UIColor clearColor];
        cell.contentView.backgroundColor=BACKGROUND_COLOR;
        cell.contentView.alpha=0.8;
        cell.textLabel.backgroundColor=[UIColor clearColor];
        cell.textLabel.font=[UIFont systemFontOfSize:16];
    }
    NSDictionary *dic=[self.dataArr objectAtIndex:indexPath.row];
   // NSDictionary *bitrate=[dic valueForKey:@"bitrate"];
    NSDictionary *songInfo=[dic valueForKey:@"songinfo"];
    NSString *author=[songInfo valueForKey:@"author"];
    NSString *title=[songInfo valueForKey:@"title"];
    cell.textLabel.text=[NSString stringWithFormat:@"%ld、%@--%@",(long)indexPath.row+1,author,title];
    return cell;
}
/*
获取图片路径
 */
//-(NSString *)getLocalFilePath:(PlaylistCellModel*)model{
//    
//    NSArray *arr=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *path=[arr objectAtIndex:0];
//    NSString *filepath=[path stringByAppendingPathComponent:model.coverSmall];
//    return filepath;
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   // NSLog(@"select:%ld",indexPath.row);
    NSIndexPath *sel=[NSIndexPath indexPathForRow:indexPath.row inSection:0];
    [tableView scrollToRowAtIndexPath:sel atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self.delegate_playlistTableView PlaySelectedMusic:(int)indexPath.row];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    header.backgroundColor=Gray_COLOR;
    header.alpha=0.8;
    header.layer.shadowColor=[UIColor whiteColor].CGColor;
    header.layer.shadowOffset=CGSizeMake(0, 1);
    header.layer.shadowRadius=1;
    header.layer.shadowOpacity=1;
    
    UILabel *playList=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    playList.text=@"播放列表";
    playList.textAlignment=1;
    playList.textColor=White_COLOR;
    [header addSubview:playList];
    
    UIButton *hide=[UIButton buttonWithType:UIButtonTypeCustom];
    [hide setTitle:@"关闭" forState:UIControlStateNormal];
    [hide setTitleColor:White_COLOR forState:UIControlStateNormal];
    [hide addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    hide.frame=CGRectMake(header.frame.size.width-50, 0, 50, 40);
    [header addSubview:hide];
    return header;
}
-(void)hide{
    [self.delegate_playlistTableView removePlaylistTable];
}
//设置滚动范围，超出contentSize时不可滚动；
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y<0) {
        //NSLog(@"offset=%f",scrollView.contentOffset.y);
        //滚动范围
        scrollView.contentOffset=CGPointMake(0, 0);
       // NSLog(@"contentsizeH=%f",scrollView.contentSize.height);
    }else if(scrollView.contentOffset.y>(scrollView.contentSize.height-scrollView.frame.size.height)){
        //
      //  NSLog(@"down");
       // NSLog(@"%f",scrollView.contentSize.height);
        
        //滚动范围；
            scrollView.contentOffset=CGPointMake(0,scrollView.contentSize.height-scrollView.frame.size.height);
    }
    
}

@end
