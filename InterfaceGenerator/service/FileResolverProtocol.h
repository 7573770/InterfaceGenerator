//
//  FileResolver.h
//  InterfaceGenerator
//
//  Created by scj on 2019/9/3.
//  Copyright © 2019年 scj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModuleClass.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FileResolverProtocol <NSObject>

@required
/**
 解析器将接口文档返回的数据转化为模块数据
 @param interfaceData 从rap服务器接口文档返回的json数据
 @return return
 */
- (NSArray<ModuleClass *> *)resolverFile:(NSString *)interfaceData;

@end

NS_ASSUME_NONNULL_END
