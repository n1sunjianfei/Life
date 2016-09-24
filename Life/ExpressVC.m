//
//  ExpressVC.m
//  Life
//
//  Created by 孙建飞 on 16/9/21.
//  Copyright © 2016年 sjf. All rights reserved.
//

#import "ExpressVC.h"

@interface ExpressVC ()

@end

@implementation ExpressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"查快递";
    self.view.backgroundColor=BACKGROUND_COLOR;

    // Do any additional setup after loading the view from its nib.
}
//http://q.kdpt.net/api?id=[]&com=[]&nu=[]&show=json&order=desc
//http://q.kdpt.net/api?id=testkey&com=auto&nu=[]&show=[]&order=[]&format=[]

//3313338527494

/*
 
 返回状态state说明：
 0：在途，即货物处于运输过程中；
 1：揽件，货物已由快递公司揽收并且产生了第一条跟踪信息；
 2：疑难，货物寄送过程出了问题；
 3：签收，收件人已签收；
 4：退签或异常签收，即货物由于用户拒签、超区等原因退回，而且发件人已经签收；
 5：派件，即快递正在进行同城派件；
 6：退回，货物正处于退回发件人的途中；
 返回status说明：
 0:无记录；
 1:查询成功.
 */
- (IBAction)search:(UIButton*)sender {
    [self.deliveryTextfield resignFirstResponder];
    NSString *urlStrl=[NSString stringWithFormat:@"http://q.kdpt.net/api?id=testkey&com=auto&nu=%@&show=json&order=desc",self.deliveryTextfield.text];
    NSURL *url=[NSURL URLWithString:urlStrl];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addTextView:dic];
            
        });
    }];
}
//删除webview，文本视图
-(void)clear{
    // [sender.superview removeFromSuperview];
    [self.container removeFromSuperview];
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
-(void)addTextView:(NSDictionary*)dic{
    //
    int state=[[dic valueForKey:@"state"] intValue];
    NSString *status=[dic valueForKey:@"status"];
    NSArray *dataArr=[dic valueForKey:@"data"];
    CGFloat height = 0.0;
    CGFloat totalHeight=70;
    NSString *stateTxt=[@"订单状态：" stringByAppendingString:[self getStateText:status andStatus:state]];
    //
    self.container=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT-50)];
    self.container.backgroundColor=BACKGROUND_COLOR;
    //
    UILabel *stateLabel=[[UILabel alloc]initWithFrame:CGRectMake(40, 10, SCREEN_WIDTH-80, 50)];
    stateLabel.text=stateTxt;
    stateLabel.numberOfLines=4;
    
    stateLabel.backgroundColor=[UIColor whiteColor];
    [self.container addSubview:stateLabel];
    
    //
    [self.view addSubview:self.container];
    
    for (int i=0; i<dataArr.count; i++) {
        UIImageView *circl=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        if (i==0) {
            circl.image=[UIImage imageNamed:@"circle.png"];
            circl.frame=CGRectMake(0, 0, 20, 20);
        }else{
        circl.image=[UIImage imageNamed:@"circleg.png"];
        }
        circl.center=CGPointMake(30, totalHeight+10);
        [self.container addSubview:circl];
        NSString *text=[NSString stringWithFormat:@"%@\n%@",[dataArr[i] valueForKey:@"time"],[dataArr[i] valueForKey:@"context"]];
        height=[self calculateItemStringLength:text];

        UILabel *temL=[[UILabel alloc]initWithFrame:CGRectMake(75, totalHeight, SCREEN_WIDTH-150, height)];
        if (i==0) {
            temL.textColor=[UIColor blueColor];
        }
        temL.text=text;
        temL.numberOfLines=4;
        temL.font=[UIFont systemFontOfSize:17];
   //     temL.backgroundColor=BACKGROUND_COLOR;
        temL.layer.masksToBounds=YES;
        temL.layer.cornerRadius=5;
        [self.container addSubview:temL];
        totalHeight=totalHeight+height+5;
       // NSLog(@"%f,height=%f",totalHeight,height);
    }
    self.container.contentSize=CGSizeMake(0, totalHeight+64);
    //
    UISwipeGestureRecognizer *right=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(clear)];
    right.direction=UISwipeGestureRecognizerDirectionRight;
    [self.container addGestureRecognizer:right];
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
    [self.container addSubview:backBtn];
    self.tabBarController.tabBar.hidden=YES;
    
    //
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(30, 70, 2, totalHeight-height-70)];
    lineView.backgroundColor=[UIColor lightGrayColor];
    [self.container addSubview:lineView];
    [self.container sendSubviewToBack:lineView];
}
/*
 计算item高度
 */
-(CGFloat)calculateItemStringLength:(NSString*)title{
    //
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading;
    //
    CGRect rect = [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-150, MAXFLOAT)options:options attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    //NSLog(@"%f,%f",rect.size.width,rect.size.height);
    
    return  rect.size.height;
}
-(NSString*)getStateText:(NSString*)status andStatus:(int)state{
    NSString *statetext;

    if ([status isEqual:@"1"]) {
        switch (state) {
            case 0:
                statetext=@"在途，即货物处于运输过程中";
                break;
            case 1:
                statetext=@"揽件，货物已由快递公司揽收并且产生了第一条跟踪信息";
                break;
            case 2:
                statetext=@"疑难，货物寄送过程出了问题";
                break;
            case 3:
                statetext=@"签收，收件人已签收";
                break;
            case 4:
                statetext=@"退签或异常签收，即货物由于用户拒签、超区等原因退回，而且发件人已经签收";
                break;
            case 5:
                statetext=@"派件，即快递正在进行同城派件";
                break;
            case 6:
                statetext=@"退回，货物正处于退回发件人的途中";
                break;
            default:
                break;
        }
    }
    return statetext;
}
/*
*/


@end
