//
//  Status+CoreDataProperties.m
//  01.CoreData的简单使用
//
//  Created by CoderSLZeng on 2019/2/25.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//
//

#import "Status+CoreDataProperties.h"

@implementation Status (CoreDataProperties)

+ (NSFetchRequest<Status *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Status"];
}

@dynamic text;
@dynamic createDate;

@end
