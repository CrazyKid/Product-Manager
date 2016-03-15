//
//  WriteProduct.m
//  库存管理
//
//  Created by Macx on 16/3/11.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "WriteProduct.h"

@interface WriteProduct ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *keyNumber;
@property (weak, nonatomic) IBOutlet UITextField *nam;

@property (weak, nonatomic) IBOutlet UITextField *type;


@end


@implementation WriteProduct

- (void)setFrame:(CGRect)frame {

    [super setFrame:frame];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)];
    
    [_imageView addGestureRecognizer:tap];
    
    NSNumber *keyNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"nextKeyNum"];
    
    NSLog(@"%@",keyNum);
    
    if ( keyNum == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"nextKeyNum"];
    }
    
    _keyNumber.text = [NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"nextKeyNum"] integerValue]];
    

}

- (void)clickAction:(UITapGestureRecognizer *)tap {





}

- (IBAction)save:(id)sender {
    
    if (_nam.text.length == 0) {
        
        [self warningEmpty];
        
        return;
        
    }
    
    NSInteger keyNum = [[[NSUserDefaults standardUserDefaults] objectForKey:@"nextKeyNum"] integerValue];
    
    keyNum++;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:keyNum] forKey:@"nextKeyNum"];
    
    
    
    
}

- (void)warningEmpty {

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 50) / 2.0, ([UIScreen mainScreen].bounds.size.height - 69 - 30) / 2.0, 50, 30)];
    
    label.backgroundColor = [UIColor grayColor];
    
    label.tag = 666;
    
    [self.window addSubview:label];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
}

- (void)timerAction:(NSTimer *)timer {

    [[self.window viewWithTag:666] removeFromSuperview];
    
    [timer timeInterval];
}

@end
