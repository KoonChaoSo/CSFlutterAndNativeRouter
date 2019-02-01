//
//  CSNativeAndFlutterRouterPlugin.m
//  Runner
//
//  Created by 苏冠超 on 2019/1/29.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "CSNativeAndFlutterRouterPlugin.h"
#import "CSHybridNavigatorForNative.h"
@implementation CSNativeAndFlutterRouterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar{
    [CSHybridNavigatorForNative registerWithRegistrar:registrar];
}
@end
