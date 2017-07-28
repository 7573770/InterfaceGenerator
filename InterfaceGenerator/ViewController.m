//
//  ViewController.m
//  InterfaceGenerator
//
//  Created by 邵存将 on 17/7/19.
//  Copyright © 2017年 scj. All rights reserved.
//

#import "ViewController.h"
#import "RAPModelDao.h"
#import "ModuleClass.h"
#import "GeneratorClassService.h"


@implementation ViewController{
    
}

-(IBAction)generatorFile:(id)sender{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setAllowsMultipleSelection:NO];
    [panel setCanChooseDirectories:YES];
    [panel setCanChooseFiles:NO];
    [panel setCanCreateDirectories:YES];
    [panel setResolvesAliases:YES];
    [panel setPrompt:NSLocalizedString(@"Choose", @"Label to have the user select which folder to choose")];
    panel.delegate=self;
    [panel beginWithCompletionHandler:^(NSInteger result) {
        if(result == NSModalResponseOK){
            NSString *pathString = [panel.URLs.firstObject path];
            pathString=[pathString stringByAppendingString:@"/"];
            RAPModelDao *modelDao=[[RAPModelDao alloc]init];
            [modelDao queryRAPModel:project.stringValue success:^(NSArray<ModuleClass *> *moduleList) {
                    [GeneratorClassService generatorDao:moduleList classPrefix:classPrefix.stringValue baseUrl:pathString author:author.stringValue projectID:project.stringValue]; //生成dao接口
                    [GeneratorClassService generatorModel:moduleList classPrefix:classPrefix.stringValue baseUrl:pathString author:author.stringValue];//生成数据模型
                    [GeneratorClassService generatorDaoService:moduleList classPrefix:classPrefix.stringValue baseUrl:pathString author:author.stringValue];//生成业务接口调用层
            } failure:^(NSError *error) {
                    
            }];
        }
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [classPrefix setStringValue:@"RAP"];
    [project setStringValue:@"21739"];
    [author setStringValue:@"邵存将"];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
