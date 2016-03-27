//
//  Model.m
//  库存管理
//
//  Created by Macx on 16/3/11.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "Model.h"
#import "CoreDataManager.h"
#import "Product.h"

@implementation Model

+ (Model *)createWithKeyNum:(NSInteger)keyNum {
    
    Product *product = [[CoreDataManager shareManager] productWithKeyID:keyNum];
    
    Model *model = [[Model alloc] init];
    
    model.productID = [NSString stringWithFormat:@"%03lld",product.keyID];
    model.productName = product.name;
    model.productType = product.type;
    
    return model;

}

@end
