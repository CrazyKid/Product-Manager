//
//  InOutTime+CoreDataProperties.h
//  库存管理
//
//  Created by Macx on 16/3/24.
//  Copyright © 2016年 Arthur. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "InOutTime.h"

NS_ASSUME_NONNULL_BEGIN

@interface InOutTime (CoreDataProperties)

@property (nonatomic) int32_t numbers;
@property (nullable, nonatomic, retain) NSString *time;
@property (nonatomic) int32_t keyIDInOut;

@end

NS_ASSUME_NONNULL_END
