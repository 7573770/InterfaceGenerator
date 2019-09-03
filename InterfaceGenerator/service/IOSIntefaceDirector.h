//
//  IOSIntefaceDirector.h
//  InterfaceGenerator
//
//  Created by scj on 2019/9/3.
//  Copyright © 2019年 scj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IntefaceBuilder.h"
#import "IntefaceDirector.h"

NS_ASSUME_NONNULL_BEGIN

@interface IOSIntefaceDirector : NSObject<IntefaceDirector>

@property(nonatomic,strong)IntefaceBuilder *builder;

@end

NS_ASSUME_NONNULL_END
