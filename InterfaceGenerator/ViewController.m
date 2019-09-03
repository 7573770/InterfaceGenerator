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
#import "IOSIntefaceDirector.h"
#import "IOSBuilder.h"

@implementation ViewController{
    
}

-(IBAction)generatorFile:(id)sender{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setAllowsMultipleSelection:NO];
    [panel setCanChooseDirectories:YES];
    [panel setCanChooseFiles:NO];
    [panel setCanCreateDirectories:YES];
    [panel setResolvesAliases:YES];
    [panel setPrompt:NSLocalizedString(@"请选择", @"选择你要生成文件的路径")];
    panel.delegate=self;
    [panel beginWithCompletionHandler:^(NSInteger result) {
        if(result == NSModalResponseOK){
            NSString *pathString = [panel.URLs.firstObject path];
//            NSString *pathString = @"/Users/linshuicai/Documents/rap";
            pathString=[pathString stringByAppendingString:@"/"];
            RAPModelDao *modelDao=[[RAPModelDao alloc]init];
            [modelDao queryRAPModel:project.stringValue success:^(NSArray<ModuleClass *> *moduleList) {
                IOSIntefaceDirector *director=[[IOSIntefaceDirector alloc]init];
                director.builder=[[IOSBuilder alloc]init];
                [director construct:moduleList classPrefix:classPrefix.stringValue baseUrl:pathString author:author.stringValue projectID:project.stringValue];
                
                NSString *message=[NSString stringWithFormat:@"已在 %@ 下生成接口文件,直接复制文件至工程即可使用",pathString];
                NSAlert *alert = [NSAlert alertWithMessageText:@"提示" defaultButton:@"确定" alternateButton:nil otherButton:nil informativeTextWithFormat:message];
                [alert runModal];
            } failure:^(NSError *error) {
                NSAlert *alert = [NSAlert alertWithMessageText:@"提示" defaultButton:@"确定" alternateButton:nil otherButton:nil informativeTextWithFormat:@"接口读取失败，请确认项目ID或者RAP服务是否正常"];
                [alert runModal];
                NSLog(@"失败");
            }];
        }
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [classPrefix setStringValue:@"EL"];
    [project setStringValue:@"107"];
    [author setStringValue:@"邵存将"];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
