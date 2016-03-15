//
//  MainView.m
//  库存管理
//
//  Created by Macx on 16/3/11.
//  Copyright © 2016年 Arthur. All rights reserved.
//

static long int count = 0;

#import "MainView.h"

@interface MainView () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *addTextField;
@property (weak, nonatomic) IBOutlet UITextField *decreaseTextField;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation MainView

- (void)setFrame:(CGRect)frame {

    [super setFrame:frame];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"countLeft"] != nil) {
        count = [[[NSUserDefaults standardUserDefaults] objectForKey:@"countLeft"] intValue];
    }
    
    _label.text = [NSString stringWithFormat:@"目前库存余额:%ld",count];
    
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

- (IBAction)buttonAction:(id)sender {
    
    int add,decrease;
    
    if (_addTextField.text != nil) {
        add = [_addTextField.text intValue];
    }
    if (_decreaseTextField.text != nil) {
        decrease = [_decreaseTextField.text intValue];
    }

    count = count + add - decrease;
    
    _label.text = [NSString stringWithFormat:@"目前库存余额:%ld",count];
    
    _addTextField.text = nil;
    _decreaseTextField.text = nil;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLong:count] forKey:@"countLeft"];
    
//    _button.enabled = NO;

}


@end
