//
//  IOSIntefaceDirector.m
//  InterfaceGenerator
//
//  Created by scj on 2019/9/3.
//  Copyright © 2019年 scj. All rights reserved.
//

#import "IOSIntefaceDirector.h"

@implementation IOSIntefaceDirector

- (BOOL)construct:(NSArray<ModuleClass *>*)modelClassList classPrefix:(NSString *)classPrefix baseUrl:(NSString *)baseUrl author:(NSString *)author projectID:(NSString *)projectID{
    [_builder generatorDao:modelClassList classPrefix:classPrefix baseUrl:baseUrl author:author projectID:projectID];
    [_builder generatorModel:modelClassList classPrefix:classPrefix baseUrl:baseUrl author:author];
    [_builder generatorDaoService:modelClassList classPrefix:classPrefix baseUrl:baseUrl author:author];
    return YES;
}

@end
