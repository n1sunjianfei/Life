//
//  JokeVC.m
//  Life
//
//  Created by 孙建飞 on 16/9/21.
//  Copyright © 2016年 sjf. All rights reserved.
//

#import "JokeVC.h"

@interface JokeVC ()
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation JokeVC

-(NSArray*)titleItemArr{
    if (!_titleItemArr) {
        _titleItemArr=[NSArray arrayWithObjects:@"最新笑话",@"最新趣图",@"笑话集",@"笑话大全",@"快乐麻花",@"捧腹网",@"暴走漫画", nil];
    }
    return _titleItemArr;
}

-(NSArray*)urlArr{
    if (!_urlArr) {
        _urlArr=[NSArray arrayWithObjects:
                 @"http://japi.juhe.cn/joke/content/text.from?key=bd73c1d3cc5a2988cff4404d33ca6aeb&",
                 @"http://japi.juhe.cn/joke/img/text.from?key=bd73c1d3cc5a2988cff4404d33ca6aeb&",
                 @"http://www.jokeji.cn",
                 @"http://xiaohua.zol.com.cn",
                 @"http://www.mahua.com/",
                 @"http://www.pengfu.com",
                 @"http://baozoumanhua.com/", nil];
    }
    return _urlArr;
}

-(NSMutableArray*)gifDataArr{
    if (!_gifDataArr) {
        _gifDataArr=[[NSMutableArray alloc]init];
    }
    return _gifDataArr;
}
-(NSMutableArray*)dataSource{
    if (!_dataSource) {
        _dataSource=[[NSMutableArray alloc]init];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"看笑话";
    self.view.backgroundColor=BACKGROUND_COLOR;
    //
    self.currentSelectedTag=0;
    //
    RediousButtons *six=[[RediousButtons alloc]initWithFrame:CGRectMake(10, 40, SCREEN_WIDTH-20, 30) AndTitleItem:@[self.titleItemArr[0],self.titleItemArr[1]] andSubTitleItem:nil];
    [self.view addSubview:six];
    // NSLog(@"%@",self.buttonTitleArr);
    six.delegate=self;
    //
    self.mainTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.dataSource removeAllObjects];
        self.dataSource=nil;
        //NSLog(@"header数据数量：%ld",self.dataSource.count);
        self.pageNum=1;

        [self NetworkGetJokeJson:self.currentSelectedTag];
        
    }];
    //
    self.mainTableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageNum+=1;
        //NSLog(@"footer数据数量：%ld",self.dataSource.count);

        [self NetworkGetJokeJson:self.currentSelectedTag];
    }];
    //
    [self.mainTableView.mj_header beginRefreshing];
}
//
-(UIView*)addHeaderView{
    
    float midedge=25;
    float width=(SCREEN_WIDTH-midedge*6)/5;

    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, width+30)];
    headerView.backgroundColor=BACKGROUND_COLOR;
    
    for (int i=2; i<7; i++) {
        //
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag=i;
        [btn setTitle:[self.titleItemArr objectAtIndex:i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame=CGRectMake(midedge+(i-2)%5*(width+midedge),10+(i-2)/5*(80+10), width, width+20);
        [headerView addSubview:btn];
        //
        UIImageView *image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",self.titleItemArr[i]]]];
        image.frame=CGRectMake(midedge+(i-2)%5*(width+midedge),10+(i-2)/5*(80+10), width, width);
        image.layer.masksToBounds=YES;
        image.layer.cornerRadius=width/2;
        [headerView addSubview:image];
        //
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(-10+midedge+(i-2)%5*(width+midedge),width+10+(i-2)/5*(80+10), width+20, 20)];
        label.font=[UIFont systemFontOfSize:10];
        label.text=[self.titleItemArr objectAtIndex:i];
        label.textAlignment=1;
        [headerView addSubview:label];
        //
    }
    return headerView;
}
//文
/*http://japi.juhe.cn/joke/content/text.from?key=bd73c1d3cc5a2988cff4404d33ca6aeb&page=1&pagesize=10*/
//图
/*http://japi.juhe.cn/joke/img/text.from?key=bd73c1d3cc5a2988cff4404d33ca6aeb&page=1&pagesize=10*/

/*
 *mainTableView协议方法
 *
 */
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
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    float midedge=25;
    float width=(SCREEN_WIDTH-midedge*6)/5;

    return width+30;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self addHeaderView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    NSString *urlStr=[self.dataSource[indexPath.row] valueForKey:@"url"];
    //判断是否存在图片
    if (urlStr.length>0) {//存在图片计算图片尺寸
        NSData *data=self.gifDataArr[indexPath.row];
        CGSize size=[UIImage imageWithData:data].size;;
        //NSLog(@"第二个%f----",size.height);
        return size.height+10*3+15+20;
    }else{//不存在图片计算文字尺寸
        NSString *title=[self.dataSource[indexPath.row] valueForKey:@"content"];
        CGFloat height=[self calculateItemStringLength:title];
        //NSLog(@"height of cell----%f",height+40);
        return height+40;
    }
   

}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ide=@"cell";
    [self.loadingView stop];
    //文字内容
    NSString *title=[self.dataSource[indexPath.row] valueForKey:@"content"];
    CGFloat height=[self calculateItemStringLength:title];
    //图片内容
    NSString *urlStr=[self.dataSource[indexPath.row] valueForKey:@"url"];
    //有图片加载有图片的Cell
    if (urlStr.length>0) {
        //
        JokeCellSecond *cell=[tableView dequeueReusableCellWithIdentifier:ide];
        //图片尺寸
        NSData *data=self.gifDataArr[indexPath.row];
        CGSize size=[UIImage imageWithData:data].size;
        //
        if (cell==nil) {
            cell=[[JokeCellSecond alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ide andHeight:size.height+10*3+15+20];
        }
        //
        cell.titleLabel.text=title;
        //
       [cell.gifWeb loadData:self.gifDataArr[indexPath.row] MIMEType:@"image/gif" textEncodingName:@"" baseURL:[NSURL URLWithString:@""]];
        //cell中的WebView覆盖了Cell的选择方法，因此点击webview时无法实现cell选择下面的方法可以实现点击Webview实现cell的选择
        cell.gifWeb.tag=indexPath.row;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectCell:)];
        tap.delegate=self;
        tap.cancelsTouchesInView=NO;
        [cell.gifWeb addGestureRecognizer:tap];
        
        //
        cell.dateLabel.text=[self.dataSource[indexPath.row] valueForKey:@"updatetime"];
        return cell;
        
    }else{//没有图片加载没有图片的cell
        //
        JokeCellFirst *cell=[tableView dequeueReusableCellWithIdentifier:ide];
        
        //
        if (cell==nil) {
            cell=[[JokeCellFirst alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ide andHeight:height+40];
           // NSLog(@"cell new");
        }
        //
        cell.titleLabel.text=[self.dataSource[indexPath.row] valueForKey:@"content"];
        cell.dateLabel.text=[self.dataSource[indexPath.row] valueForKey:@"updatetime"];

        return cell;
    }
   
}

/*
 tap协议
 */
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

-(void)selectCell:(UITapGestureRecognizer*)tap{
    
    //NSLog(@"%@--index=%ld",tap.view.class,tap.view.tag);
    //
    [self addWebViewShowImage:(int)tap.view.tag];
}

//选择
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *urlStr=[self.dataSource[indexPath.row] valueForKey:@"url"];
    //有图片加载有图片的Cell
    if (urlStr.length>0) {
        [self addWebViewShowImage:(int)indexPath.row];
    }else{
        [self addTextView:(int)indexPath.row];
    }
}
#pragma mark-click SEG
-(void)clickButton:(UIButton *)sender{
    
    //搜索相关标题
    NSLog(@"标题:%@",[self.titleItemArr objectAtIndex:sender.tag]);
    if (sender.tag==0||sender.tag==1) {
        if (self.currentSelectedTag!=sender.tag) {
            self.pageNum=1;
          //
            [self.mainTableView.mj_header beginRefreshing];
            self.currentSelectedTag=(int)sender.tag;
        }
       
    }else{
        self.loadingView =[[ JF_LoadingView alloc]init];
        [self.view addSubview:self.loadingView];
        [self.loadingView begin];
        [self addWebView:(int)sender.tag];
    }
}

-(void)NetworkGetJokeJson:(int)index{
    //NSLog(@"network,pageNum=%d,selectedTag=%d",self.pageNum,index);
    //page=1&pagesize=10
    NSString *baseStr=self.urlArr[index];
    NSString *searchStr=[NSString stringWithFormat:@"page=%d&pagesize=10",self.pageNum];
    NSString *urlStr=[baseStr stringByAppendingString:searchStr];
    NSLog(@"网址：%@",urlStr);
    NSURL *url=[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    request.cachePolicy=NSURLRequestReloadIgnoringCacheData;
    request.timeoutInterval=20;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data) {
            NSDictionary *dataDic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *resultDic=[dataDic valueForKey:@"result"];
            
           // NSMutableArray *temp=[NSMutableArray addself.dataSource];
            [self.dataSource addObjectsFromArray:[resultDic valueForKey:@"data"]];
            
            //NSLog(@"数据的数量%ld",self.dataSource.count);


//           
            //加载新添加的图片资源
            for (int i=((self.pageNum-1)*10); i<self.dataSource.count; i++) {
                NSString *urlStr=[self.dataSource[i] valueForKey:@"url"];
                NSData *dataGif;
                if (urlStr.length>0) {
                    //本地
                    if ([NSData dataWithContentsOfFile:[self getLocalFilePath:urlStr]]) {
                        dataGif=[NSData dataWithContentsOfFile:[self getLocalFilePath:urlStr]];
                        //NSLog(@"本地--index=%d",i);
                    }else{//网络端请求
                        dataGif=[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
                        [dataGif writeToFile:[self getLocalFilePath:urlStr] atomically:YES];
                        //NSLog(@"网络--index=%d",i);
                    }
                    
                    [self.gifDataArr addObject:dataGif];
                    
                }
                
            }
            [self performSelectorOnMainThread:@selector(reloadUI) withObject:nil waitUntilDone:YES];
        }
    }];
}

-(void)reloadUI{
    [self.mainTableView.mj_header endRefreshing];
    [self.mainTableView.mj_footer endRefreshing];
    [self.mainTableView reloadData];
}
//添加WebView展示图片信息
-(void)addWebViewShowImage:(int)index{
    self.webContainer=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.webContainer.backgroundColor=BACKGROUND_COLOR;
    [self.view addSubview:self.webContainer];
    //
    [self.view bringSubviewToFront:self.loadingView];
    
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
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-40, 60)];
    label.font=[UIFont systemFontOfSize:20];
    label.textAlignment=1;
    label.numberOfLines=2;
    label.text=[self.dataSource[index] valueForKey:@"content"];
    [self.webContainer addSubview:label];
    //
    UIWebView *web=[[UIWebView alloc]initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, SCREEN_HEIGHT-70)];
    web.backgroundColor=BACKGROUND_COLOR;
    [web loadData:self.gifDataArr[index] MIMEType:@"image/gif" textEncodingName:@"" baseURL:[NSURL URLWithString:@""]];
    [self.webContainer addSubview:web];
    //
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"cha.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame=CGRectMake(10, 20, 30, 30);
    [self.webContainer addSubview:backBtn];
    
    self.tabBarController.tabBar.hidden=YES;
    [self.loadingView stop];
}
//添加WebView
-(void)addWebView:(int)index{
    self.webContainer=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.webContainer.backgroundColor=BACKGROUND_COLOR;
    [self.view addSubview:self.webContainer];
    //
    [self.view bringSubviewToFront:self.loadingView];

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
    web.backgroundColor=BACKGROUND_COLOR;
    NSString *urlStr=self.urlArr[index];
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
    [self.loadingView stop];
}
//删除webview，文本视图
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
//添加文本视图
-(void)addTextView:(int)index{
    self.webContainer=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.webContainer.backgroundColor=[UIColor grayColor];
    [self.view addSubview:self.webContainer];
    
    UITextView *textView=[[UITextView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    textView.text=[self.dataSource[index] valueForKey:@"content"];
    textView.font=[UIFont systemFontOfSize:20];
    textView.editable=NO;
    textView.backgroundColor=BACKGROUND_COLOR;
    [self.webContainer addSubview:textView];
    
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
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"cha.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame=CGRectMake(10, 20, 30, 30);
    [self.webContainer addSubview:backBtn];
    self.tabBarController.tabBar.hidden=YES;
}
/*
 计算item高度
 */
-(CGFloat)calculateItemStringLength:(NSString*)title{
    //
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading;
    //
    CGRect rect = [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT)options:options attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil];
     //NSLog(@"%f,%f",rect.size.width,rect.size.height);
    
    return  rect.size.height;
}
/*
获取文件路径
*/
-(NSString *)getLocalFilePath:(NSString*)urlStr{
    
    NSArray *arr=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path=[arr objectAtIndex:0];

    NSString *filepath=[NSString stringWithFormat:@"%@/%@",path,[self getFileName:urlStr]];
    //NSLog(@"%@",filepath);
    return filepath;
}
//去掉http前缀,获取存储文件的名称
-(NSString*)getFileName:(NSString*)urlStr{
    int length=(int)urlStr.length;
   // NSLog(@"length===%d",length);
    NSString *result=@"";
    for (int i=length-1; i>-1; i--) {
        if ([[urlStr substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"/"]) {
            NSString *tem=[urlStr substringWithRange:NSMakeRange(i+1, length-i-1)];
            result=tem;
           // NSLog(@"%d str=%@",i,tem);
            return result;
        }
    }
    return result;
}

@end
