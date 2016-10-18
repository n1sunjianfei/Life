//
//  JsonNetwork.h
//  Life
//
//  Created by 孙建飞 on 16/10/17.
//  Copyright © 2016年 sjf. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^SendValueBlock)(NSDictionary *dic);//返回数据

@interface JsonNetwork : NSObject

@property(nonatomic,assign) NSMutableArray *MuData;
@property(nonatomic,assign) NSArray *data;
//获取歌曲信息
+(NSDictionary*)loadSonginfoWithUrlstr:(NSString *)URLString;
//生成urlstr
+(NSString*)encodeUrlStrWithString:(NSString*)urlstr;
//加载播放列表
+(void)loadPlaylistWithUrlstr:(NSString *)URLString block:(SendValueBlock)block;
//
+(void)searchDeliveryWithUrlstr:(NSString*) urlstr block:(SendValueBlock)block;

+(void)getLrcWithUrlstr:(NSString*)urlstr withSonginfo:(NSDictionary*)songinfo block:(SendValueBlock)block;

+(NSString *)getLocalFilePathWith:(NSDictionary*)songinfo;
+(void)loadNewsDataWithUrlstr:(NSString*)urlstr block:(SendValueBlock)block;
+(void)loadWeatherWithUrlstr:(NSString*)urlstr block:(SendValueBlock)block;

/*
 获取下载文件夹路径
 */
+(NSString *)getLocalDownloadDir;
/*
 获取下载列表路径
 */
+(NSString *)getLocalDownloadHistoryPlistPath;
//下载音乐
+(void)downloadMp3With:(NSDictionary*)dic andSongdic:(NSDictionary*)songDic  block:(SendValueBlock)block;
+(void)removeMp3With:(NSDictionary*)dic;
@end
