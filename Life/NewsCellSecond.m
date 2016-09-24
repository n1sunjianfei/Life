//
//  NewsCellSecond.m
//  Life
//
//  Created by 孙建飞 on 16/9/23.
//  Copyright © 2016年 sjf. All rights reserved.
//

#import "NewsCellSecond.h"

@implementation NewsCellSecond
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    //NSLog(@"init");
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"NewsCellSecond" owner:nil options:nil];
        //第一个子视图是cell
        self = [arr objectAtIndex:0];
        self.contentView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 57);
        self.imageheight.constant=self.imageView1.frame.size.width*3/4;
       // NSLog(@"%f,%f",self.imageheight.constant,self.imageView1.frame.size.width);
        self.selectionStyle=UITableViewCellSelectionStyleNone;

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
