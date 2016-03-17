//
//  Model.h
//  库存管理
//
//  Created by Macx on 16/3/11.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

@property (nonatomic,copy)NSString *productName;
@property (nonatomic,copy)NSString *productID;
@property (nonatomic,copy)NSString *productType;
@property (nonatomic,copy)NSString *productImage;

//用来根据已有的keynum创建对应的model
+ (Model *)createWithKeyNum:(NSInteger)keyNum;

@end
