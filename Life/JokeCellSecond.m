//
//  NewsCellSecond.m
//  Life
//
//  Created by 孙建飞 on 16/9/23.
//  Copyright © 2016年 sjf. All rights reserved.
//

#import "JokeCellSecond.h"

@implementation JokeCellSecond
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andHeight:(CGFloat)height{
   // NSLog(@"init");
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"JokeCellSecond" owner:nil options:nil];
        //第一个子视图是cell
        self = [arr objectAtIndex:0];
        self.contentView.frame=CGRectMake(0, 0, SCREEN_WIDTH, height);
       
       // NSLog(@"%f,%f",self.imageheight.constant,self.imageView1.frame.size.width);
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.gifWeb.scrollView.bounces=NO;
        self.gifWeb.scrollView.scrollEnabled=NO;
    }
    return  self;
}
- (void)awakeFromNib {
    //NSLog(@"awake frome nib");
    [super awakeFromNib];
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
