//
//  IOSBuilder.h
//  InterfaceGenerator
//
//  Created by scj on 2019/9/3.
//  Copyright © 2019年 scj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IntefaceBuilder.h"

NS_ASSUME_NONNULL_BEGIN

@interface IOSBuilder : IntefaceBuilder

- (void)generatorDao:(NSArray<ModuleClass *>*)modelClassList classPrefix:(NSString *)classPrefix baseUrl:(NSString *)baseUrl author:(NSString *)author projectID:(NSString *)projectID;

- (void)generatorModel:(NSArray<ModuleClass *>*)modelClassList classPrefix:(NSString *)classPrefix baseUrl:(NSString *)baseUrl author:(NSString *)author;

- (void)generatorDaoService:(NSArray<ModuleClass *>*)modelClassList classPrefix:(NSString *)classPrefix baseUrl:(NSString *)baseUrl author:(NSString *)author;

@end

NS_ASSUME_NONNULL_END
