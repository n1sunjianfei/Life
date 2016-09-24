//
//  MusicVC.h
//  Life
//
//  Created by 孙建飞 on 16/9/21.
//  Copyright © 2016年 sjf. All rights reserved.
//

#import "BaseVC.h"
#import "PlaylistVC.h"
@interface MusicVC : BaseVC<UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchbar;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property(nonatomic,strong) PlaylistVC *playlistVC;
@property(nonatomic,copy) NSArray *singgerArr;
@property(nonatomic,copy) NSArray *songListArr;
@property(nonatomic,copy) NSArray *colorsArr;
@property(nonatomic,copy) NSArray *singgerIDArr;
@end
