//
//  TransapiDao.h
//  InterfaceGenerator
//
//  Created by 邵存将 on 17/7/25.
//  Copyright © 2017年 scj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransapiDao : NSObject



/**
 使用百度翻译
 将模块名称翻译为英文
 @param moduleName moduleName
 @param success    英文名称
 @param failure    failure description
 */
-(void)trans:(NSString *)moduleName success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure;

@end
