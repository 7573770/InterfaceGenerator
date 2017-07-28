//
//  TransapiDao.m
//  InterfaceGenerator
//
//  Created by 邵存将 on 17/7/25.
//  Copyright © 2017年 scj. All rights reserved.
//

#import "TransapiDao.h"
#import "AFNetworking.h"

@implementation TransapiDao

/**
 使用百度翻译
 将模块名称翻译为英文
 @param moduleName moduleName
 @param success    英文名称
 @param failure    failure description
 */
-(void)trans:(NSString *)moduleName success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure{
    NSString *url=@"http://fanyi.baidu.com/v2transapi" ;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSMutableDictionary *body=[[NSMutableDictionary alloc]init];
    [body setObject:@"zh" forKey:@"from"];
    [body setObject:@"en" forKey:@"to"];
    [body setObject:moduleName forKey:@"query"];
    [body setObject:@"3" forKey:@"simple_means_flag"];
    [session POST:url parameters:body progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *data=responseObject[@"trans_result"][@"data"];
        NSString *dst=data[0][@"dst"];
        NSString *result=@"";
        NSArray<NSString *> *array=[dst componentsSeparatedByString:@" "];
        for (int i=0; i<array.count;i++) {//字符过长时取前俩个音标字符
            if (i<=1) {
                result=[result stringByAppendingString:[array[i]capitalizedString]];
            }
        }
        success(result);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(NSString *)encoded:(NSString *)name{
    NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)name,NULL,NULL,kCFStringEncodingUTF8));
    return encodedString;
}


@end
