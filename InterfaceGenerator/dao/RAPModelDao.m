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
#import "IOSRapFileResolver.h"


@implementation RAPModelDao



- (void)queryRAPModel:(NSString *)projectId success:(void (^)(NSArray<ModuleClass *>  *))success failure:(void (^)(NSError *))failure{
    NSString *url=[NSString stringWithFormat: @"https://rap.chinamcloud.com/api/queryRAPModel.do?projectId=%@",projectId] ;
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [session GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *modelJson=responseObject[@"modelJSON"];
        IOSRapFileResolver *rapFileResolver=[[IOSRapFileResolver alloc]init];
        //从解析器读取各个模块的数据
        NSArray<ModuleClass *> * moduleClassList=[rapFileResolver resolverFile:modelJson];
        if (moduleClassList.count>0) {
            success(moduleClassList);
        }
        NSLog(@"success");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
        NSLog(@"失败");
    }];
    
}





@end
