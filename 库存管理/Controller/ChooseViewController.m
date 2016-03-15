//
//  ChooseViewController.m
//  库存管理
//
//  Created by Macx on 16/3/11.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "ChooseViewController.h"

@interface ChooseViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation ChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"产品信息";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, [UIScreen  mainScreen].bounds.size.width, 30)];
    
    textField.backgroundColor = [UIColor grayColor];
    
    textField.placeholder = @"请输入搜索信息";
    
    [self.view addSubview:textField];
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 69 - 30)];
    
    [self.view addSubview:table];
    
    table.delegate = self;
    table.dataSource = self;
    
    [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"product"];
    
}

#pragma mark - tableView delegate 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 20;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"product" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"row = %d",indexPath.row];
    
    return cell;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
