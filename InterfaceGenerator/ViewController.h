//
//  ViewController.h
//  InterfaceGenerator
//
//  Created by 邵存将 on 17/7/19.
//  Copyright © 2017年 scj. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController<NSOpenSavePanelDelegate>{
    IBOutlet NSTextField *project;
    IBOutlet NSTextField *classPrefix;
    IBOutlet NSTextField *author;
}

//    @property (strong) IBOutlet NSWindow *mainWindow;



@end

