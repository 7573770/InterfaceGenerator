//
//  ModuleClass.h
//  InterfaceGenerator
//
//  Created by 邵存将 on 17/7/23.
//  Copyright © 2017年 scj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageClass.h"

@interface ModuleClass : NSObject

@property(nonatomic,assign)NSInteger id;
@property(nonatomic,strong)NSString *introduction;//模块简介
@property(nonatomic,strong)NSString *name;//模块名称
@property(nonatomic,strong)NSMutableArray<PageClass *>  *pageList;//当前模块对应的页面列表

@end
