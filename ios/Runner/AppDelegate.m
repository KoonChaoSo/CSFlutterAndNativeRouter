//
//  AppDelegate.m
//  TestHybridRouter
//
//  Created by 苏冠超 on 2019/1/10.
//  Copyright © 2019 苏冠超. All rights reserved.
//

#import "AppDelegate.h"
#import "CSRootViewController.h"
#import "CSFlutterWrapperViewController.h"
#import "CSFlutterViewController.h"
#import "CSHybridNavigatorForNative.h"
#import "CSNativeAndFlutterRouterPlugin.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
{
    FlutterPluginAppLifeCycleDelegate *_lifeCycleDelegate;
}

- (instancetype)init {
    if (self = [super init]) {
        _lifeCycleDelegate = [[FlutterPluginAppLifeCycleDelegate alloc] init];
    }
    return self;
}


- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setupNativeOpenUrlHandler];
    UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:[CSRootViewController new]];
//    rootNav.interactivePopGestureRecognizer.delegate = self;
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.rootViewController = rootNav;
    [window makeKeyAndVisible];
    self.window = window;
    
    return [_lifeCycleDelegate application:application didFinishLaunchingWithOptions:launchOptions];
}


- (void)setupNativeOpenUrlHandler{
    [CSNativeAndFlutterRouterPlugin registerWithRegistrar:[self registrarForPlugin:@"FlutterWebviewPlugin"]];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return TRUE;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    [_lifeCycleDelegate applicationWillResignActive:application];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [_lifeCycleDelegate applicationDidEnterBackground:application];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [_lifeCycleDelegate applicationWillEnterForeground:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [_lifeCycleDelegate applicationDidBecomeActive:application];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [_lifeCycleDelegate applicationWillTerminate:application];
}

- (void)addApplicationLifeCycleDelegate:(NSObject<FlutterPlugin>*)delegate {
    [_lifeCycleDelegate addDelegate:delegate];
}


- (NSObject<FlutterBinaryMessenger> *)binaryMessenger
{
    if ([[CSFlutterWrapperViewController flutterViewController] conformsToProtocol:@protocol(FlutterBinaryMessenger)]) {
        return (NSObject<FlutterBinaryMessenger> *)[CSFlutterWrapperViewController flutterViewController];
    }
    return nil;
}

- (NSObject<FlutterTextureRegistry> *)textures
{
    if ([[CSFlutterWrapperViewController flutterViewController] conformsToProtocol:@protocol(FlutterTextureRegistry)]) {
        return (NSObject<FlutterTextureRegistry> *)[CSFlutterWrapperViewController flutterViewController];
    }
    return nil;
}

- (NSObject<FlutterPluginRegistrar>*)registrarForPlugin:(NSString*)pluginKey {
    NSAssert(self.pluginPublications[pluginKey] == nil, @"Duplicate plugin key: %@", pluginKey);
    self.pluginPublications[pluginKey] = [NSNull null];
    return [[DemoFlutterAppDelegateRegistrar alloc] initWithPlugin:pluginKey appDelegate:self];
}

- (BOOL)hasPlugin:(NSString*)pluginKey {
    return _pluginPublications[pluginKey] != nil;
}

- (NSObject*)valuePublishedByPlugin:(NSString*)pluginKey {
    return _pluginPublications[pluginKey];
}
#pragma mark - Flutter

- (FlutterViewController*)rootFlutterViewController {
    UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([viewController isKindOfClass:[FlutterViewController class]]) {
        return (FlutterViewController*)viewController;
    }
    return nil;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    [super touchesBegan:touches withEvent:event];
    
    // Pass status bar taps to key window Flutter rootViewController.
    if (self.rootFlutterViewController != nil) {
        [self.rootFlutterViewController handleStatusBarTouches:event];
    }
}

@end

@interface DemoFlutterAppDelegateRegistrar()

@property(nonatomic, copy) NSString *pluginKey;
@property(nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation DemoFlutterAppDelegateRegistrar
- (instancetype)initWithPlugin:(NSString*)pluginKey appDelegate:(AppDelegate*)appDelegate {
    self = [super init];
    NSAssert(self, @"Super init cannot be nil");
    _pluginKey = [pluginKey copy];
    _appDelegate = appDelegate;
    return self;
}


- (NSObject<FlutterBinaryMessenger>*)messenger {
    return [_appDelegate binaryMessenger];
}

- (NSObject<FlutterTextureRegistry>*)textures {
    return [_appDelegate textures];
}

- (void)publish:(NSObject*)value {
    _appDelegate.pluginPublications[_pluginKey] = value;
}

- (void)addMethodCallDelegate:(NSObject<FlutterPlugin>*)delegate
                      channel:(FlutterMethodChannel*)channel {
    [channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        [delegate handleMethodCall:call result:result];
    }];
}

- (void)addApplicationDelegate:(NSObject<FlutterPlugin>*)delegate {
    [_appDelegate.pluginDelegates addObject:delegate];
}

- (NSString*)lookupKeyForAsset:(NSString*)asset {
    return [FlutterDartProject lookupKeyForAsset:asset];
}

- (NSString*)lookupKeyForAsset:(NSString*)asset fromPackage:(NSString*)package {
    return [FlutterDartProject lookupKeyForAsset:asset fromPackage:package];
}

@end

