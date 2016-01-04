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
#import "SWRefreshBackFooterViewModel.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableDictionary* dataSource;
@property (nonatomic, strong) NSArray* keys;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [NSMutableDictionary new];
    _dataSource[@"TableView"] = @"TableViewController";

    _keys = [_dataSource allKeys];

    self.automaticallyAdjustsScrollViewInsets = YES;

    UITableView* tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {return 1;}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _keys.count;
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
    cell.textLabel.text = _keys[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* title = _keys[indexPath.row];
    NSString* className = _dataSource[title];
    Class cls = NSClassFromString(className);
    UIViewController* vc = [cls new];
    vc.navigationItem.title = title;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
