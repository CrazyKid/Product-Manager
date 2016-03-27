//
//  Product+CoreDataProperties.h
//  库存管理
//
//  Created by Macx on 16/3/24.
//  Copyright © 2016年 Arthur. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Product.h"

NS_ASSUME_NONNULL_BEGIN

@interface Product (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *type;
@property (nonatomic) int32_t keyID;
@property (nullable, nonatomic, retain) NSSet<InOutTime *> *inOut;

@end

@interface Product (CoreDataGeneratedAccessors)

- (void)addInOutObject:(InOutTime *)value;
- (void)removeInOutObject:(InOutTime *)value;
- (void)addInOut:(NSSet<InOutTime *> *)values;
- (void)removeInOut:(NSSet<InOutTime *> *)values;

@end

NS_ASSUME_NONNULL_END
