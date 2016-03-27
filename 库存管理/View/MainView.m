//
//  MainView.m
//  库存管理
//
//  Created by Macx on 16/3/11.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "MainView.h"
#import "Model.h"
#import "CoreDataManager.h"
#import "Product.h"
#import "InOutTime.h"

@interface MainView () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *addTextField;
@property (weak, nonatomic) IBOutlet UITextField *decreaseTextField;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *keyNum;
@property (weak, nonatomic) IBOutlet UILabel *type;

@property (nonatomic,assign)NSInteger key;

@end

@implementation MainView

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//
//    NSLog(@"%@,%ld", string,_addTextField.text.length);
//    
//    if (_decreaseTextField.text.length != 0 || _addTextField.text.length != 0) {
//        _button.enabled = YES;
//    }
//
//    return YES;
//}

//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//
//    [UIView animateWithDuration:0.25 animations:^{
//        
//        self.transform = CGAffineTransformMakeTranslation(0, -100);
//        
//    }];
//
//}

- (void)awakeFromNib {

    [super awakeFromNib];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"keyNumNoti" object:nil];
    
    _addTextField.delegate = self;
    _decreaseTextField.delegate = self;
    
}

- (void)notificationAction:(NSNotification *)notification {
    
    _key = [notification.userInfo[@"keyNum"] integerValue];
    
    Model *model = [Model createWithKeyNum:_key];
    
    _name.text = [NSString stringWithFormat:@"产品名称:%@",model.productName];
    _keyNum.text = [NSString stringWithFormat:@"产品编号:%@",model.productID];
    _type.text = [NSString stringWithFormat:@"产品类型:%@",model.productType];
    
}

- (IBAction)buttonAction:(id)sender {
    
//    [UIView animateWithDuration:0.25 animations:^{
//        
//        self.transform = CGAffineTransformIdentity;
//        
//    }];

    
    [_addTextField resignFirstResponder];
    [_decreaseTextField resignFirstResponder];

    if (_key == 0) {
        
        _addTextField.text = nil;
        _decreaseTextField.text = nil;
        return;
    }
    if (_addTextField.text.length == 0 && _decreaseTextField.text.length == 0) {
        return;
    }
  
    NSInteger add = 0,decrease = 0,count = 0,keyIDInOut = 0;
    
    if (_addTextField.text.length != 0) {
        add = [_addTextField.text integerValue];
    }
    if (_decreaseTextField.text.length != 0) {
        decrease = [_decreaseTextField.text integerValue];
    }

    Product *product = [[CoreDataManager shareManager] productWithKeyID:_key];
    
    NSInteger last = product.inOut.count;
    
    InOutTime *lastOne = [[CoreDataManager shareManager] inOutTimeWithKeyID:_key keyIDInOut:last - 1];
    
    
    count = (lastOne == nil) ? 0 : lastOne.numbers;
    keyIDInOut = (lastOne == nil) ? 1 : (product.inOut.count + 1);
    
    count = count + add - decrease;
    
    _addTextField.text = nil;
    _decreaseTextField.text = nil;
    
    //插入修改时间
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    //输出格式为：2010-10-27 10:22:13
    
    [[CoreDataManager shareManager] addInOutWithProductKeyID:_key inOutNumbers:count inOutKeyID:keyIDInOut inOutTime:currentDateStr];
    
    [((UITableView *)[self.superview viewWithTag:1124]) reloadData];
    
//    _button.enabled = NO;

    //库存的数量刷新
    UILabel *label = [self.superview viewWithTag:612];
    
    Product *product1 = [[CoreDataManager shareManager] productWithKeyID:_key];
    
    NSSet *set = product1.inOut;
    
    int count1 = ([[CoreDataManager shareManager] inOutTimeWithKeyID:_key keyIDInOut:set.count - 1]).numbers;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        label.text = [NSString stringWithFormat:@"库存剩余:%d",count1];
    });
}


@end
