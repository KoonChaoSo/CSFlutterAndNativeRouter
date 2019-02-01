//
//  CSFlutterWrapperViewController.h
//  Runner
//
//  Created by 苏冠超 on 2019/1/9.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSFlutterViewController;
typedef BOOL (^FlutterViewPushWillAppearBlock) (void);
typedef BOOL (^FlutterViewDidDisAppearBlock) (void);

@interface CSFlutterWrapperViewController : UIViewController
@property(nonatomic,copy) FlutterViewPushWillAppearBlock pushViewWillAppearBlock;
//暂时没用
@property(nonatomic,copy) FlutterViewDidDisAppearBlock viewDidDisAppearBlock;

//这个是为了设置对应于Flutter单例里面的页面的一个key
@property (nonatomic, strong) NSString *flutterRouterName;

//外面可以获取到flutter这个单例
+ (CSFlutterViewController *)flutterViewController;
@end

