//
//  HybridNavigatorForNative.m
//  Runner
//
//  Created by 苏冠超 on 2019/1/10.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "CSHybridNavigatorForNative.h"
#import "CSFlutterViewController.h"
#import "CSFlutterWrapperViewController.h"
#import "CSDemoViewController.h"

@interface CSHybridNavigatorForNative()
@property (nonatomic,strong) NSObject<FlutterPluginRegistrar>* registrar;
@end

@implementation CSHybridNavigatorForNative

+ (instancetype)sharedInstance{
    static CSHybridNavigatorForNative * sharedInst;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInst = [[CSHybridNavigatorForNative alloc] init];
    });
    return sharedInst;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar{
    CSHybridNavigatorForNative* instance = [CSHybridNavigatorForNative sharedInstance];
    instance.methodChannel = [FlutterMethodChannel
                                     methodChannelWithName:@"cs_hybrid_router"
                                     binaryMessenger:[registrar messenger]];
    [registrar addMethodCallDelegate:instance channel:instance.methodChannel];
    instance.registrar = registrar;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    UINavigationController *nav = nil;
    if (!nav)
    {
        if ([((UINavigationController *)[UIApplication sharedApplication].delegate.window.rootViewController) isKindOfClass:[UINavigationController class]])
        {
            nav = (UINavigationController *)[UIApplication sharedApplication].delegate.window.rootViewController;
        }
    }
    if ([call.method isEqualToString:@"pushVcWithUrlForNative"])
    {
        NSDictionary *params = call.arguments[@"params"];
        NSString *name = call.arguments[@"name"];

        if ([params[@"isFlutter"] isEqualToString:@"isFlutter"] && name.length > 0)
        {
            [CSHybridNavigatorForNative pushToWrapperViewController:name];
        }
        else
        {
            if (name.length >0)
            {
                //TODO:设置接口给外面使用
                UINavigationController *nav = (UINavigationController*)[UIApplication sharedApplication].delegate.window.rootViewController;
                CSDemoViewController *vc = [[CSDemoViewController alloc] init];
                [nav pushViewController:vc animated:YES];
            }
        }
    }
    else if ([call.method isEqualToString:@"setFlutterVcName"])
    {
        NSString *curRouteName = call.arguments;
        UIViewController *viewController = nav.topViewController;
        if ([viewController isKindOfClass:[CSFlutterWrapperViewController class]])
        {
            ((CSFlutterWrapperViewController *)viewController).flutterRouterName = curRouteName;
        }
    }
    else if ([call.method isEqualToString:@"popVc"])
    {
        UINavigationController *nav = (UINavigationController*)[UIApplication sharedApplication].delegate.window.rootViewController;
        if([nav.topViewController isKindOfClass:[CSFlutterWrapperViewController class]]){
            [nav popViewControllerAnimated:YES];
        }
    }
    else
    {
        result(FlutterMethodNotImplemented);
    }
}

+ (void)pushToWrapperViewController:(NSString *)vcName
{
    UINavigationController *currentNavigation = (UINavigationController*)[UIApplication sharedApplication].delegate.window.rootViewController;
    CSFlutterWrapperViewController* viewController = [[CSFlutterWrapperViewController alloc] init];
    viewController.pushViewWillAppearBlock = ^BOOL{
        [[CSHybridNavigatorForNative sharedInstance].methodChannel invokeMethod:@"pushVcWithUrlForFlutter" arguments:@{@"pageName" : vcName} result:^(id  _Nullable result) {
        }];
        return YES;
    };
    [currentNavigation pushViewController:viewController animated:YES];
}
@end
