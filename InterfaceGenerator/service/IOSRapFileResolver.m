//
//  IOSRapFileResolver.m
//  InterfaceGenerator
//
//  Created by scj on 2019/9/2.
//  Copyright © 2019年 scj. All rights reserved.
//

#import "IOSRapFileResolver.h"

@implementation IOSRapFileResolver


/**
 iOS解析器
 @param interfaceData 将接口文档返回的数据转化为模块数据
 @return return
 */
- (NSArray<ModuleClass *> *)resolverFile:(NSString *)interfaceData{
    
    NSDictionary *dict=[self parseJsonStringToNSDictionary:interfaceData];
    NSArray *moduleList=[dict objectForKey:@"moduleList"];
    NSMutableArray<ModuleClass *> *moduleClassList=[[NSMutableArray<ModuleClass *> alloc]init];
    for (NSDictionary *dict in moduleList) {
        ModuleClass *moduleClass=[[ModuleClass alloc]init];
        NSNumber *id=[dict objectForKey:@"id"];
        moduleClass.id=[id integerValue];
        moduleClass.introduction=[dict objectForKey:@"introduction"];
        moduleClass.name=[dict objectForKey:@"name"];
        moduleClass.pageList=[self resolverPageClass:dict];
        [moduleClassList addObject:moduleClass];
       
    }
    return moduleClassList;
}

/**
 从模块中读取所有的页面
 
 @param moduledict
 */
- (NSMutableArray<PageClass *> *)resolverPageClass:(NSDictionary *)moduledict{
    NSArray  *pageList= [moduledict objectForKey:@"pageList"];
    NSMutableArray<PageClass *> *pageClassList=[[NSMutableArray<PageClass *> alloc]init];
    for (NSDictionary *pagedict in pageList) {
        PageClass *pageClass=[[PageClass alloc]init];
        NSNumber *pageid=[pagedict objectForKey:@"id"];
        pageClass.id=[pageid integerValue];
        pageClass.introduction=[pagedict objectForKey:@"introduction"];
        pageClass.name=[pagedict objectForKey:@"name"];
        pageClass.actionList=[self resolverActionClass:pagedict];
        [pageClassList addObject:pageClass];
    }
    return pageClassList;
}


/**
 从页面中读取所有的方法

 @param pagedict
 */
- (NSMutableArray<ActionClass *> *)resolverActionClass:(NSDictionary *)pagedict{
    NSMutableArray<ActionClass *>  *actionClassList=[[NSMutableArray<ActionClass *> alloc]init];
    NSArray *actionList=[pagedict objectForKey:@"actionList"];
    for (NSDictionary *actiondict in actionList) {
        ActionClass *actionClass=[[ActionClass alloc]init];
        NSNumber *actionid=[actiondict objectForKey:@"id"];
        actionClass.id=[actionid integerValue];
        actionClass.requestUrl=[actiondict objectForKey:@"requestUrl"];
        actionClass._description=[actiondict objectForKey:@"description"];
        actionClass.name=[actiondict objectForKey:@"name"];
        NSNumber *requestType=[actiondict objectForKey:@"requestType"];
        actionClass.requestType=[requestType integerValue];
        actionClass.responseTemplate=[actiondict objectForKey:@"responseTemplate"];
        actionClass.requestParameterList=[self getRequestParam:actiondict];
        actionClass.responseParameterList=[self getResponseParam:actiondict];
        [actionClassList addObject:actionClass];
    }
    return actionClassList;
}

/**
 根据方法类获取请求参数

 */
- (NSMutableArray<ParameterClass *> *)getRequestParam:(NSDictionary *)actiondict{
    NSMutableArray<ParameterClass *>  *requestParameterClassList=[[NSMutableArray<ParameterClass *> alloc]init];
    NSArray *requestParameterList=[actiondict objectForKey:@"requestParameterList"];
    for (NSDictionary *requestdict in requestParameterList) {
        ParameterClass *parameterClass=[[ParameterClass alloc]init];
        NSNumber *parameterClassid=[requestdict objectForKey:@"id"];
        parameterClass.id=[parameterClassid integerValue];
        parameterClass.identifier=[requestdict objectForKey:@"identifier"];
        parameterClass.name=[requestdict objectForKey:@"name"];
        parameterClass.remark=[requestdict objectForKey:@"remark"];
        parameterClass.responseTemplate=[requestdict objectForKey:@"responseTemplate"];
        parameterClass.validator=[requestdict objectForKey:@"validator"];
        parameterClass.dataType=[requestdict objectForKey:@"dataType"];
        NSMutableArray<ParameterClass *>  *parameterClassList=[[NSMutableArray<ParameterClass *> alloc]init];
        parameterClass.parameterList=parameterClassList;
        [requestParameterClassList addObject:parameterClass];
        [self recursionParameterList:requestdict parameterClassList:parameterClassList];
    }
    return requestParameterClassList;
}


/**
 根据方法类获取响应参数
 
 */
- (NSMutableArray<ParameterClass *> *)getResponseParam:(NSDictionary *)actiondict{
    
     NSMutableArray<ParameterClass *>  *resopnseParameterClassList=[[NSMutableArray<ParameterClass *> alloc]init];
    NSArray *responseParameterList=[actiondict objectForKey:@"responseParameterList"];
    for (NSDictionary *requestdict in responseParameterList) {
        ParameterClass *parameterClass=[[ParameterClass alloc]init];
        NSNumber *parameterClassid=[requestdict objectForKey:@"id"];
        parameterClass.id=[parameterClassid integerValue];
        parameterClass.identifier=[requestdict objectForKey:@"identifier"];
        parameterClass.name=[requestdict objectForKey:@"name"];
        parameterClass.remark=[requestdict objectForKey:@"remark"];
        parameterClass.responseTemplate=[requestdict objectForKey:@"responseTemplate"];
        parameterClass.validator=[requestdict objectForKey:@"validator"];
        parameterClass.dataType=[requestdict objectForKey:@"dataType"];
        NSMutableArray<ParameterClass *>  *parameterClassList=[[NSMutableArray<ParameterClass *> alloc]init];
        parameterClass.parameterList=parameterClassList;
        [resopnseParameterClassList addObject:parameterClass];
        [self recursionParameterList:requestdict parameterClassList:parameterClassList];
    }
    return resopnseParameterClassList;
}

/**
 递归遍历参数列表把每次参数的值设置到对应的参数列表里

 @param dict
 @param parameterClassList
 */
-(void)recursionParameterList:(NSDictionary *)dict parameterClassList:(NSMutableArray<ParameterClass *>  *)parameterClassList{
    NSArray *parameterList=[dict objectForKey:@"parameterList"];
    for (NSDictionary *requestdict in parameterList) {
        ParameterClass *parameterClass=[[ParameterClass alloc]init];
        NSNumber *parameterClassid=[requestdict objectForKey:@"id"];
        parameterClass.id=[parameterClassid integerValue];
        parameterClass.identifier=[requestdict objectForKey:@"identifier"];
        parameterClass.name=[requestdict objectForKey:@"name"];
        parameterClass.remark=[requestdict objectForKey:@"remark"];
        parameterClass.responseTemplate=[requestdict objectForKey:@"responseTemplate"];
        parameterClass.validator=[requestdict objectForKey:@"validator"];
        parameterClass.dataType=[requestdict objectForKey:@"dataType"];
        [parameterClassList addObject:parameterClass];
        NSMutableArray<ParameterClass *>  *newClassList=[[NSMutableArray<ParameterClass *> alloc]init];
        parameterClass.parameterList=newClassList;
        [self recursionParameterList:requestdict parameterClassList:newClassList];
    }
}


/**
 移除转义字符

 @param jsonString
 @return return
 */
- (NSDictionary *)parseJsonStringToNSDictionary:(NSString *)jsonString
{
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    return dict;
}


@end
