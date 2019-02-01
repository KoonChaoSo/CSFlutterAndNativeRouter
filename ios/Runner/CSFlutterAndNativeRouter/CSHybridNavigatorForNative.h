//
//  HybridNavigatorForNative.h
//  Runner
//
//  Created by 苏冠超 on 2019/1/10.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

@interface CSHybridNavigatorForNative : NSObject<FlutterPlugin>

//持有一个与Flutter通讯的通道
@property (nonatomic,strong) FlutterMethodChannel* methodChannel;

//该路由需要用到单例
+ (instancetype)sharedInstance;
//原生注册
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar;

//跳转一个包含Flutter单例的页面
+ (void)pushToWrapperViewController:(NSString *)vcName;
@end
