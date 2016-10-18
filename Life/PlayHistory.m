//
//  PlayHistory.m
//  Life
//
//  Created by 孙建飞 on 16/10/16.
//  Copyright © 2016年 sjf. All rights reserved.
//

#import "PlayHistory.h"

@interface PlayHistory ()

@end

@implementation PlayHistory
-(void)viewWillAppear:(BOOL)animated{
    
    NSLog(@"appear");
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden=YES;
    self.weather.hidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.weather.hidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title=@"播放记录";
//    // Do any additional setup after loading the view from its nib.
//    NSString *path=[self getLocalPlayHistoryPlistPath];
//    self.dataArr=[NSMutableArray arrayWithContentsOfFile:path];
//
    self.tableView.backgroundColor=BACKGROUND_COLOR;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor=BACKGROUND_COLOR;
    }
    NSString *txt;
    int index=(int)(self.dataArr.count-indexPath.row-1);
    if ([[self.dataArr[index] valueForKey:@"artistname"] length]>0) {
        txt=[NSString stringWithFormat:@"%ld、%@--%@",(long)indexPath.row+1,[self.dataArr[index] valueForKey:@"artistname"],[self.dataArr[index] valueForKey:@"songname"]];
    }else{
        txt=[NSString stringWithFormat:@"%ld、%@--%@",indexPath.row+1,[self.dataArr[index] valueForKey:@"author"],[self.dataArr[index] valueForKey:@"title"]];
        // [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[self.dataArr[indexPath.row] valueForKey:@"pic_small"]] placeholderImage:[UIImage imageNamed:@"tem.png"]];
    }
    UISwipeGestureRecognizer *leftSWipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(setEditing:)];
    [cell addGestureRecognizer:leftSWipe];
    cell.textLabel.text=txt;
    return cell;
}


-(void)setEditing:(BOOL)editing{
    [self.tableView setEditing:YES animated:YES];
}
/*
 编辑类型为删除;
 */
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
/*
 执行编辑操作;
 */
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        if ([self.type isEqual:@"history"]) {
            NSLog(@"%@",[self.dataArr class]);
            NSMutableArray *arr=[NSMutableArray arrayWithContentsOfFile:[self getLocalPlayHistoryPlistPath]];
            
            [arr removeObject:self.dataArr[self.dataArr.count-indexPath.row-1]];
            [arr writeToFile:[self getLocalPlayHistoryPlistPath] atomically:YES];
            self.dataArr=arr;
        }else{
            [JsonNetwork removeMp3With:self.dataArr[self.dataArr.count-indexPath.row-1]];
            NSString *path=[JsonNetwork getLocalDownloadHistoryPlistPath];
            NSMutableArray *arr=[NSMutableArray arrayWithContentsOfFile:path];
            self.dataArr =arr;
        }
        /*
         更新tableView;
         */
        [tableView beginUpdates];
        NSArray *indexPaths =[NSArray arrayWithObject:indexPath];
        // 删除
        [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        NSString *indexs=[NSString stringWithFormat:@"%ld",(long)self.dataArr.count-indexPath.row-1];
        NSString *title=self.title;
        NSDictionary *dic=[[NSDictionary alloc]init];
        dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:self.dataArr,@"array", indexs,@"index",title,@"title",self.tabBarController.selectedIndex,@"lastvc",nil];
        NSLog(@"播放....%@",title);
        self.play=[PlayView sharePlayView];
        self.play.delegate=self;
        [self show];
//        NSLog(@"跳转");
        [self.play performSelector:@selector(reload:) withObject:dic afterDelay:0.3];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
