//
//  ActionClass.h
//  InterfaceGenerator
//
//  Created by 邵存将 on 17/7/23.
//  Copyright © 2017年 scj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParameterClass.h"

@interface ActionClass : NSObject

@property(nonatomic,assign)NSInteger id;
@property(nonatomic,strong)NSString *_description;
@property(nonatomic,strong)NSString *name;//接口名称
@property(nonatomic,assign)NSInteger requestType;//接口的请求类型
@property(nonatomic,strong)NSString *responseTemplate;
@property(nonatomic,strong)NSString *requestUrl;//接口的请求地址
@property(nonatomic,strong)NSMutableArray<ParameterClass *> *requestParameterList;//请求参数
@property(nonatomic,strong)NSMutableArray<ParameterClass *> *responseParameterList;//响应参数

@end    
