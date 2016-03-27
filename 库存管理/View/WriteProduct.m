//
//  WriteProduct.m
//  库存管理
//
//  Created by Macx on 16/3/11.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "WriteProduct.h"
#import "CoreDataManager.h"

@interface WriteProduct ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *keyNumber;
@property (weak, nonatomic) IBOutlet UITextField *nam;

@property (weak, nonatomic) IBOutlet UITextField *type;


@end


@implementation WriteProduct

- (void)awakeFromNib {

    [super awakeFromNib];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)];
    
    [_imageView addGestureRecognizer:tap];
    
    NSInteger keyID = [[CoreDataManager shareManager] dataCount] + 1;
    
    _keyNumber.text = [NSString stringWithFormat:@"%03ld",keyID];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)popKeyBoard:(NSNotification *)notification {

    NSValue *value = notification.userInfo[@"UIKeyboardBoundsUserInfoKey"];
    CGRect rect = [value CGRectValue];
    CGFloat height = rect.size.height;
    
    //   （3）调整View的高度和tableView的高度
    [UIView animateWithDuration:0.25 animations:^{
        
        self.transform = CGAffineTransformMakeTranslation(0, -height);

    }];

    
}



- (void)clickAction:(UITapGestureRecognizer *)tap {




}

- (IBAction)save:(id)sender {
    
    
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformIdentity;

    }];
    
    //    （2）键盘掉下来
    [_type resignFirstResponder];
    [_nam resignFirstResponder];
    
    
    
    if (_nam.text.length == 0) {
        
        [self saveResult:@"empty"];
        
        return;
        
    }
    
    NSString *saveResult = [[CoreDataManager shareManager] addProductObjectWithKeyID:[_keyNumber.text integerValue] name:_nam.text type:_type.text];
    
    
    
//图片的保存还没做
    
    dispatch_async(dispatch_get_main_queue(), ^{
       _keyNumber.text = [NSString stringWithFormat:@"%03ld",[_keyNumber.text integerValue] + 1];
        
        _nam.text = nil;
        _type.text = nil;
        _imageView.image = nil;
    });
    
    [self saveResult:saveResult];
    
}

- (void)saveResult:(NSString *)result {

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 150) / 2.0, ([UIScreen mainScreen].bounds.size.height - 69 - 30) / 2.0, 150, 30)];
    
    label.backgroundColor = [UIColor grayColor];
    
    label.tag = 666;
    
    label.textColor = [UIColor whiteColor];
    
    label.textAlignment = NSTextAlignmentCenter;
    
    label.font = [UIFont systemFontOfSize:15];
    
    if ([result isEqualToString:@"success"]) {
        label.text = @"保存成功";
    }
    else if ([result isEqualToString:@"empty"]) {
    
        label.text = @"产品名不能为空";
    }
    else if ([result isEqualToString:@"fail"]) {
    
        label.text = @"保存失败";
    }
    
    [self.window addSubview:label];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
}

- (void)timerAction:(NSTimer *)timer {

    [[self.window viewWithTag:666] removeFromSuperview];
    
    [timer timeInterval];
}

@end
