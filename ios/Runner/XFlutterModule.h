//
//  XFlutterModule.h
//  FleaMarket
//
//  Created by 正物 on 2018/03/08.
//  Copyright © 2017 正物. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "CSFlutterWrapperViewController.h"
#import "CSFlutterViewController.h"

@interface XFlutterModule : NSObject
+ (instancetype)new __attribute__((unavailable("Must use sharedInstance instead.")));
- (instancetype)init __attribute__((unavailable("Must use sharedInstance instead.")));
+ (instancetype)sharedInstance;
@property (nonatomic,assign) BOOL isInFlutterRootPage;
@property (nonatomic,strong) CSFlutterViewController *flutterVC;
- (void)openURL:(NSString *)aUrl query:(NSDictionary *)query params:(NSDictionary *)params;
- (void)warmupFlutter;
@end
