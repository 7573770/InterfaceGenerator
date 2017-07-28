//
//  RAPModelDao.h
//  InterfaceGenerator
//
//  Created by 邵存将 on 17/7/19.
//  Copyright © 2017年 scj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModuleClass.h"

@interface RAPModelDao : NSObject


/**
 根据项目ID查询所有的接口和模块数据

 @param projectId 项目ID
 @param success   success 模块列表
 @param failure   failure description
 */
-(void)queryRAPModel:(NSString *)projectId success:(void (^)(NSArray<ModuleClass *>  *))success failure:(void (^)(NSError *))failure;

@end
