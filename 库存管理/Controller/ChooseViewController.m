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
#import "CoreDataManager.h"
#import "Product.h"


@interface ChooseViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong)UITableView *table;
@property (nonatomic,assign)BOOL flagOfSearch;
@property (nonatomic,strong)NSMutableArray *searchArr;

@end

@implementation ChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"产品信息";
    self.view.backgroundColor = [UIColor whiteColor];
//    [self _createErWeiMa];
    
    [self _createSearch];
    
    [self _createTableView];

    _flagOfSearch = NO;
    
}

- (void)_createSearch {
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, [UIScreen  mainScreen].bounds.size.width, 30)];
    
    textField.backgroundColor = [UIColor grayColor];
    
    textField.placeholder = @"请输入搜索信息";
    
    [self.view addSubview:textField];
    
    textField.delegate = self;

}

- (void)_createTableView {

    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 69 - 30)];
    
    [self.view addSubview:_table];
    
    _table.delegate = self;
    _table.dataSource = self;
    
    _table.separatorColor = [UIColor redColor];
    
    _table.rowHeight = 80;
    
    [_table registerNib:[UINib nibWithNibName:@"ProductCell" bundle:nil] forCellReuseIdentifier:@"productCellIdentifier"];

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

#pragma mark - textField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    NSString *str = textField.text;
    
    NSArray * arr = [[CoreDataManager shareManager] queryProductWithString:[NSString stringWithFormat:@"keyID like '*%@*' || name like '*%@*' || type like '*%@*'",str,str,str]];

    _flagOfSearch = YES;
    
    _searchArr = [arr mutableCopy];
    
    [_table reloadData];
    
    return YES;
}

#pragma mark - tableView delegate 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_flagOfSearch) {
        return _searchArr.count;
    }
    return [[CoreDataManager shareManager] dataCount];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"productCellIdentifier"forIndexPath:indexPath];
    
    if (_flagOfSearch) {
        cell.model = [Model createWithKeyNum:((Product *)_searchArr[indexPath.row]).keyID];
    }
    else {
        cell.model = [Model createWithKeyNum:indexPath.row + 1];
    }
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSInteger keyID = indexPath.row + 1;
    if (_flagOfSearch) {
        keyID = ((Product *)_searchArr[indexPath.row]).keyID;
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:@"keyNumNoti" object:nil userInfo:@{@"keyNum":[NSString stringWithFormat:@"%ld",keyID]}];
    
    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [tableView beginUpdates];//和endUpdates一起使用，在这两个方法之间，会自己决定调用的顺序，从而避免之前陈述的情况
        if (_flagOfSearch) {
            NSInteger keyID = ((Product *)_searchArr[indexPath.row]).keyID;
            [_searchArr removeObjectAtIndex:indexPath.row];
            [[CoreDataManager shareManager] deleteProductWithKeyID:keyID];
            [[CoreDataManager shareManager] updateProductWithDelectKeyID:keyID];
        }
        else {
            [[CoreDataManager shareManager] deleteProductWithKeyID:indexPath.row + 1];
            [[CoreDataManager shareManager] updateProductWithDelectKeyID:indexPath.row + 1];
        }
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
        
        [tableView reloadData];
    }
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
