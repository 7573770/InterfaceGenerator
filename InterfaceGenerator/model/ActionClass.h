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
@property(nonatomic,strong)NSString *name;
@property(nonatomic,assign)NSInteger requestType;
@property(nonatomic,strong)NSString *responseTemplate;
@property(nonatomic,strong)NSString *requestUrl;
@property(nonatomic,strong)NSMutableArray<ParameterClass *> *requestParameterList;
@property(nonatomic,strong)NSMutableArray<ParameterClass *> *responseParameterList;

@end    
