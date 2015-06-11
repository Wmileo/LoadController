//
//  ViewController.m
//  RefreshView
//
//  Created by ileo on 15/6/9.
//  Copyright (c) 2015年 ileo. All rights reserved.
//

#import "ViewController.h"
#import "LoadMoreController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, LoadMoreControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) LoadMoreController *loadMore;

@property (nonatomic, assign) NSInteger num;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.num = 3;
    self.view.backgroundColor = [UIColor yellowColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, 320, 400)];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
    
    self.loadMore = [[LoadMoreController alloc] initWithScrollView:self.tableView];
    self.loadMore.delegate = self;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -40, 320, 40)];
    view.backgroundColor = [UIColor lightGrayColor];

//    self.loadMore.loadBottomView = view;
    self.loadMore.loadTopView = view;
    self.loadMore.canAutoLoadTop = NO;
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
    [self.loadMore showLoadTop];
}

#pragma mark - loadMore

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

-(void)loadMoreTopLoadFinish:(void (^)(CGFloat))finish{
    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(loadFinish:) userInfo:@{@"finish":finish} repeats:NO];
}
//
-(void)loadFinishAuto:(id)info{
    void (^finish)(CGFloat) = ((NSTimer *)info).userInfo[@"finish"];

    if (self.num > 7) {
        self.loadMore.canAutoLoadBottom = NO;
        if (finish) {
            finish(0);
        }
        return;
    }
    self.num++;
    [self.tableView reloadData];
    [self.loadMore repositionLoadBottomView];
    if (finish) {
        finish(0);
    }
}
//
-(void)loadFinish:(id)info{
    void (^finish)(CGFloat) = ((NSTimer *)info).userInfo[@"finish"];
    self.num++;
    [self.tableView reloadData];
//    [self.loadMore repositionLoadBottomView];
    
    if (finish) {
        finish(0);
    }
}

#pragma mark - scroll

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.loadMore scrollViewDidEndDragging:scrollView];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.loadMore scrollViewDidScroll:scrollView];
}

#pragma mark - tableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.num;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%zd",indexPath.section];
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"%zd",section];
}

@end
