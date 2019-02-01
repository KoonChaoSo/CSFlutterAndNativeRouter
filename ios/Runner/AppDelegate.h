//
//  AppDelegate.h
//  TestHybridRouter
//
//  Created by 苏冠超 on 2019/1/10.
//  Copyright © 2019 苏冠超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>

@class CSFlutterViewController;
@interface AppDelegate : FlutterAppDelegate <UIApplicationDelegate,FlutterAppLifeCycleProvider,FlutterStreamHandler,FlutterBinaryMessenger>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic, strong) CSFlutterViewController *rootController;
@property(readonly, nonatomic) NSMutableArray* pluginDelegates;
@property(readonly, nonatomic) NSMutableDictionary* pluginPublications;
@end

@interface DemoFlutterAppDelegateRegistrar : NSObject<FlutterPluginRegistrar>
- (instancetype)initWithPlugin:(NSString*)pluginKey appDelegate:(AppDelegate*)delegate;
@end

