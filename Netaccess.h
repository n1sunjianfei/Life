//
//  Netaccess.h
//  test
//
//  Created by 孙建飞 on 16/10/17.
//  Copyright © 2016年 sjf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
@interface Netaccess : NSObject
+(BOOL)isWifiAccess;
+(BOOL)isWanAccess;
@end
