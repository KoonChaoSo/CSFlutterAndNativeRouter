//
//  CSFlutterWrapperViewController.m
//  Runner
//
//  Created by 苏冠超 on 2019/1/9.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "CSFlutterWrapperViewController.h"
#import "CSFlutterViewController.h"
#import "CSHybridNavigatorForNative.h"

@interface CSFlutterWrapperViewController ()

@property (assign,nonatomic) BOOL isPushViewController;
@property (assign,nonatomic) BOOL isPopVc;

@end

@implementation CSFlutterWrapperViewController

- (void)dealloc
{
    NSLog(@"dealloc ===== ");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isPushViewController = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.pushViewWillAppearBlock)
    {
        self.isPushViewController = !self.pushViewWillAppearBlock();
        self.pushViewWillAppearBlock = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[CSFlutterWrapperViewController flutterViewController].view setUserInteractionEnabled:YES];
    [self addFlutterViewControllerChildren];
    if (self.flutterRouterName.length > 0)
    {
        FlutterMethodChannel *methodChannel = [CSHybridNavigatorForNative sharedInstance].methodChannel;
        [methodChannel invokeMethod:@"popToVc" arguments:@{@"pageName":self.flutterRouterName}];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[CSFlutterWrapperViewController flutterViewController].view setUserInteractionEnabled:NO];
    NSArray *viewControllers = self.navigationController.viewControllers;//获取当前的视图控制其
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
        //push
        self.isPopVc = NO;
        
    } else if ([viewControllers indexOfObject:self] == NSNotFound) {
        //当前视图控制器不在栈中，故为pop操作
        //pop
        self.isPopVc = YES;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (self.viewDidDisAppearBlock)
    {
        self.viewDidDisAppearBlock();
    }
    
    UINavigationController *rootNav = (UINavigationController*)[UIApplication sharedApplication].delegate.window.rootViewController;
    NSArray *ary = [rootNav.viewControllers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        if([evaluatedObject isKindOfClass:[CSFlutterWrapperViewController class]])
            return TRUE;
        return FALSE;
    }]];
    
    if(!ary.count){
        [[CSHybridNavigatorForNative sharedInstance].methodChannel invokeMethod:@"popToRoot" arguments:nil];
    }
    NSArray *curStackAry = rootNav.viewControllers;
    NSInteger idx = [curStackAry indexOfObject:self];
    if(idx == NSNotFound){
        //TODO:去到对应的页面，0.6版本暂时没有对应功能
    }
    [self removeFlutterViewControllerChildren];
}

//add到当前的VC
- (void)addFlutterViewControllerChildren
{
    CSFlutterViewController *vc = [CSFlutterWrapperViewController flutterViewController];
    [vc.view setFrame:[UIScreen mainScreen].bounds];
    UIView *view = vc.view;
    [self.view addSubview:view];
    [self addChildViewController:vc];
}

//去掉vc
- (void)removeFlutterViewControllerChildren
{
    CSFlutterViewController *vc = [CSFlutterWrapperViewController flutterViewController];
    [vc removeFromParentViewController];
    [vc.view removeFromSuperview];
}

//所有对象只使用一个实例
//使用单例是因为要节约资源，可以看作CSFlutterViewController为一个App
+ (CSFlutterViewController *)flutterViewController
{
    static CSFlutterViewController *vc;
    static dispatch_once_t onceToken;

    if (vc)
    {
        return vc;
    }
    
    dispatch_once(&onceToken, ^{
        vc = [[CSFlutterViewController alloc] initWithProject:nil nibName:nil bundle:nil];
    });
    return vc;
}
@end
