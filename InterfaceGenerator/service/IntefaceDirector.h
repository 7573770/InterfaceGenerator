//
//  IntefaceDirector.h
//  InterfaceGenerator
//
//  Created by scj on 2019/9/3.
//  Copyright © 2019年 scj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IntefaceDirector <NSObject>

@required

- (BOOL)construct:(NSArray<ModuleClass *>*)modelClassList classPrefix:(NSString *)classPrefix baseUrl:(NSString *)baseUrl author:(NSString *)author projectID:(NSString *)projectID;

@end

NS_ASSUME_NONNULL_END
