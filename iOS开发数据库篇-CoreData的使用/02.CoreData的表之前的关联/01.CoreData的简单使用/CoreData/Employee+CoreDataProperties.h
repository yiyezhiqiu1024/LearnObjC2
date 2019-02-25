//
//  Employee+CoreDataProperties.h
//  01.CoreData的简单使用
//
//  Created by CoderSLZeng on 2019/2/25.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//
//

#import "Employee+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Employee (CoreDataProperties)

+ (NSFetchRequest<Employee *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSDate *birthday;
@property (nonatomic) float height;

@end

NS_ASSUME_NONNULL_END
