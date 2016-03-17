//
//  MainView.m
//  库存管理
//
//  Created by Macx on 16/3/11.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "MainView.h"
#import "Model.h"

@interface MainView () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *addTextField;
@property (weak, nonatomic) IBOutlet UITextField *decreaseTextField;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *keyNum;
@property (weak, nonatomic) IBOutlet UILabel *type;

@property (nonatomic,assign)NSInteger count;
@property (nonatomic,assign)NSInteger key;

@end

@implementation MainView

- (void)setFrame:(CGRect)frame {

    [super setFrame:frame];
    
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"countLeft"] != nil) {
//        count = [[[NSUserDefaults standardUserDefaults] objectForKey:@"countLeft"] intValue];
//    }
//    
//    _label.text = [NSString stringWithFormat:@"目前库存余额:%ld",count];
    
//    _button.enabled = NO;
//    
//    _addTextField.delegate = self;
//    _decreaseTextField.delegate = self;
    
}

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

- (void)awakeFromNib {

    [super awakeFromNib];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"keyNumNoti" object:nil];
    
}

- (void)notificationAction:(NSNotification *)notification {
    
    _key = [notification.userInfo[@"keyNum"] integerValue];
    
    Model *model = [Model createWithKeyNum:_key];
    
    _name.text = [NSString stringWithFormat:@"产品名称:%@",model.productName];
    _keyNum.text = [NSString stringWithFormat:@"产品编号:%@",model.productID];
    _type.text = [NSString stringWithFormat:@"产品类型:%@",model.productType];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"countLeftWithKeyNum%d",_key]] != nil) {
        NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"countLeftWithKeyNum%d",_key]];
        
        _count = [array.lastObject[@"count"] integerValue];
    }
    
    _label.text = [NSString stringWithFormat:@"目前库存余额:%d",_count];
    
}

- (IBAction)buttonAction:(id)sender {
    
    if (_keyNum == 0) {
        return;
    }
    if (_addTextField.text.length == 0 && _decreaseTextField.text.length == 0) {
        return;
    }
  
    int add = 0,decrease = 0;
    
    if (_addTextField.text.length != 0) {
        add = [_addTextField.text integerValue];
    }
    if (_decreaseTextField.text.length != 0) {
        decrease = [_decreaseTextField.text integerValue];
    }


    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"countLeftWithKeyNum%d",_key]];
    
    NSMutableArray *newArr = (array == nil) ? [NSMutableArray array] : [array mutableCopy];
    
    if (array != nil) {
        _count = [array.lastObject[@"count"] integerValue];
    }

    
    
    _count = _count + add - decrease;

    _label.text = [NSString stringWithFormat:@"目前库存余额:%d",_count];
    
    _addTextField.text = nil;
    _decreaseTextField.text = nil;
    
    //插入修改时间
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localDate = [date dateByAddingTimeInterval:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年M月d日 H点m分"];
    NSString *dateStr = [formatter stringFromDate:localDate];
    
    [newArr addObject:@{@"count":[NSNumber numberWithInteger:_count],@"time":dateStr}];
    
    [[NSUserDefaults standardUserDefaults] setObject:newArr forKey:[NSString stringWithFormat:@"countLeftWithKeyNum%d",_key]];
    
    [((UITableView *)[self.superview viewWithTag:1124]) reloadData];
    
//    _button.enabled = NO;

}


@end
