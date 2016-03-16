//
//  TableViewController.m
//  SWRefresh
//
//  Created by SolaWing on 16/1/4.
//  Copyright © 2016年 SW. All rights reserved.
//

#import "TableViewController.h"
#import "UIScrollView+SWRefresh.h"
#import "SWRefreshHeaderView.h"
#import "SWRefreshFooterView.h"

@interface TableViewController () 
{
}

@property (nonatomic, strong) NSMutableArray* dataSource;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [NSMutableArray new];
    for (int i = 0; i < 1; ++i) {
        [_dataSource addObject:[NSString stringWithFormat:@"%@", [NSDate date]]];
    }
    // Do any additional setup after loading the view, typically from a nib.
    UITableView* tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.dataSource = (id)self;
    tableView.delegate = (id)self;
    [self.view addSubview:tableView];

    __weak typeof(self) weak_self = self;
    __weak typeof(tableView) weak_tableView = tableView;
    id block =^(void){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2* NSEC_PER_SEC),
            dispatch_get_main_queue(), ^{
                for (int i = 0; i < 3; ++i) {
                    [weak_self.dataSource addObject:[NSDate date].description];
                }
                [weak_tableView.refreshHeaderModel endRefreshing:YES];
                [weak_tableView reloadData];
        });
    };
    tableView.refreshHeader = [SWRefreshHeaderView headerWithRefreshingBlock:block];
    block =^(void){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2* NSEC_PER_SEC),
            dispatch_get_main_queue(), ^{
                for (int i = 0; i < 3; ++i) {
                    [weak_self.dataSource addObject:[NSDate date].description];
                }
                [weak_tableView reloadData];
                if (weak_self.dataSource.count > 20){
                    [weak_tableView.refreshFooterModel endRefreshingWithNoMoreData:YES];
                } else {
                    [weak_tableView.refreshFooterModel endRefreshing:YES];
                }
        });
    };
    tableView.refreshFooter = [SWRefreshFooterView footerWithRefreshingBlock:block];

    tableView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
    tableView.refreshHeader.headerOffset = 50;
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

@end
