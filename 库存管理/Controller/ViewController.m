//
//  ViewController.m
//  库存管理
//
//  Created by Macx on 16/3/11.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "ViewController.h"
#import "MainView.h"
#import "WriteViewController.h"
#import "ChooseViewController.h"

@interface ViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,assign)CGFloat kScreenHeight;
@property (nonatomic,assign)CGFloat kScreenWidth;
@property (nonatomic,assign)NSInteger keyNum;

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _kScreenHeight = [UIScreen mainScreen].bounds.size.height - 69;
    _kScreenWidth = [UIScreen mainScreen].bounds.size.width;

    _keyNum = 0;
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"keyNumNoti" object:nil];
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    [self _createNaviBarItem];
    
    [self _createProductView];
    
    [self _createInOutLabel];
    
    [self _createTableView];
    
    [self _createCountInOutLabel];

}

- (void)notificationAction:(NSNotification *)notification {

    _keyNum = [notification.userInfo[@"keyNum"] integerValue];
    
    [_tableView reloadData];

}

- (void)_createProductView {

    MainView *view = [[NSBundle mainBundle] loadNibNamed:@"MainView" owner:self options:nil].lastObject;
    
    view.frame = CGRectMake(0, 0, _kScreenWidth, 350);
    
    view.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:view];

}

- (void)_createInOutLabel {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 350 - 69, _kScreenWidth, 29)];
    
    label.text = @"出入库记录";
    
    label.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:label];

}

- (void)_createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 310, _kScreenWidth, _kScreenHeight - 310 - 20)];
    
    [self.view addSubview:_tableView];
    
    _tableView.tag = 1124;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
}

- (void)_createCountInOutLabel {

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, _kScreenHeight - 20, _kScreenWidth, 20)];
    
    label.text = @"本月出库:本月入库:库存剩余:";

    label.textColor = [UIColor redColor];
    
    label.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:label];

}

- (void)_createNaviBarItem {

    UIButton *choose = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    
    choose.tag = 100;
    
    [choose setTitle:@"产品选择" forState:UIControlStateNormal];
    
    [choose setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [choose addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:choose];
    
    UIButton *write = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    
    write.tag = 101;
    
    [write setTitle:@"产品输入" forState:UIControlStateNormal];
    [write setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [write addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:write];
}

- (void)buttonAction:(UIButton *)button {

    if (button.tag == 100) {
        ChooseViewController *vc = [[ChooseViewController alloc] init];

        [self.navigationController pushViewController:vc animated:YES];
    }
    if (button.tag == 101) {
        
        WriteViewController *vc = [[WriteViewController alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];

    }

}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"countLeftWithKeyNum%d",_keyNum]];
    
    if (arr == nil) {
        return 0;
    }
    
    return arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"countLeftWithKeyNum%d",_keyNum]];
    
    NSInteger count = [((NSDictionary *)arr[indexPath.row])[@"count"] integerValue];
    
    if (indexPath.row != 0) {
        count = [[arr[indexPath.row] objectForKey:@"count"] integerValue] - [[arr[indexPath.row - 1] objectForKey:@"count"] integerValue];
    }
    
    NSString *time = [arr[indexPath.row] objectForKey:@"time"];
    
    if (count >= 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%d.%@入库%d",indexPath.row + 1,time,count];
        
    }
    else {
        cell.textLabel.text = [NSString stringWithFormat:@"%d.%@出库%d",indexPath.row + 1,time,-count];
    }

    cell.textLabel.font = [UIFont systemFontOfSize:12];
    return cell;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
