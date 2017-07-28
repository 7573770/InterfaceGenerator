//
//  RAPModelDao.m
//  InterfaceGenerator
//
//  Created by 邵存将 on 17/7/19.
//  Copyright © 2017年 scj. All rights reserved.
//

#import "RAPModelDao.h"
 #import "AFNetworking.h"
#import "ModuleClass.h"


@implementation RAPModelDao



-(void)queryRAPModel:(NSString *)projectId success:(void (^)(NSArray<ModuleClass *>  *))success failure:(void (^)(NSError *))failure{
    NSString *url=[NSString stringWithFormat: @"http://rapapi.org/api/queryRAPModel.do?projectId=%@",projectId] ;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [session GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *modelJson=responseObject[@"modelJSON"];
        NSDictionary *dict=[self parseJsonStringToNSDictionary:modelJson];
        NSArray *moduleList=[dict objectForKey:@"moduleList"];
        NSMutableArray<ModuleClass *> *moduleClassList=[[NSMutableArray<ModuleClass *> alloc]init];
        for (NSDictionary *dict in moduleList) {
            ModuleClass *moduleClass=[[ModuleClass alloc]init];
            NSNumber *id=[dict objectForKey:@"id"];
            moduleClass.id=[id integerValue];
            moduleClass.introduction=[dict objectForKey:@"introduction"];
            moduleClass.name=[dict objectForKey:@"name"];
            NSArray  *pageList= [dict objectForKey:@"pageList"];
            NSMutableArray<PageClass *> *pageClassList=[[NSMutableArray<PageClass *> alloc]init];
            moduleClass.pageList=pageClassList;
            [moduleClassList addObject:moduleClass];
            for (NSDictionary *pagedict in pageList) {
                PageClass *pageClass=[[PageClass alloc]init];
                NSNumber *pageid=[pagedict objectForKey:@"id"];
                pageClass.id=[pageid integerValue];
                pageClass.introduction=[pagedict objectForKey:@"introduction"];
                pageClass.name=[pagedict objectForKey:@"name"];
                NSMutableArray<ActionClass *>  *actionClassList=[[NSMutableArray<ActionClass *> alloc]init];
                pageClass.actionList=actionClassList;
                NSString *actionList=[pagedict objectForKey:@"actionList"];
                [pageClassList addObject:pageClass];
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
                    NSMutableArray<ParameterClass *>  *requestParameterClassList=[[NSMutableArray<ParameterClass *> alloc]init];
                    NSMutableArray<ParameterClass *>  *resopnseParameterClassList=[[NSMutableArray<ParameterClass *> alloc]init];
                    actionClass.requestParameterList=requestParameterClassList;
                    actionClass.responseParameterList=resopnseParameterClassList;
                    [actionClassList addObject:actionClass];
                    
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

                }
            }
        }
        
        
        if (moduleClassList.count>0) {
            success(moduleClassList);
        }
        NSLog(@"success");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"失败");
    }];
    
}


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
