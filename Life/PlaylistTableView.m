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
        self.backgroundColor=[UIColor grayColor];
        self.alpha=0.6;
    
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
    }
    NSDictionary *dic=[self.dataArr objectAtIndex:indexPath.row];
   // NSDictionary *bitrate=[dic valueForKey:@"bitrate"];
    NSDictionary *songInfo=[dic valueForKey:@"songinfo"];
    NSString *author=[songInfo valueForKey:@"author"];
    NSString *title=[songInfo valueForKey:@"title"];
    cell.textLabel.text=[NSString stringWithFormat:@"%@--%@",author,title];
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
    header.backgroundColor=[UIColor colorWithRed:0.24 green:0.22 blue:0.22 alpha:1];
    header.layer.shadowColor=[UIColor whiteColor].CGColor;
    header.layer.shadowOffset=CGSizeMake(0, 1);
    header.layer.shadowRadius=1;
    header.layer.shadowOpacity=1;
    
    UILabel *playList=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    playList.text=@"播放列表";
    [header addSubview:playList];
    return header;
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
        NSLog(@"%f",scrollView.contentSize.height);
        
        //滚动范围；
            scrollView.contentOffset=CGPointMake(0,scrollView.contentSize.height-scrollView.frame.size.height);
    }

}

@end
