//
//  SixButton.m
//  zzProject
//
//  Created by 孙建飞 on 16/5/12.
//  Copyright © 2016年 YunFeng. All rights reserved.
//

#import "RediousButtons.h"

@implementation RediousButtons

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame AndTitleItem:(NSArray *)titleItem andSubTitleItem:(NSArray *)subTitleItem{
    
    self=[super initWithFrame:frame];
    
    if (self) {
        //self.backgroundColor=[UIColor grayColor];
        //
        _titleItem=titleItem;
        self.scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
       
        //calculate the length of ench item
        for (int i=0;i<_titleItem.count;i++) {
            
            [self calculateItemStringLength:[_titleItem objectAtIndex:i]];
           // NSLog(@"%@",[[_titleItem objectAtIndex:i] valueForKey:@"name"]);
            
        }

        //
        //_midEdage=15;
        //    //因为只有两个，所以使用以下方法
        self.midEdage=(frame.size.width-self.totalLength)/(self.titleItem.count+1);
        self.scrollView.contentSize=CGSizeMake(self.totalLength+15*(self.titleItem.count+1), 0);
        [self addSubview:self.scrollView];
       // self.scrollView.backgroundColor=[UIColor yellowColor];
        //
        [self create];

    }
    return self;
}
-(void)create{
    
    for (int i=0; i<_titleItem.count; i++) {
        [self.scrollView addSubview: [self createButtonWith:i]];
       // [self createSeperatorView:i];
    }
    
    _movingView=[[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-2, [[_tempLengthArr objectAtIndex:0] floatValue], 2)];
    
    _movingView.backgroundColor=[UIColor blueColor];
    _movingView.hidden=YES;
    [self.scrollView addSubview:_movingView];
}
/*
 
 */
-(UIButton*)createButtonWith:(int)i{
   // NSLog(@"a");
    static float x=0;
    
    for (int j=0; j<i; j++) {
        x+=[[_tempLengthArr objectAtIndex:j] floatValue];
    }
    
    x=x+(i+1)*_midEdage;
    
    // NSLog(@"x=%f",x);
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(x, 0, [[_tempLengthArr objectAtIndex:i] floatValue]+10, self.frame.size.height-5);
    btn.tag=i;
    btn.titleLabel.font=[UIFont systemFontOfSize:19];
    [btn addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:[_titleItem objectAtIndex:i] forState:UIControlStateNormal];
    btn.layer.masksToBounds=YES;
    //btn.backgroundColor=[UIColor grayColor];
    if (i==0) {
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor=[UIColor grayColor];
        btn.layer.cornerRadius=10;
        self.preSender=btn;
    }else{
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
 //   [self.scrollView addSubview:btn];
    x=0;
    return btn;
}
/*
 action
 */
-(void)valueChange:(UIButton*)sender{
    if (self.preSender) {
        [self.preSender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.preSender.backgroundColor=[UIColor clearColor];
        self.preSender.layer.cornerRadius=0;
        
    }
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sender.backgroundColor=[UIColor grayColor];
    sender.layer.cornerRadius=10;
    self.preSender=sender;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        _movingView.frame =  CGRectMake(sender.frame.origin.x, self.frame.size.height-2, sender.frame.size.width, 2);
    }];
    //此处添加点击操作
    //self.superview.backgroundColor=[UIColor redColor];
    [self.delegate clickButton:sender];
}


/*
计算item长度
*/
-(void)calculateItemStringLength:(NSString*)title{
//
NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading;
//
CGRect rect = [title boundingRectWithSize:CGSizeMake(1000, MAXFLOAT)options:options attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19]} context:nil];
// NSLog(@"%f,%f",rect.size.width,rect.size.height);

if (!_tempLengthArr) {
_tempLengthArr=[[NSMutableArray alloc]init];
    
}
    
[_tempLengthArr addObject:[NSString stringWithFormat:@"%f",rect.size.width]];
   // NSLog(@"%f",rect.size.width);
if (_tempLengthArr.count==_titleItem.count) {
//static  float total=0;
for ( int i=0 ; i<_tempLengthArr.count; i++) {

float f=[[_tempLengthArr objectAtIndex:i] floatValue];
   
    _totalLength+=f;
    
}
    
}
    
}
@end
