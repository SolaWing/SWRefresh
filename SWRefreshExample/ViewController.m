//
//  ViewController.m
//  SWRefreshExample
//
//  Created by SolaWing on 15/12/31.
//  Copyright © 2015年 SW. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+SWRefresh.h"
#import "SWRefresh.h"
#import "SWRefreshHeaderView.h"
#import "SWRefreshFooterView.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray* dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [NSMutableArray new];
    for (int i = 0; i < 5; ++i) {
        [_dataSource addObject:[NSString stringWithFormat:@"%@", [NSDate date]]];
    }
    self.automaticallyAdjustsScrollViewInsets = YES;

    [UIScrollView registerDefaultHeaderView:[SWRefreshHeaderView class] andModel:[SWRefreshHeaderViewModel class]];
    [UIScrollView registerDefaultFooterView:[SWRefreshFooterView class] andModel:[SWRefreshFooterViewModel class]];
    // Do any additional setup after loading the view, typically from a nib.
    UITableView* tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];

    __weak typeof(self) weak_self = self;
    __weak typeof(tableView) weak_tableView = tableView;
    id block =^(void){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2* NSEC_PER_SEC),
            dispatch_get_main_queue(), ^{
                for (int i = 0; i < 3; ++i) {
                    [weak_self.dataSource addObject:[NSDate date].description];
                }
                [weak_tableView reloadData];
                [weak_tableView.refreshHeader endRefreshing:YES];
        });
    };
    [tableView refreshHeader:block];
    block =^(void){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2* NSEC_PER_SEC),
            dispatch_get_main_queue(), ^{
                for (int i = 0; i < 3; ++i) {
                    [weak_self.dataSource addObject:[NSDate date].description];
                }
                [weak_tableView reloadData];
                if (weak_self.dataSource.count > 20){
                    [weak_tableView.refreshFooter endRefreshingWithNoMoreData:YES];
                } else {
                    [weak_tableView.refreshFooter endRefreshing:YES];
                }
        });
    };
    [tableView refreshFooter:block];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {return 1;}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
#define CellIdentifier @"cell"
    UITableViewCell* cell =
        [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = _dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
