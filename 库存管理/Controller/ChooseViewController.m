//
//  ChooseViewController.m
//  库存管理
//
//  Created by Macx on 16/3/11.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "ChooseViewController.h"
#import "ProductCell.h"
#import "Model.h"


@interface ChooseViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation ChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"产品信息";
    self.view.backgroundColor = [UIColor whiteColor];
//    [self _createErWeiMa];
    
    [self _createSearch];
    
    [self _createTableView];
    
}

- (void)_createSearch {
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, [UIScreen  mainScreen].bounds.size.width, 30)];
    
    textField.backgroundColor = [UIColor grayColor];
    
    textField.placeholder = @"请输入搜索信息";
    
    [self.view addSubview:textField];

}

- (void)_createTableView {

    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 69 - 30)];
    
    [self.view addSubview:table];
    
    table.delegate = self;
    table.dataSource = self;
    
    table.separatorColor = [UIColor redColor];
    
    table.rowHeight = 80;
    
    [table registerNib:[UINib nibWithNibName:@"ProductCell" bundle:nil] forCellReuseIdentifier:@"productCellIdentifier"];

}

- (void)_createErWeiMa {
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    
    button.backgroundColor = [UIColor grayColor];
    
    [button setImage:[UIImage imageNamed:@"erweima.jpg"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
}

- (void)buttonAction:(UIButton *)button {
    
    NSLog(@"1");
    
}

#pragma mark - tableView delegate 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:@"nextKeyNum"];
    
    if (num == nil) {
        return 0;
    }
    
    return [num integerValue] - 1;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"productCellIdentifier"forIndexPath:indexPath];
    
    cell.model = [Model createWithKeyNum:indexPath.row + 1];
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"keyNumNoti" object:nil userInfo:@{@"keyNum":[NSString stringWithFormat:@"%d",indexPath.row + 1]}];

    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
   
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
