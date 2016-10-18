
//
//  JsonNetwork.m
//  Life
//
//  Created by 孙建飞 on 16/10/17.
//  Copyright © 2016年 sjf. All rights reserved.
//

#import "JsonNetwork.h"

@implementation JsonNetwork

+(NSString*)encodeUrlStrWithString:(NSString*)urlstr{
     NSString *encodedUrlStr=[urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return encodedUrlStr;
}
+(NSDictionary*)loadSonginfoWithUrlstr:(NSString *)URLString{
    NSURL *url=[NSURL URLWithString:URLString];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"GET";
    NSURLResponse *response;
    
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return dic;
}
+(void)loadPlaylistWithUrlstr:(NSString *)URLString block:(SendValueBlock)block{
//    NSDictionary *blockDic;
    
    NSURL *url=[NSURL URLWithString:URLString];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new ] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data) {
            NSDictionary *dic=  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            block(dic);
        }
        if (connectionError) {
            NSLog(@"%@",connectionError);
        }
    }];
}
+(void)searchDeliveryWithUrlstr:(NSString*) urlstr block:(SendValueBlock)block{

    NSURL *url=[NSURL URLWithString:urlstr];

    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];

    request.HTTPMethod=@"POST";

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
    if (data) {
         NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        block(dic);
    }
   
}];
}
+(void)getLrcWithUrlstr:(NSString *)urlstr withSonginfo:(NSDictionary *)songinfo block:(SendValueBlock)block{
    NSURL *url=[NSURL URLWithString:urlstr];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"GET";
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (data) {
            [data writeToFile:[JsonNetwork getLocalFilePathWith:songinfo] atomically:YES];
            NSLog(@"歌词准备完毕");
            NSDictionary *dic;
            block(dic);
        }
    }];
}
+(void)loadNewsDataWithUrlstr:(NSString *)urlstr block:(SendValueBlock)block{
    NSURL *url=[NSURL URLWithString:urlstr];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    request.cachePolicy=NSURLRequestReloadIgnoringCacheData;
    request.timeoutInterval=20;
    request.HTTPMethod=@"POST";
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data) {
            NSDictionary *dataDic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *resultDic=[dataDic valueForKey:@"result"];
            block(resultDic);

        }else{
            NSLog(@"网络不可用...");
        }
    }];
}
+(void)loadWeatherWithUrlstr:(NSString*)urlstr block:(SendValueBlock)block{
    NSURL *url=[NSURL URLWithString:urlstr];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSDictionary *dic=  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *resultDic= [dic valueForKey:@"result"];
        NSDictionary *datadic=[resultDic valueForKey:@"data"];
        NSDictionary *weatherDic= [datadic valueForKey:@"realtime"];

        block(weatherDic);
    }];
}
/*
 获取文件路径
 */
+(NSString *)getLocalFilePathWith:(NSDictionary*)songinfo{
    NSFileManager *manager=[NSFileManager defaultManager];
    NSArray *arr=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path=[arr objectAtIndex:0];
    NSString *path2=[path stringByAppendingPathComponent:@"/lrc"];
    if (![manager fileExistsAtPath:path2]) {
        [manager createDirectoryAtPath:path2 withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *filepath=[NSString stringWithFormat:@"%@/%@-%@.lrc",path2,[songinfo valueForKey:@"author"],[songinfo valueForKey:@"title"]];
//        NSLog(@"%@",filepath);
    return filepath;
}

/*
 获取下载文件夹路径
 */
+(NSString *)getLocalDownloadDir{
    NSFileManager *manager=[NSFileManager defaultManager];
    NSArray *arr=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path=[arr objectAtIndex:0];
    NSString *dirPath=[path stringByAppendingPathComponent:@"/Download"];
    if (![manager fileExistsAtPath:dirPath]) {
        [manager createDirectoryAtPath:dirPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    //    NSLog(@"%@",dirPath);
    return dirPath;
}
/*
 获取下载列表路径
 */
+(NSString *)getLocalDownloadHistoryPlistPath{
    NSFileManager *manager=[NSFileManager defaultManager];
    NSArray *arr=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path=[arr objectAtIndex:0];
    NSString *dirPath=[path stringByAppendingPathComponent:@"/Download/downloadList.plist"];
    if (![manager fileExistsAtPath:dirPath]) {
        NSMutableArray *downloadDic=[[NSMutableArray alloc]init];
        [downloadDic writeToFile:dirPath atomically:YES];
    }
    //    NSLog(@"%@",dirPath);
    return dirPath;
}
+(void)downloadMp3With:(NSDictionary*)dic andSongdic:(NSDictionary*)songDic block:(SendValueBlock)block{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *filename;
        if ([[dic valueForKey:@"songid"] length]>0) {//
            filename=[NSString stringWithFormat:@"/%@.plist",[dic valueForKey:@"songid"]];
        }else{
            filename=[NSString stringWithFormat:@"/%@.plist",[dic valueForKey:@"song_id"]];
        }
        NSString *songidPath=[[JsonNetwork getLocalDownloadDir] stringByAppendingPathComponent:filename];
        
        NSMutableArray *tem =[NSMutableArray arrayWithContentsOfFile:[JsonNetwork getLocalDownloadHistoryPlistPath]];
        //存储歌曲下载列表信息
        [tem addObject:dic];
        [tem writeToFile:[JsonNetwork getLocalDownloadHistoryPlistPath] atomically:YES];
        //存储歌曲info
        [songDic writeToFile:songidPath atomically:YES];
        
        //下载歌曲
        NSDictionary *bitrate=[songDic valueForKey:@"bitrate"];
        NSDictionary *songinfo=[songDic valueForKey:@"songinfo"];
        
        NSString *urlStr=[bitrate valueForKey:@"file_link"];
        NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
        NSString *filepath=[NSString stringWithFormat:@"%@/%@-%@.mp3",[JsonNetwork getLocalDownloadDir],[songinfo valueForKey:@"author"],[songinfo valueForKey:@"title"]];
//        NSLog(@"%@",filepath);
        [data writeToFile:filepath atomically:YES];
        block(nil);
    });
   
}
+(void)removeMp3With:(NSDictionary*)dic{
    NSFileManager *manager=[NSFileManager defaultManager];
    
    NSString *filename;
    if ([[dic valueForKey:@"songid"] length]>0) {//
        filename=[NSString stringWithFormat:@"/%@.plist",[dic valueForKey:@"songid"]];
    }else{
        filename=[NSString stringWithFormat:@"/%@.plist",[dic valueForKey:@"song_id"]];
    }
    NSString *songidPath=[[JsonNetwork getLocalDownloadDir] stringByAppendingPathComponent:filename];
    
    NSMutableArray *tem =[NSMutableArray arrayWithContentsOfFile:[JsonNetwork getLocalDownloadHistoryPlistPath]];
    //删除歌曲下载列表信息
    [tem removeObject:dic];
    [tem writeToFile:[JsonNetwork getLocalDownloadHistoryPlistPath] atomically:YES];
    NSDictionary *songDic=[NSDictionary dictionaryWithContentsOfFile:songidPath];
    //删除歌曲
    NSDictionary *songinfo=[songDic valueForKey:@"songinfo"];
    NSString *filepath=[NSString stringWithFormat:@"%@/%@-%@.mp3",[JsonNetwork getLocalDownloadDir],[songinfo valueForKey:@"author"],[songinfo valueForKey:@"title"]];
    [manager removeItemAtPath:filepath error:nil];
    // NSLog(@"%@",filepath);
    //存储歌曲info
    [manager removeItemAtPath:songidPath error:nil];
    
}

@end
