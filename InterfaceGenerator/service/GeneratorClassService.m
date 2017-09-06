//
//  GeneratorClassService.m
//  InterfaceGenerator
//
//  Created by 邵存将 on 17/7/23.
//  Copyright © 2017年 scj. All rights reserved.
//




#import "GeneratorClassService.h"
#import <AddressBook/AddressBook.h>
#import "TransapiDao.h"

@implementation GeneratorClassService


+(void)generatorDao:(NSArray<ModuleClass *>*)modelClassList classPrefix:(NSString *)classPrefix baseUrl:(NSString *)baseUrl author:(NSString *)author projectID:(NSString *)projectID{
    
//    NSString *baseUrl=@"/Users/linshuicai/Documents/";
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *daoInterfaceTemplateFile = [mainBundle pathForResource:@"DaoInterfaceTemplate" ofType:@"txt"];
    NSString *daoInterfaceTemplate = [[NSString alloc] initWithContentsOfFile:daoInterfaceTemplateFile
                                                               encoding:NSUTF8StringEncoding
                                                                  error:nil];
    NSString *daoImplementationTemplateFile = [mainBundle pathForResource:@"DaoImplementationTemplate" ofType:@"txt"];
    NSString *daoImplementationTemplate = [[NSString alloc] initWithContentsOfFile:daoImplementationTemplateFile
                                                                     encoding:NSUTF8StringEncoding
                                                                        error:nil];
    NSString *configTemplateFile = [mainBundle pathForResource:@"ConfigTemplate" ofType:@"txt"];
    NSString *configTemplate = [[NSString alloc] initWithContentsOfFile:configTemplateFile
                                                                          encoding:NSUTF8StringEncoding
                                                                             error:nil];
    configTemplate=[configTemplate stringByReplacingOccurrencesOfString:@"{CLASSPREFIX}" withString:classPrefix];//常量文件
    
    for (ModuleClass *moduleClass in modelClassList) {
        
        NSString *folderName=moduleClass.name;
        [[NSFileManager defaultManager] removeItemAtPath:[baseUrl stringByAppendingString:folderName] error:nil];
        NSString *folder=[[baseUrl stringByAppendingString:folderName]stringByAppendingString:@"/DAO/"];
        [[NSFileManager defaultManager] createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];//创建本地文件夹
        NSString *configName=[classPrefix stringByAppendingString:@"Config.h"];
        [configTemplate writeToFile:[[[baseUrl stringByAppendingString:folderName] stringByAppendingString:@"/"] stringByAppendingString:configName] atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        NSMutableArray<PageClass *>  *pageList=moduleClass.pageList;
        for (PageClass *pageClass in pageList) {
            
           NSMutableArray<ActionClass *>  *actionList= pageClass.actionList;
            for (ActionClass *actionClass in actionList) {
                NSString *requestUrl=actionClass.requestUrl;
                NSInteger requestType=actionClass.requestType;
                NSMutableArray<ParameterClass *> *requestParameterList=actionClass.requestParameterList;
                NSString *resourceURI=[requestUrl copy];
                NSString *baseMockURL=[requestUrl copy];
                NSString *mockURL=@"@\"http://rapapi.org/mockjsdata/{projectID}";
                mockURL=[mockURL stringByReplacingOccurrencesOfString:@"{projectID}" withString:projectID];
                for (NSString *string in requestUrl.pathComponents) {
                    if ([string containsString:@"${"]&&[string containsString:@"}"]) {
                        baseMockURL=[baseMockURL stringByReplacingOccurrencesOfString:string withString:[self encoded:string]];
                    }
                }
                mockURL=[[mockURL stringByAppendingString:baseMockURL]stringByAppendingString:@"\""];
                if ((requestType==1||requestType==4)&&requestParameterList.count>0) {//get 和 delete请求url后要加参数
                    NSString *prams=@"?";
                    for (int i=0;i<requestParameterList.count;i++) {
                        ParameterClass *paramClass=requestParameterList[i];
                        prams=[prams stringByAppendingString:[NSString stringWithFormat:@"%@=${%@}",paramClass.identifier,paramClass.identifier]];
                        if (i!=requestParameterList.count-1) {
                            prams=[prams stringByAppendingString:@"&"];
                        }
                    }
                    if (resourceURI.length>1&&[[resourceURI substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"/"]) {
                        resourceURI=[resourceURI substringFromIndex:1];
                    }
                }
                resourceURI=[NSString stringWithFormat:@"@\"${BaseUrl}%@\"",resourceURI];
                
                NSString *lastPathComponent=[self capitalizedString:requestUrl.lastPathComponent];
                lastPathComponent=[self captureString:lastPathComponent start:@"${" end:@"}"];
                NSString *className=[NSString stringWithFormat:@"%@%@%@DAO",classPrefix,[self getRequestType:requestType],lastPathComponent];
                NSString *interfaceTemplate=[daoInterfaceTemplate stringByReplacingOccurrencesOfString:@"{CLASSNAME}" withString:className];
                NSString *implementationTemplate=[daoImplementationTemplate stringByReplacingOccurrencesOfString:@"{CLASSNAME}" withString:className];
                implementationTemplate=[implementationTemplate stringByReplacingOccurrencesOfString:@"{resourceURI}" withString:resourceURI];
            
                NSString *file=[folder stringByAppendingString:className];
                NSError *error;
                
                interfaceTemplate=[interfaceTemplate stringByReplacingOccurrencesOfString:@"__NAME__" withString:author];
                interfaceTemplate=[interfaceTemplate stringByReplacingOccurrencesOfString:@"__DATE__" withString:[self getCurrentTime]];
                interfaceTemplate=[interfaceTemplate stringByReplacingOccurrencesOfString:@"{CLASSPREFIX}" withString:classPrefix];
                
                [interfaceTemplate writeToFile:[file stringByAppendingString:@".h"] atomically:YES encoding:NSUTF8StringEncoding error:&error];
                
                implementationTemplate=[implementationTemplate stringByReplacingOccurrencesOfString:@"{CLASSPREFIX}" withString:classPrefix];
                implementationTemplate=[implementationTemplate stringByReplacingOccurrencesOfString:@"__NAME__" withString:author];
                implementationTemplate=[implementationTemplate stringByReplacingOccurrencesOfString:@"__DATE__" withString:[self getCurrentTime]];
                implementationTemplate=[implementationTemplate stringByReplacingOccurrencesOfString:@"{mockURI}" withString:mockURL];

                [implementationTemplate writeToFile:[file stringByAppendingString:@".m"] atomically:YES encoding:NSUTF8StringEncoding error:&error];
            }
        }
        
    }
    
}


+(void)generatorModel:(NSArray<ModuleClass *>*)modelClassList classPrefix:(NSString *)classPrefix baseUrl:(NSString *)baseUrl author:(NSString *)author{
    
//    NSString *baseUrl=@"/Users/linshuicai/Documents/";
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *modelInterfaceTemplateFile = [mainBundle pathForResource:@"ModelInterfaceTemplate" ofType:@"txt"];
    NSString *modelInterfaceTemplate = [[NSString alloc] initWithContentsOfFile:modelInterfaceTemplateFile
                                                                     encoding:NSUTF8StringEncoding
                                                                        error:nil];
    NSString *modelImplementationTemplateFile = [mainBundle pathForResource:@"ModelImplementationTemplate" ofType:@"txt"];
    NSString *modelImplementationTemplate = [[NSString alloc] initWithContentsOfFile:modelImplementationTemplateFile
                                                                          encoding:NSUTF8StringEncoding
                                                                             error:nil];
    NSString *nsValueTransformerTemplateFile = [mainBundle pathForResource:@"NSValueTransformerTemplate" ofType:@"txt"];
    NSString *nsValueTransformerTemplate = [[NSString alloc] initWithContentsOfFile:nsValueTransformerTemplateFile
                                                                            encoding:NSUTF8StringEncoding
                                                                               error:nil];
    
    for (ModuleClass *moduleClass in modelClassList) {
        NSString *folderName=moduleClass.name;//创建本地文件夹
        NSString *folder=[[baseUrl stringByAppendingString:folderName]stringByAppendingString:@"/MODEL/"];
        [[NSFileManager defaultManager] createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
        
        NSMutableArray<PageClass *>  *pageList=moduleClass.pageList;
        
        
        for (PageClass *pageClass in pageList) {
            NSMutableArray<ActionClass *>  *actionList= pageClass.actionList;
            for (ActionClass *actionClass in actionList) {
                NSString *requestUrl=actionClass.requestUrl;
                NSString *_description=actionClass._description;
                NSString *description=[_description stringByReplacingOccurrencesOfString:@"@type=array_map;" withString:@""];
                NSString *lastName=@"";
                if (![[description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
                    lastName=description;
                }else{
                    lastName=[self capitalizedString:requestUrl.lastPathComponent];
                    lastName=[self captureString:lastName start:@"${" end:@"}"];
                }
                NSString *modelName=[classPrefix stringByAppendingString:lastName];
                NSMutableArray<ParameterClass *> *responseParameterList=actionClass.responseParameterList;
                [self recursionParameterList:modelInterfaceTemplate modelImplementationTemplate:modelImplementationTemplate nsValueTransformerTemplate:nsValueTransformerTemplate parameterClassList:responseParameterList classPrefix:classPrefix folder:folder className:modelName author:author];
            }
        }
    }
}

+(void)generatorDaoService:(NSArray<ModuleClass *>*)modelClassList classPrefix:(NSString *)classPrefix baseUrl:(NSString *)baseUrl author:(NSString *)author{
    
    TransapiDao *transapiDao=[[TransapiDao alloc]init];
    
    for (ModuleClass *moduleClass in modelClassList) {
        [transapiDao trans:moduleClass.name success:^(NSString *enModuleName) {//模块名称转业务层类名
            enModuleName=[classPrefix stringByAppendingString:[enModuleName stringByAppendingString:@"Service"]];
//            NSString *baseUrl=@"/Users/linshuicai/Documents/";
            NSString *folderName=moduleClass.name;
            NSString *folder=[[baseUrl stringByAppendingString:folderName]stringByAppendingString:@"/Service/"];
            [[NSFileManager defaultManager] createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];//创建本地文件夹
            NSBundle *mainBundle = [NSBundle mainBundle];
            NSString *serviceInterfaceTemplateFile = [mainBundle pathForResource:@"ServiceInterfaceTemplate" ofType:@"txt"];
            NSString *serviceInterfaceTemplate = [[NSString alloc] initWithContentsOfFile:serviceInterfaceTemplateFile
                                                                                   encoding:NSUTF8StringEncoding
                                                                                      error:nil];
            
            NSString *serviceImplementationTemplateFile = [mainBundle pathForResource:@"ServiceImplementationTemplate" ofType:@"txt"];
            NSString *serviceImplementationTemplate = [[NSString alloc] initWithContentsOfFile:serviceImplementationTemplateFile
                                                                                 encoding:NSUTF8StringEncoding
                                                                                    error:nil];
            
            NSString *importString=@"";
            NSString *methodDeclation=@"";//方法定义
            NSString *methodImplementation=@"";//方法实现
            
            NSMutableArray<PageClass *>  *pageList=moduleClass.pageList;
            for (PageClass *pageClass in pageList) {
                NSMutableArray<ActionClass *>  *actionList= pageClass.actionList;
                for (ActionClass *actionClass in actionList) {
                    NSString *methodString=@"-(void){METHODNAME}:";
                    NSString *requestUrl=actionClass.requestUrl;
                    NSInteger requestType=actionClass.requestType;
                    
                    NSString *methodTemplate=[self getMethodTemplate:requestType];//方法模板
                    NSString *body=@"nil";//请求内容
                    NSString *result;//返回结果
                    NSString *classType; //类型
                    NSString *methodDao; // 调用的dao
                    NSString *prams=[NSString stringWithFormat:@"[dict setObject:%@ forKey:@\"BaseUrl\"];\n",[classPrefix stringByAppendingString:@"BaseUrl"]];//请求参数
                    NSString *methodAnnotation=actionClass.name;//方法名注释
                    NSString *pramAnnotation=@"";        //参数注释;
                    NSString *methodName=@"";
                    NSMutableArray<ParameterClass *> *requestParameterList=actionClass.requestParameterList;
                    if (requestParameterList.count==0) {
                        methodString=@"-(void){METHODNAME}:(void (^)({RESULT}))success failure:(void (^)(NSError *))failure;\n\n";
                    }else{
                        for (int i=0;i<requestParameterList.count;i++) {
                            
                            ParameterClass *parameterClass=requestParameterList[i];
                            NSString *dataType=parameterClass.dataType;
                            NSString *identifier=parameterClass.identifier;
                            pramAnnotation=[pramAnnotation stringByAppendingString:[NSString stringWithFormat:@"@pram %@      %@\n",identifier,parameterClass.name]];
                            if ([dataType isEqualToString:@"object"]) {//对象
                                methodString=[methodString stringByAppendingString:[NSString stringWithFormat:@"%@:(NSDictionary *)%@ ",identifier,identifier]];
                                if ([identifier isEqualToString:@"body"]&&(requestType==2||requestType==3)) {  //请求为post和put 参数为body 表示请求传递的是请求body
                                        body=identifier;
                                }else{
                                    NSString  *pram=[NSString stringWithFormat:@"   [dict setObject:%@ forKey:@\"%@\"];\n",identifier,identifier];
                                    prams=[prams stringByAppendingString:pram];
                                }
                            }else if([dataType hasPrefix:@"array"]){//数组类型
                                if (parameterClass.parameterList.count>0) {//数据为 array<object>
                                    methodString=[methodString stringByAppendingString:[NSString stringWithFormat:@"%@:(NSArray *)%@ ",identifier,identifier]];
                                }else{
                                    if([dataType isEqualToString:@"array<string>"]){
                                        methodString=[methodString stringByAppendingString:[NSString stringWithFormat:@"%@:(NSArray<NSString *> *)%@ ",identifier,identifier]];
                                    }else if([dataType isEqualToString:@"array<number>"]){
                                        methodString=[methodString stringByAppendingString:[NSString stringWithFormat:@"%@:(NSArray<NSNumber *> *)%@ ",identifier,identifier]];
                                    }else if([dataType isEqualToString:@"array<boolean>"]){
                                        methodString=[methodString stringByAppendingString:[NSString stringWithFormat:@"%@:(NSArray<BOOL> *)%@ ",identifier,identifier]];
                                    }
                                }
                                NSString  *pram=[NSString stringWithFormat:@"   [dict setObject:%@ forKey:@\"%@\"];\n",identifier,identifier];
                                prams=[prams stringByAppendingString:pram];
                            }else if([dataType isEqualToString:@"boolean"]){//bool类型
                                methodString=[methodString stringByAppendingString:[NSString stringWithFormat:@"%@:(BOOL)%@ ",identifier,identifier]];
                                NSString  *pram=[NSString stringWithFormat:@"   [dict setObject:[NSNumber numberWithBool:%@] forKey:@\"%@\"];\n",identifier,identifier];
                                prams=[prams stringByAppendingString:pram];
                            }else if([dataType isEqualToString:@"number"]){//整形
                                methodString=[methodString stringByAppendingString:[NSString stringWithFormat:@"%@:(NSNumber *)%@ ",identifier,identifier]];
                                NSString  *pram=[NSString stringWithFormat:@"   [dict setObject:%@ forKey:@\"%@\"];\n",identifier,identifier];
                                prams=[prams stringByAppendingString:pram];
                            }else{//字符串
                                methodString=[methodString stringByAppendingString:[NSString stringWithFormat:@"%@:(NSString *)%@ ",identifier,identifier]];
                                NSString  *pram=[NSString stringWithFormat:@"   [dict setObject:%@ forKey:@\"%@\"];\n",identifier,identifier];
                                prams=[prams stringByAppendingString:pram];
                            }
                            if (i==0) {
                                methodString=[methodString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@":%@",identifier] withString:@""];
                            }
                        }
                        methodString=[methodString stringByAppendingString:@"success:(void (^)({RESULT}))success failure:(void (^)(NSError *))failure;\n\n"];
                    }
                    
                    NSString *_description=actionClass._description;
                    NSString *description=[_description stringByReplacingOccurrencesOfString:@"@type=array_map;" withString:@""];
                    NSString *lastName=@"";
                    if (![[description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
                        lastName=description;
                    }else{
                        lastName=[self capitalizedString:requestUrl.lastPathComponent];
                        lastName=[self captureString:lastName start:@"${" end:@"}"];
                    }
                    NSString *className=[classPrefix stringByAppendingString:lastName]; //取model的类名
                    NSString *import=[NSString stringWithFormat:@"#import \"%@.h\"\n",className];
                    importString=[importString stringByAppendingString:import];
                    if ([_description containsString:@"@type=array_map;"]) {//表示返回值为数组
                        result=[NSString stringWithFormat:@"NSArray<%@ *>*",className];
                        methodString=[methodString stringByReplacingOccurrencesOfString:@"{RESULT}" withString:result];
                        classType=@"JSONArray";
                    }else{
                        result=[NSString stringWithFormat:@"%@ *",className];
                        methodString=[methodString stringByReplacingOccurrencesOfString:@"{RESULT}" withString:result];
                        classType=@"JSONObject";
                    }
                    NSString *lastPathComponent=[self capitalizedString:requestUrl.lastPathComponent];
                    lastPathComponent=[self captureString:lastPathComponent start:@"${" end:@"}"];
                    methodDao=[NSString stringWithFormat:@"%@%@%@DAO",classPrefix,[self getRequestType:requestType],lastPathComponent];//取dao类名
                    NSString *daoimport=[NSString stringWithFormat:@"#import \"%@.h\"\n",methodDao];
                    importString=[importString stringByAppendingString:daoimport];
                    
                    methodName=[[[self getRequestType:requestType]lowercaseString] stringByAppendingString:lastPathComponent];
                    methodString=[methodString stringByReplacingOccurrencesOfString:@"{METHODNAME}" withString:methodName];
                    NSString *annotationString=@"/**\n{METHODANNOTATION}\n{PramANNOTATION}\n*/\n";
                    annotationString=[annotationString stringByAppendingString:methodString];
                    methodDeclation=[methodDeclation stringByAppendingString:annotationString];
                    methodDeclation=[methodDeclation stringByReplacingOccurrencesOfString:@"{METHODANNOTATION}" withString:methodAnnotation];
                    methodDeclation=[methodDeclation stringByReplacingOccurrencesOfString:@"{PramANNOTATION}" withString:pramAnnotation];
                    

                    
                    methodTemplate=[methodTemplate stringByReplacingOccurrencesOfString:@"{METHODANDPRAM}" withString:[methodString stringByReplacingOccurrencesOfString:@";\n\n" withString:@""]];
                    methodTemplate=[methodTemplate stringByReplacingOccurrencesOfString:@"{METHODANNOTATION}" withString:methodAnnotation];
                    methodTemplate=[methodTemplate stringByReplacingOccurrencesOfString:@"{PramANNOTATION}" withString:pramAnnotation];
                    methodTemplate=[methodTemplate stringByReplacingOccurrencesOfString:@"{ADDPRAM}" withString:prams];
                    methodTemplate=[methodTemplate stringByReplacingOccurrencesOfString:@"{METHODDAO}" withString:methodDao];
                    methodTemplate=[methodTemplate stringByReplacingOccurrencesOfString:@"{BODY}" withString:body];
                    methodTemplate=[methodTemplate stringByReplacingOccurrencesOfString:@"{RESULT}" withString:result];
                    methodTemplate=[methodTemplate stringByReplacingOccurrencesOfString:@"{CLASSNAME}" withString:className];
                     methodTemplate=[methodTemplate stringByReplacingOccurrencesOfString:@"{CLASSTYPE}" withString:classType];
                    if ([classType isEqualToString:@"JSONObject"]) {
                        methodTemplate=[methodTemplate stringByReplacingOccurrencesOfString:@"modelsOfClass" withString:@"modelOfClass"];
                    }
                    methodImplementation=[methodImplementation stringByAppendingString:methodTemplate];

                }
            }
            NSString *file=[folder stringByAppendingString:enModuleName];
            NSError *error;
            serviceInterfaceTemplate= [serviceInterfaceTemplate stringByReplacingOccurrencesOfString:@"{CLASSPREFIX}" withString:classPrefix];
            serviceInterfaceTemplate= [serviceInterfaceTemplate stringByReplacingOccurrencesOfString:@"{CLASSNAME}" withString:enModuleName];
            serviceInterfaceTemplate= [serviceInterfaceTemplate stringByReplacingOccurrencesOfString:@"{FORWARD_DECLARATION}" withString:importString];
            serviceInterfaceTemplate= [serviceInterfaceTemplate stringByReplacingOccurrencesOfString:@"{METHOD_DECLARATION}" withString:methodDeclation];
            serviceInterfaceTemplate=[serviceInterfaceTemplate stringByReplacingOccurrencesOfString:@"__NAME__" withString:author];
            serviceInterfaceTemplate=[serviceInterfaceTemplate stringByReplacingOccurrencesOfString:@"__DATE__" withString:[self getCurrentTime]];
            [serviceInterfaceTemplate writeToFile:[file stringByAppendingString:@".h"] atomically:YES encoding:NSUTF8StringEncoding error:&error];
            

            
            serviceImplementationTemplate= [serviceImplementationTemplate stringByReplacingOccurrencesOfString:@"{CLASSNAME}" withString:enModuleName];
            serviceImplementationTemplate=[serviceImplementationTemplate stringByReplacingOccurrencesOfString:@"__NAME__" withString:author];
            serviceImplementationTemplate=[serviceImplementationTemplate stringByReplacingOccurrencesOfString:@"__DATE__" withString:[self getCurrentTime]];

            serviceImplementationTemplate= [serviceImplementationTemplate stringByReplacingOccurrencesOfString:@"{METHOD_DECLARATION}" withString:methodImplementation];
            [serviceImplementationTemplate writeToFile:[file stringByAppendingString:@".m"] atomically:YES encoding:NSUTF8StringEncoding error:&error];
            
        } failure:^(NSError *error) {
            
        }];
    }
}


//循环遍历Parameter生成model
+(void)recursionParameterList:(NSString *)modelInterfaceTemplate modelImplementationTemplate:(NSString *)modelImplementationTemplate nsValueTransformerTemplate:(NSString *)nsValueTransformerTemplate parameterClassList:(NSMutableArray<ParameterClass *>  *)responseParameterList classPrefix:(NSString *)classPrefix folder:(NSString *)folder className:(NSString *)className author:(NSString *)author{
    NSString *importString=[NSString stringWithFormat:@"#import \"%@.h\"\n",className];
    NSString *propertyString=@"";
    NSString *methodString=@"";
    for (ParameterClass *parameterClass in responseParameterList) {
        NSString *dataType=parameterClass.dataType;
        NSString *identifier=parameterClass.identifier;
        if ([dataType isEqualToString:@"object"]) {//对象
            NSString *modelName=[self capitalizedString:identifier];
            modelName=[classPrefix stringByAppendingString:modelName];
            NSString *import=[NSString stringWithFormat:@"#import \"%@.h\"\n",modelName];
           importString= [importString stringByAppendingString:import];
            NSString *property=[NSString stringWithFormat:@"@property(nonatomic,strong)%@ *%@;\n",modelName,identifier];
            propertyString=[propertyString stringByAppendingString:property];
            [self recursionParameterList:modelInterfaceTemplate modelImplementationTemplate:modelImplementationTemplate nsValueTransformerTemplate:nsValueTransformerTemplate parameterClassList:parameterClass.parameterList classPrefix:classPrefix folder:folder className:modelName author:author];
        }else if([dataType hasPrefix:@"array"]){//数组类型
            if (parameterClass.parameterList.count>0) {//数据为 array<object>
                NSString *methodTemplate=[nsValueTransformerTemplate copy];
                NSString *modelName=[identifier copy];
                modelName=[modelName componentsSeparatedByString:@"|"][0];
                if ([modelName isEqualToString:@"items"]) {
                    modelName=[className stringByAppendingString:@"Item"];
                }
                if (modelName.length>1&&[[modelName substringFromIndex:modelName.length-1] isEqualToString:@"s"]) {
                    modelName=[modelName substringToIndex:modelName.length-1];
                }
                modelName=[self capitalizedString:modelName];
                if (![modelName hasPrefix:classPrefix]) {
                    modelName=[classPrefix stringByAppendingString:modelName];
                }
                NSString *import=[NSString stringWithFormat:@"#import \"%@.h\"\n",modelName];
                importString=[importString stringByAppendingString:import];
                NSString *property=[NSString stringWithFormat:@"@property(nonatomic,strong)NSArray<%@*> *%@;\n",modelName,[identifier componentsSeparatedByString:@"|"][0]];
                propertyString= [propertyString stringByAppendingString:property];
                methodTemplate=[methodTemplate stringByReplacingOccurrencesOfString:@"{PROPERTIES}" withString:[identifier componentsSeparatedByString:@"|"][0]];
                methodTemplate=[methodTemplate stringByReplacingOccurrencesOfString:@"{CLASSNAME}" withString:modelName];
                methodString=[[methodString stringByAppendingString:methodTemplate]stringByAppendingString:@"\n"];
                [self recursionParameterList:modelInterfaceTemplate modelImplementationTemplate:modelImplementationTemplate nsValueTransformerTemplate:nsValueTransformerTemplate parameterClassList:parameterClass.parameterList classPrefix:classPrefix folder:folder className:modelName author:author];
            }else{
                NSString *property=@"";
                if([dataType isEqualToString:@"array<string>"]){
                    property=[NSString stringWithFormat:@"@property(nonatomic,strong)NSArray<NSString *> *%@;\n",identifier];
                }else if([dataType isEqualToString:@"array<number>"]){
                    property=[NSString stringWithFormat:@"@property(nonatomic,strong)NSArray<NSNumber *> *%@;\n",identifier];
                }else if([dataType isEqualToString:@"array<boolean>"]){
                    property=[NSString stringWithFormat:@"@property(nonatomic,strong)NSArray<BOOL> *%@;\n",identifier];
                }
               propertyString= [propertyString stringByAppendingString:property];
            }
        }else if([dataType isEqualToString:@"boolean"]){//bool类型
            if([identifier isEqualToString:@"default"]){
                NSString *property=[NSString stringWithFormat:@"@property(nonatomic,assign)BOOL %@;\n",@"_default"];
                propertyString= [propertyString stringByAppendingString:property];
            }else{
                NSString *property=[NSString stringWithFormat:@"@property(nonatomic,assign)BOOL %@;\n",identifier];
                propertyString= [propertyString stringByAppendingString:property];
            }
        }else if([dataType isEqualToString:@"number"]){//整形
            NSString *property=[NSString stringWithFormat:@"@property(nonatomic,strong)NSNumber *%@;\n",identifier];
            propertyString=[propertyString stringByAppendingString:property];
        }else{//字符串
            if([identifier isEqualToString:@"description"]){
                NSString *property=[NSString stringWithFormat:@"@property(nonatomic,strong)NSString *%@;\n",@"_description"];
                propertyString= [propertyString stringByAppendingString:property];
            }else{
                NSString *property=[NSString stringWithFormat:@"@property(nonatomic,strong)NSString *%@;\n",identifier];
                propertyString= [propertyString stringByAppendingString:property];

            }
        }
        
    }
    NSError *error;
    modelInterfaceTemplate=[modelInterfaceTemplate stringByReplacingOccurrencesOfString:@"{FORWARD_DECLARATION}" withString:importString];
    modelInterfaceTemplate=[modelInterfaceTemplate stringByReplacingOccurrencesOfString:@"{PROPERTIES}" withString:propertyString];
    modelInterfaceTemplate=[modelInterfaceTemplate stringByReplacingOccurrencesOfString:@"{CLASSNAME}" withString:className];
    modelInterfaceTemplate=[modelInterfaceTemplate stringByReplacingOccurrencesOfString:@"__NAME__" withString:author];
    modelInterfaceTemplate=[modelInterfaceTemplate stringByReplacingOccurrencesOfString:@"__DATE__" withString:[self getCurrentTime]];

    [modelInterfaceTemplate writeToFile:[[folder stringByAppendingString:className] stringByAppendingString:@".h"] atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    modelImplementationTemplate=[modelImplementationTemplate stringByReplacingOccurrencesOfString:@"{CLASSNAME}" withString:className];
    modelImplementationTemplate=[modelImplementationTemplate stringByReplacingOccurrencesOfString:@"{METHOD_DECLARATION}" withString:methodString];
    modelImplementationTemplate=[modelImplementationTemplate stringByReplacingOccurrencesOfString:@"__NAME__" withString:author];
    modelImplementationTemplate=[modelImplementationTemplate stringByReplacingOccurrencesOfString:@"__DATE__" withString:[self getCurrentTime]];
     [modelImplementationTemplate writeToFile:[[folder stringByAppendingString:className] stringByAppendingString:@".m"] atomically:YES encoding:NSUTF8StringEncoding error:&error];
}

//去下划线 并把下划线的首字母改为大写
+(NSString *)capitalizedString:(NSString *)string{
    if ([string containsString:@"_"]) {
        NSArray<NSString *> *array = [string componentsSeparatedByString:@"_"];
        NSString *modelName=@"";
        for (NSString *item in array) {
            modelName=[modelName stringByAppendingString:[item capitalizedString]];
        }
        return modelName;
    }
    return  string;
}

//截取俩个字符中间的字段
+(NSString *)captureString:(NSString *)string  start:(NSString *)start end:(NSString *)end{
    if ([string containsString:start]&&[string containsString:end]) {
        NSRange startRange = [string rangeOfString:start];
        NSRange endRange = [string rangeOfString:end];
       if (endRange.location - startRange.location - startRange.length>startRange.location + startRange.length) {
           NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
           NSString *result = [string substringWithRange:range];
           return result;
        }
    }
    return string;
}

//根据接口类型获取方法模板
+(NSString *)getMethodTemplate:(NSInteger)requestType{
    NSString *methodTemplate=@"";
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *deleteMethodTemplateFile = [mainBundle pathForResource:@"DeleteMethodTemplate" ofType:@"txt"];
    NSString *deleteMethodTemplate = [[NSString alloc] initWithContentsOfFile:deleteMethodTemplateFile
                                                                     encoding:NSUTF8StringEncoding
                                                                        error:nil];
    NSString *getMethodTemplateFile = [mainBundle pathForResource:@"GetMethodTemplate" ofType:@"txt"];
    NSString *getMethodTemplate = [[NSString alloc] initWithContentsOfFile:getMethodTemplateFile
                                                                  encoding:NSUTF8StringEncoding
                                                                     error:nil];
    NSString *postMethodTemplateFile = [mainBundle pathForResource:@"PostMethodTemplate" ofType:@"txt"];
    NSString *postMethodTemplate = [[NSString alloc] initWithContentsOfFile:postMethodTemplateFile
                                                                   encoding:NSUTF8StringEncoding
                                                                      error:nil];
    
    NSString *putMethodTemplateFile = [mainBundle pathForResource:@"PutMethodTemplate" ofType:@"txt"];
    NSString *putMethodTemplate = [[NSString alloc] initWithContentsOfFile:putMethodTemplateFile
                                                                  encoding:NSUTF8StringEncoding
                                                                     error:nil];
    switch (requestType) {
        case 1:
            methodTemplate=getMethodTemplate;
            break;
        case 2:
            methodTemplate=postMethodTemplate;
            break;
            
        case 3:
            methodTemplate=putMethodTemplate;
            break;
            
        case 4:
            methodTemplate=deleteMethodTemplate;
            break;
        default:
            methodTemplate=getMethodTemplate;
            break;
    }
    return methodTemplate;

}

//根据类型获取不同的字符
+(NSString *)getRequestType:(NSInteger)requestType{
    NSString *type;
    switch (requestType) {
        case 1:
            type=@"Get";
            break;
        case 2:
            type=@"Post";
            break;
        case 3:
            type=@"PutBy";
            break;
        case 4:
            type=@"DeleteBy";
            break;

        default:
            type=@"Get";
            break;
    }
    return type;
}

+(NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

    
+(NSString *)encoded:(NSString *)urlString{
    NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)urlString,NULL,NULL,kCFStringEncodingUTF8));
    return encodedString;
}
@end
