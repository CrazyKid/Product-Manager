//
//  CoreDataManager.h
//  库存管理
//
//  Created by Macx on 16/3/23.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Product.h"
#import "InOutTime.h"

@interface CoreDataManager : NSObject

+ (instancetype)shareManager;

//对Product进行操作
- (NSString *)addProductObjectWithKeyID:(NSInteger )keyID name:(NSString *)name type:(NSString *)type;

- (NSArray *)queryProductWithString:(NSString *)str;

- (Product *)productWithKeyID:(NSInteger)keyID;

- (void)deleteProductWithKeyID:(NSInteger)keyID;

- (void)updateProductWithDelectKeyID:(NSInteger )keyID;

- (NSString *)saveDataFilePath;

- (NSInteger )dataCount;

//对Product中的InOut进行操作

- (void)addInOutWithProductKeyID:(NSInteger)keyID
                    inOutNumbers:(NSInteger )numbers
                      inOutKeyID:(NSInteger)keyIDInOut
                       inOutTime:(NSString *)time;
- (InOutTime *)inOutTimeWithKeyID:(NSInteger)keyID keyIDInOut:(NSInteger)keyIDInOut;

@end
