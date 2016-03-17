//
//  Model.m
//  库存管理
//
//  Created by Macx on 16/3/11.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "Model.h"

@implementation Model

+ (Model *)createWithKeyNum:(NSInteger)keyNum {

    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"ProductWithKeyNum%d",keyNum]];
    
    Model *model = [[Model alloc] init];
    
    model.productID = dic[@"keyNum"];
    model.productName = dic[@"name"];
    model.productType = dic[@"type"];
    
    return model;


}

@end
