//
//  CoreDataManager.m
//  库存管理
//
//  Created by Macx on 16/3/23.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "CoreDataManager.h"

@implementation CoreDataManager

static NSManagedObjectContext *context = nil;

+ (instancetype)shareManager {

    static CoreDataManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CoreDataManager alloc] init];
        [manager shareContext];
    });

    return manager;
}

- (void)shareContext {
    
    //1.创建NSManagedObjectModel对象
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Product" withExtension:@"momd"];
    NSManagedObjectModel *dataModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    //2.创建PSC
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:dataModel];
    
    NSString *dataFilePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/ProductCoreData.sqlite"];

    NSURL *url = [NSURL fileURLWithPath:dataFilePath];
    
    
    NSDictionary *options = @{
                              //自动版本迁移
                              NSMigratePersistentStoresAutomaticallyOption : @YES,
                              //自动映射
                              NSInferMappingModelAutomaticallyOption : @YES
                              
                              };
    
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:options error:nil];
    
    //3.创建Context
    context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    context.persistentStoreCoordinator = store;

}

//数据库保存路径
- (NSString *)saveDataFilePath {

    return [NSHomeDirectory() stringByAppendingString:@"/Documents/ProductCoreData.sqlite"];
}

//增加一条Product
- (NSString *)addProductObjectWithKeyID:(NSInteger)keyID name:(NSString *)name type:(NSString *)type {
    
    Product *product = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:context];
    
    product.name = name;
    product.type = type;
    product.keyID = keyID;
    
    //把context中的内容同步到数据库中
    if([context save:NULL]) {
        return @"success";
    }
    return @"fail";
    
}

//查询数据
- (NSArray *)queryProductWithString:(NSString *)str {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Product"];
    
    //SQL语句中用%代表通配符，在谓词中用*代表通配符
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"type like '*%@*' || name like '*%@*'",str,str]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:str];
    
    request.predicate = predicate;
    
    NSArray *resultArray = [context executeFetchRequest:request error:nil];
    
    return resultArray;
    
}

//根据keyID找到对应product
- (Product *)productWithKeyID:(NSInteger)keyID {

    return [[[CoreDataManager shareManager] queryProductWithString:[NSString stringWithFormat:@"keyID=%ld",keyID]] objectAtIndex:0];

}

//更新数据。
- (void)updateProductWithDelectKeyID:(NSInteger )keyID {
    //更新之前得拿到需要更新对象，需要先查询
    
    // NSFetchRequest 用来查询的对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Product"];
    
    //查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"keyID>%ld",keyID]];
    request.predicate = predicate;
    
    NSArray *resultArr = [context executeFetchRequest:request error:NULL];
    
    for (Product *product in resultArr) {
        product.keyID = product.keyID - 1;
    }
    
    if ([context save:NULL]) {
        NSLog(@"保存成功");
    }else{
        NSLog(@"保存失败");
    }
}

//删除数据。
- (void)deleteProductWithKeyID:(NSInteger)keyID {
    //删除之前得先拿到需要删除的对象，需要先查询
    
    // NSFetchRequest 用来查询的对象（后面的参数表示去哪个实体查询）
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Product"];
    
    //查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"keyID like '%ld'",keyID]];
    request.predicate = predicate;
    
    NSArray *resultArr = [context executeFetchRequest:request error:NULL];
    
    for (Product *product in resultArr) {
        [context deleteObject:product];
    }
    
    //context中的对象已被移出context，直接与数据库进行同步，就会从数据库中删除数据。
    if ([context save:NULL]) {
        NSLog(@"保存成功");
    }else{
        NSLog(@"保存失败");
    }
}

//数据总条数
- (NSInteger )dataCount {

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Product"];
    
    //查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"keyID like '*'"];
    request.predicate = predicate;
    
    NSArray *resultArr = [context executeFetchRequest:request error:NULL];

    return resultArr.count;
}

//根据keyID给对应product添加一个出入库记录
- (void)addInOutWithProductKeyID:(NSInteger)keyID
                    inOutNumbers:(NSInteger )numbers
                      inOutKeyID:(NSInteger)keyIDInOut
                       inOutTime:(NSString *)time {

    Product *product = [[CoreDataManager shareManager] productWithKeyID:keyID];
    
    InOutTime *inOut = [NSEntityDescription insertNewObjectForEntityForName:@"InOutTime" inManagedObjectContext:context];
    
    inOut.numbers = numbers;
    inOut.keyIDInOut = keyIDInOut;
    inOut.time = time;
    
    [product addInOutObject:inOut];
    
    [context save:nil];

}

//根据keyID找到对应的Product的对应keyIDInOut的inouttime.(从0开始)
- (InOutTime *)inOutTimeWithKeyID:(NSInteger)keyID keyIDInOut:(NSInteger)keyIDInOut {

    Product *product = [[CoreDataManager shareManager] productWithKeyID:keyID];
    
    NSSet *inOutSet = product.inOut;

    if (inOutSet == nil || keyIDInOut >= inOutSet.count || keyIDInOut < 0) {
        return nil;
    }
    else {
    
        InOutTime *oneObject = [NSEntityDescription insertNewObjectForEntityForName:@"InOutTime" inManagedObjectContext:context];
        
        for (InOutTime *inOut in inOutSet) {
            
            oneObject = (inOut.keyIDInOut == keyIDInOut + 1) ? inOut : oneObject;
            
        }
        
        return oneObject;
    
    }


}

@end
