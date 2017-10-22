//
//  ViewController.m
//  RefreshView
//
//  Created by ileo on 15/6/9.
//  Copyright (c) 2015年 ileo. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+Load.h"
#import "LMView.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, LoadControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger num;
@property (nonatomic, assign) NSInteger firnum;

@end

@implementation ViewController

-(void)dealloc{
//    self.tableView.loadController = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.num = 10;
    self.firnum = 10;
    self.view.backgroundColor = [UIColor yellowColor];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.tableView];
    self.tableView.contentInset = UIEdgeInsetsMake(50, 0, 100, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView reloadData];
    
    [self.tableView setLoadDelegate:self];
    
//    [self.tableView setLoadTopView:[self createLoadViewX]];
    [self.tableView setLoadBottomView:[self createLoadViewX]];
//    self.tableView.loadController.canAutoLoadTop = NO;
//    self.load.canAutoLoadTop = NO;
//    [self.load showLoadTop];
//    self.load.loadTopView = nil;
//    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(endLoading) userInfo:nil repeats:NO];

    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)click{
    
    ViewController *vc = [[ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(LMView *)createLoadViewX{
    LMView *topV = [[LMView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    topV.backgroundColor = [UIColor redColor];
    topV.tipsLoading = @"加载中";
    topV.tipsLoadingDone = @"加载完成";
    topV.tipsPulling = @"下拉加载";
    topV.tipsShouldLoad = @"松手加载";
    topV.autoHideTips = YES;
    topV.canAutoLoad = YES;
    return topV;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)endLoading{
    [self.tableView.loadController disappearLoadBottom];
}

#pragma mark - load

-(void)loadBottomFinish:(void (^)())finish withScrollView:(UIScrollView *)scrollView{
    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(loadFinish:) userInfo:@{@"finish":finish} repeats:NO];
}

-(void)loadTopFinish:(void (^)(CGFloat))finish withScrollView:(UIScrollView *)scrollView{
//    self.num += 10;
//    self.firnum -= 10;
    [self.tableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (finish) {
            finish(0);
        }
    });

//    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(loadFinish:) userInfo:@{@"finish":finish} repeats:NO];
}
//-(void)loadBottomAutoLoadFinish:(void (^)())finish{
//    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(loadFinishAuto:) userInfo:@{@"finish":finish} repeats:NO];
//}
//
//-(void)loadBottomLoadFinish:(void (^)())finish{
//    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(loadFinish:) userInfo:@{@"finish":finish} repeats:NO];
//}

//-(void)loadTopAutoLoadFinish:(void (^)(CGFloat))finish{
//    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(loadFinishAuto:) userInfo:@{@"finish":finish} repeats:NO];
//}

//-(void)loadTopLoadFinish:(void (^)(CGFloat))finish{
//    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(loadFinish:) userInfo:@{@"finish":finish} repeats:NO];
//}
//
//-(void)loadFinishAuto:(id)info{
//    void (^finish)(CGFloat) = ((NSTimer *)info).userInfo[@"finish"];
//
//    if (self.num > 7) {
//        self.loadMore.canAutoLoadBottom = NO;
//        if (finish) {
//            finish(0);
//        }
//        return;
//    }
//    self.num++;
//    [self.tableView reloadData];
//    if (finish) {
//        finish(0);
//    }
//}
//
-(void)loadFinish:(id)info{
    void (^finish)(CGFloat) = ((NSTimer *)info).userInfo[@"finish"];
    self.num++;
    [self.tableView reloadData];
    
    if (finish) {
        finish(0);
    }
}

#pragma mark - tableView

//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return self.num;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 50;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.num;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%zd",indexPath.row + self.firnum];
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"%zd",section];
}

@end
