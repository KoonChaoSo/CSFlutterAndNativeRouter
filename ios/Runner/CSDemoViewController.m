//
//  CSDemoViewController.m
//  TestHybridRouter
//
//  Created by 苏冠超 on 2019/1/11.
//  Copyright © 2019 苏冠超. All rights reserved.
//

#import "CSDemoViewController.h"
#import "CSFlutterWrapperViewController.h"
#import "CSHybridNavigatorForNative.h"

static NSInteger sNativeVCIdx = 0;
@interface CSDemoViewController ()

@end

@implementation CSDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sNativeVCIdx++;
    NSString *title = [NSString stringWithFormat:@"Native demo page(%ld)",(long)sNativeVCIdx];
    self.title = title;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)loadView{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [view setBackgroundColor:[UIColor whiteColor]];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [btn setTitle:@"Click to jump Native" forState:UIControlStateNormal];
    [view addSubview:btn];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setCenter:CGPointMake(view.center.x, view.center.y-50)];
    [btn addTarget:self action:@selector(onJumpNativePressed) forControlEvents:UIControlEventTouchUpInside];
    
    btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [btn setTitle:@"Click to jump Flutter" forState:UIControlStateNormal];
    [view addSubview:btn];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setCenter:CGPointMake(view.center.x, view.center.y+50)];
    [btn addTarget:self action:@selector(onJumpFlutterPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.view = view;
}

- (void)onJumpNativePressed{
    CSDemoViewController *demo = [[CSDemoViewController alloc] init];
    [self.navigationController pushViewController:demo animated:YES];
}

- (void)onJumpFlutterPressed{
    [CSHybridNavigatorForNative pushToWrapperViewController:@"Test1"];
}
@end
