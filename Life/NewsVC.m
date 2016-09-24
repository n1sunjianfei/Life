//
//  NewsVC.m
//  Life
//
//  Created by 孙建飞 on 16/9/21.
//  Copyright © 2016年 sjf. All rights reserved.
//

#import "NewsVC.h"

@interface NewsVC ()

@end

@implementation NewsVC
/*类型,,top(头条，默认),shehui(社会),guonei(国内),guoji(国际),yule(娱乐),tiyu(体育)junshi(军事),keji(科技),caijing(财经),shishang(时尚)*/
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"看新闻";
    //
    self.urlFirst=@"http://v.juhe.cn/toutiao/index?";
    //
    [self loadSeg];
    //
    [self clickButton:nil];
    //
    self.view.backgroundColor=BACKGROUND_COLOR;

    
}

-(void)loadSeg{
    //
    self.buttonTitleArr=[NSArray arrayWithObjects:@"头条",@"社会",@"国内",@"国际",@"娱乐", @"体育",@"军事",@"科技",@"财经",@"时尚",nil];
    //
    self.typeArr=[NSArray arrayWithObjects:@"top",@"shehui",@"guonei",@"guoji",@"yule", @"tiyu",@"junshi",@"keji",@"caijing",@"shishang",nil];
    //
    SixButton *six=[[SixButton alloc]initWithFrame:CGRectMake(10, 40, SCREEN_WIDTH-20, 30) AndTitleItem:self.buttonTitleArr andSubTitleItem:nil];
    [self.view addSubview:six];
    // NSLog(@"%@",self.buttonTitleArr);
    six.delegate=self;

}

#pragma mark-click SEG
-(void)clickButton:(UIButton *)sender{
    //搜索相关标题
    NSLog(@"新闻分类标题%@",[self.buttonTitleArr objectAtIndex:sender.tag]);
    NSString *second=[NSString stringWithFormat:@"type=%@&key=b991d0c58b3b82f193c7d7bf07ed2dfd",self.typeArr[sender.tag]];
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",self.urlFirst,second];
    NSLog(@"新闻网站：%@",urlStr);
    NSURL *url=[NSURL URLWithString:urlStr];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
       // NSLog(@"%@",data);
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *result=[dic valueForKey:@"result"];
        self.dataSource=[result valueForKey:@"data"];
        [self.mainTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataSource) {
        return self.dataSource.count;
    }else{
        return 0;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *newDic=self.dataSource[indexPath.row];
//    NSString *image1=[newDic valueForKey:@"thumbnail_pic_s"];
    NSString *image2=[newDic valueForKey:@"thumbnail_pic_s02"];
//    NSString *image3=[newDic valueForKey:@"thumbnail_pic_s03"];
    //    int type=1;
    if(image2.length!=0){
    return 150;
    }else{
        return 100;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ide=@"cell";
    NSDictionary *newDic=self.dataSource[indexPath.row];
    NSString *image1=[newDic valueForKey:@"thumbnail_pic_s"];
    NSString *image2=[newDic valueForKey:@"thumbnail_pic_s02"];
    NSString *image3=[newDic valueForKey:@"thumbnail_pic_s03"];
//    int type=1;
    if(image2.length!=0){
        NewsCellSecond *cell=[tableView dequeueReusableCellWithIdentifier:ide];
        if (cell==nil) {
            cell=[[NewsCellSecond alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ide];
        }
        cell.titleLabel.text=[newDic valueForKey:@"title"];
        cell.dateLabel.text=[newDic valueForKey:@"date"];
        cell.authorLabel.text=[newDic valueForKey:@"author_name"];
        //cell.imageView1=[newDic valueForKey:@""];
        [cell.imageView1 sd_setImageWithURL:[NSURL URLWithString:image1] placeholderImage:[UIImage imageNamed:@""]];
        [cell.imageView2 sd_setImageWithURL:[NSURL URLWithString:image2] placeholderImage:[UIImage imageNamed:@""]];
        [cell.imageView3 sd_setImageWithURL:[NSURL URLWithString:image3] placeholderImage:[UIImage imageNamed:@""]];
        return cell;

    }else{
        NewsCellFirst *cell=[tableView dequeueReusableCellWithIdentifier:ide];
        if (cell==nil) {
            cell=[[NewsCellFirst alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ide];
        }
        cell.titleLabel.text=[newDic valueForKey:@"title"];
        cell.dateLabel.text=[newDic valueForKey:@"date"];
        cell.authorLabel.text=[newDic valueForKey:@"author_name"];
        //cell.imageView1=[newDic valueForKey:@""];
        [cell.imageView1 sd_setImageWithURL:[NSURL URLWithString:image1] placeholderImage:[UIImage imageNamed:@""]];
        return cell;
    }
}
//选择
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self addWebView:(int)indexPath.row];
   }
-(void)addWebView:(int)index{
    self.webContainer=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.webContainer.backgroundColor=[UIColor grayColor];
    [self.view addSubview:self.webContainer];
    //
    UISwipeGestureRecognizer *right=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(clear)];
    right.direction=UISwipeGestureRecognizerDirectionRight;
    [self.webContainer addGestureRecognizer:right];
    //动画效果
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.3;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromRight;
    [self.view.layer addAnimation:animation forKey:@"animation"];
    //
    UIWebView *web=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-30)];
    NSString *urlStr=[self.dataSource[index] valueForKey:@"url"];
    NSURL *url=[NSURL URLWithString:urlStr];
    [web loadRequest:[NSURLRequest requestWithURL:url]];
    [self.webContainer addSubview:web];
    //
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"cha.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame=CGRectMake(10, 20, 30, 30);
    [self.webContainer addSubview:backBtn];

    self.tabBarController.tabBar.hidden=YES;
}
//删除webview
-(void)clear{
   // [sender.superview removeFromSuperview];
    [self.webContainer removeFromSuperview];
    //动画效果
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.3;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromLeft;
    [self.view.layer addAnimation:animation forKey:@"animation"];
    self.tabBarController.tabBar.hidden=NO;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
