//
//  CSRootViewController.m
//  TestHybridRouter
//
//  Created by 苏冠超 on 2019/1/11.
//  Copyright © 2019 苏冠超. All rights reserved.
//

#import "CSRootViewController.h"
#import "CSDemoViewController.h"
#import "CSFlutterWrapperViewController.h"
#import "CSFlutterViewController.h"
#import "CSHybridNavigatorForNative.h"

@interface CSRootViewController ()<FlutterStreamHandler>
@property (strong,nonatomic)FlutterEventChannel *eventChannel;
@end

@implementation CSRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadView{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [view setBackgroundColor:[UIColor whiteColor]];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [btn setTitle:@"Click to jump Flutter" forState:UIControlStateNormal];
    [view addSubview:btn];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setCenter:view.center];
    [btn addTarget:self action:@selector(onJumpFlutterPressed) forControlEvents:UIControlEventTouchUpInside];
    self.view = view;
}

- (void)onJumpFlutterPressed{

    [CSHybridNavigatorForNative pushToWrapperViewController:@"Test1"];
}

- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments
                                       eventSink:(FlutterEventSink)events {
    
    // arguments flutter给native的参数
    // 回调给flutter， 建议使用实例指向，因为该block可以使用多次
    if (events) {
        events(@"我是标题");
    }
    return nil;
}

/// flutter不再接收
- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    // arguments flutter给native的参数
    return nil;
}

@end
