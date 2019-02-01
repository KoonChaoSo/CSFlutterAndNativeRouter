//
//  XFlutterModule.m
//  FleaMarket
//
//  Created by 正物 on 2018/03/08.
//  Copyright © 2017 正物. All rights reserved.
//

#import "XFlutterModule.h"
#import "CSHybridNavigatorForNative.h"
//#import <hybrid_stack_manager/HybridStackManager.h>

@interface XFlutterModule()
{
    BOOL _isInFlutterRootPage;
    bool _isFlutterWarmedup;
}
@end

@implementation XFlutterModule
@synthesize isInFlutterRootPage = _isInFlutterRootPage;
#pragma mark - XModuleProtocol
+ (instancetype)sharedInstance{
    static XFlutterModule *sXFlutterModule;
    if(sXFlutterModule)
        return sXFlutterModule;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sXFlutterModule = [[[self class] alloc] initInstance];
        [sXFlutterModule warmupFlutter];
    });
    return sXFlutterModule;
}

- (instancetype)initInstance{
    if(self = [super init]){
        _isInFlutterRootPage = TRUE;
    }
    return self;
}

- (CSFlutterViewController *)flutterVC{
    return [CSFlutterWrapperViewController flutterViewController];
}

- (void)warmupFlutter{
    if(_isFlutterWarmedup)
        return;
    CSFlutterViewController *flutterVC = [CSFlutterWrapperViewController flutterViewController];
    [flutterVC view];
    [NSClassFromString(@"GeneratedPluginRegistrant") performSelector:NSSelectorFromString(@"registerWithRegistry:") withObject:flutterVC];
    _isFlutterWarmedup = true;
}

+ (NSDictionary *)parseParamsKV:(NSString *)aParamsStr{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *kvAry = [aParamsStr componentsSeparatedByString:@"&"];
    for(NSString *kv in kvAry){
        NSArray *ary = [kv componentsSeparatedByString:@"="];
        if (ary.count == 2) {
            NSString *key = ary.firstObject;
            NSString *value = [ary.lastObject stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [dict setValue:value forKey:key];
        }
    }
    return dict;
}

- (void)openURL:(NSString *)aUrl query:(NSDictionary *)query params:(NSDictionary *)params{
    static BOOL sIsFirstPush = TRUE;
    //Process aUrl and Query Stuff.
    NSURL *url = [NSURL URLWithString:aUrl];
    
    NSMutableDictionary *mQuery = [NSMutableDictionary dictionaryWithDictionary:query];
    [mQuery addEntriesFromDictionary:[XFlutterModule parseParamsKV:url.query]];
    NSMutableDictionary *mParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [mParams addEntriesFromDictionary:[XFlutterModule parseParamsKV:url.parameterString]];
    NSString *pageUrl = [NSString stringWithFormat:@"%@://%@",url.scheme,url.host];
    
    FlutterMethodChannel *methodChann = [CSHybridNavigatorForNative sharedInstance].methodChannel;
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setValue:pageUrl forKey:@"url"];
    
    NSMutableDictionary *mutQuery = [NSMutableDictionary dictionary];
    for(NSString *key in query.allKeys){
        id value = [query objectForKey:key];
        //[TODO]: Add customized implementations for non-json-serializable objects into json-serializable ones.
        [mutQuery setValue:value forKey:key];
    }
    [arguments setValue:mutQuery forKey:@"query"];
    
    NSMutableDictionary *mutParams = [NSMutableDictionary dictionary];
    for(NSString *key in mParams.allKeys){
        id value = [mParams objectForKey:key];
        //[TODO]: Add customized implementations for non-json-serializable objects into json-serializable ones.
        [mutParams setValue:value forKey:key];
    }
    [arguments setValue:mutParams forKey:@"params"];
    
    [arguments setValue:@(0) forKey:@"animated"];
    
    //Push
    UINavigationController *currentNavigation = (UINavigationController*)[UIApplication sharedApplication].delegate.window.rootViewController;
    CSFlutterWrapperViewController *viewController = [[CSFlutterWrapperViewController alloc] init];
//    viewController.pushViewWillAppearBlock = ^(){
//        //Process first & later message sending according distinguishly.
//        [methodChann invokeMethod:@"openURLFromFlutter" arguments:arguments result:^(id  _Nullable result) {
//            
//        }];
//    };
    [currentNavigation pushViewController:viewController animated:YES]; 
}

#pragma mark - XFlutterModuleProtocol
@end
