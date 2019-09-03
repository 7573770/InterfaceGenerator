//
//  PageClass.h
//  InterfaceGenerator
//
//  Created by 邵存将 on 17/7/23.
//  Copyright © 2017年 scj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActionClass.h"

@interface PageClass : NSObject

@property(nonatomic,assign)NSInteger id;
@property(nonatomic,strong)NSString *introduction;
@property(nonatomic,strong)NSString *name;//页面名称
@property(nonatomic,strong)NSMutableArray<ActionClass *>  *actionList;//当前页面对应的接口

@end
