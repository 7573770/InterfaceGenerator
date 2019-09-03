//
//  IOSBuilder.m
//  InterfaceGenerator
//
//  Created by scj on 2019/9/3.
//  Copyright © 2019年 scj. All rights reserved.
//

#import "IOSBuilder.h"
#import "IOSGeneratorClassService.h"

@implementation IOSBuilder

/**
 生成DAO接口
 
 @param modelClassList 数据模型
 @param classPrefix    类名前缀
 @param baseUrl        基础路径
 @param author         类编写者
 @param projectID     项目ID
 */
- (void)generatorDao:(NSArray<ModuleClass *>*)modelClassList classPrefix:(NSString *)classPrefix baseUrl:(NSString *)baseUrl author:(NSString *)author projectID:(NSString *)projectID{
    [IOSGeneratorClassService  generatorDao:modelClassList classPrefix:classPrefix baseUrl:baseUrl author:author projectID:projectID];
}

/**
 生成model
 
 @param modelClassList 数据模型
 @param classPrefix    类名前缀
 @param baseUrl        基础路径
 @param author         类编写者
 */
- (void)generatorModel:(NSArray<ModuleClass *>*)modelClassList classPrefix:(NSString *)classPrefix baseUrl:(NSString *)baseUrl author:(NSString *)author{
    [IOSGeneratorClassService generatorModel:modelClassList classPrefix:classPrefix baseUrl:baseUrl author:author];
}



/**
 生成接口调用层
 
 @param modelClassList 数据模型
 @param classPrefix    类名前缀
 @param baseUrl        基础路径
 @param author         类编写者
 */
- (void)generatorDaoService:(NSArray<ModuleClass *>*)modelClassList classPrefix:(NSString *)classPrefix baseUrl:(NSString *)baseUrl author:(NSString *)author{
    [IOSGeneratorClassService generatorDaoService:modelClassList classPrefix:classPrefix baseUrl:baseUrl author:author];
}

@end
