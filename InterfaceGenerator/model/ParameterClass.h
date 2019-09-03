//
//  ParameterClass.h
//  InterfaceGenerator
//
//  Created by 邵存将 on 17/7/23.
//  Copyright © 2017年 scj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParameterClass : NSObject

@property(nonatomic,assign)NSInteger id;
@property(nonatomic,strong)NSString *identifier;
@property(nonatomic,strong)NSString *name;//参数名称
@property(nonatomic,strong)NSString *remark;
@property(nonatomic,strong)NSString *responseTemplate;
@property(nonatomic,strong)NSMutableArray<ParameterClass *> *parameterList;//参数可以嵌套 比如类型为对象
@property(nonatomic,strong)NSString *validator;
@property(nonatomic,strong)NSString *dataType;//参数类型 字符串/整形/对象 等等

@end
