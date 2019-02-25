//
//  Status+CoreDataProperties.h
//  01.CoreData的简单使用
//
//  Created by CoderSLZeng on 2019/2/25.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//
//

#import "Status+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Status (CoreDataProperties)

+ (NSFetchRequest<Status *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *text;
@property (nullable, nonatomic, copy) NSDate *createDate;

@end

NS_ASSUME_NONNULL_END
