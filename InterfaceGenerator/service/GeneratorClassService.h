//
//  GeneratorClassService.h
//  InterfaceGenerator
//
//  Created by 邵存将 on 17/7/23.
//  Copyright © 2017年 scj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModuleClass.h"

@interface GeneratorClassService : NSObject




/**
 生成DAO接口

 @param modelClassList 数据模型
 @param classPrefix    类名前缀
 @param baseUrl        基础路径
 @param author         类编写者
  @param projectID     项目ID
 */
+(void)generatorDao:(NSArray<ModuleClass *>*)modelClassList classPrefix:(NSString *)classPrefix baseUrl:(NSString *)baseUrl author:(NSString *)author projectID:(NSString *)projectID;


/**
 生成model

 @param modelClassList modelClassList description
 @param classPrefix    classPrefix description
 */
+(void)generatorModel:(NSArray<ModuleClass *>*)modelClassList classPrefix:(NSString *)classPrefix baseUrl:(NSString *)baseUrl author:(NSString *)author;


/**
 生成接口调用层

 @param modelClassList modelClassList description
 @param classPrefix    classPrefix description
 */
+(void)generatorDaoService:(NSArray<ModuleClass *>*)modelClassList classPrefix:(NSString *)classPrefix baseUrl:(NSString *)baseUrl author:(NSString *)author;

@end
