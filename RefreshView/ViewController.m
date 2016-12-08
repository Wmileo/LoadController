//
//  ViewController.m
//  RefreshView
//
//  Created by ileo on 15/6/9.
//  Copyright (c) 2015年 ileo. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+LoadMore.h"
#import "LMView.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, LoadMoreControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger num;
@property (nonatomic, assign) NSInteger firnum;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.num = 100;
    self.firnum = 50;
    self.view.backgroundColor = [UIColor yellowColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, 320, 400)];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
    
    [self.tableView setLoadMoreDelegate:self];
    
//    self.loadMore.loadBottomView = view;
    LMView *topV = [[LMView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    topV.tipsLoading = @"加载中";
    topV.tipsLoadingDone = @"加载完成";
    topV.tipsPulling = @"下拉加载";
    topV.tipsShouldLoad = @"松手加载";
    topV.autoHideTips = YES;
    topV.canAutoLoad = YES;
    
    [self.tableView setLoadMoreTopView:topV];
//    self.tableView.loadMoreController.canAutoLoadTop = NO;
//    self.loadMore.canAutoLoadTop = NO;
//    [self.loadMore showLoadTop];
//    self.loadMore.loadTopView = nil;
//    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(endLoading) userInfo:nil repeats:NO];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)endLoading{
    [self.tableView.loadMoreController disappearLoadBottom];
}

#pragma mark - loadMore

-(void)loadMoreBottomFinish:(void (^)())finish withScrollView:(UIScrollView *)scrollView{
    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(loadFinish:) userInfo:@{@"finish":finish} repeats:NO];
}

-(void)loadMoreTopFinish:(void (^)(CGFloat))finish withScrollView:(UIScrollView *)scrollView{
    self.num += 50;
    self.firnum -= 50;
    [self.tableView reloadData];
    
    if (finish) {
        finish(50);
    }
//    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(loadFinish:) userInfo:@{@"finish":finish} repeats:NO];
}
//-(void)loadMoreBottomAutoLoadFinish:(void (^)())finish{
//    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(loadFinishAuto:) userInfo:@{@"finish":finish} repeats:NO];
//}
//
//-(void)loadMoreBottomLoadFinish:(void (^)())finish{
//    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(loadFinish:) userInfo:@{@"finish":finish} repeats:NO];
//}

//-(void)loadMoreTopAutoLoadFinish:(void (^)(CGFloat))finish{
//    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(loadFinishAuto:) userInfo:@{@"finish":finish} repeats:NO];
//}

//-(void)loadMoreTopLoadFinish:(void (^)(CGFloat))finish{
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
        finish(50);
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
