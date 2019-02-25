//
//  ViewController.m
//  01.CoreData的简单使用
//
//  Created by CoderSLZeng on 2019/2/25.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

/*
 * 实现思路
 * 1.创建模型文件 ［相当于一个数据库里的表］
 * 2.添加实体 ［一张表］
 * 3.创建实体类 [相当模型]
 * 4.生成上下文 关联模型文件生成数据库
 *    关联的时候，如果本地没有数据库文件，Ｃoreadata自己会创建
 */

#import "ViewController.h"

#import "Department+CoreDataProperties.h"
#import "Employee+CoreDataProperties.h"

@interface ViewController () {
    NSManagedObjectContext *_context;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.初始化上下文
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];

    // 2.关联数据库
    // 2.1.对象模型文件
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    // 2.2.初始化持久化存储调度器（把数据保存到一个文件，而不是内存）
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    // 告诉CoreDate数据库的名称和路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *sqlitePath = [docPath stringByAppendingPathComponent:@"company.sqlite"];
    NSLog(@"%@", sqlitePath);
    
    [store addPersistentStoreWithType:NSSQLiteStoreType
                        configuration:nil
                                  URL:[NSURL fileURLWithPath:sqlitePath]
                              options:nil
                                error:nil];
    
    context.persistentStoreCoordinator = store;
    _context = context;
 
}

#pragma mark - 添加员工
- (IBAction)addEmployee {
    
    // 创建两个部门
    // iOS部门
    Department *iOSDepart = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Department class])
                                                          inManagedObjectContext:_context];
    iOSDepart.name = @"iOS";
    iOSDepart.departNo = @"001";
    iOSDepart.createDate = [NSDate date];

    // Android部门
    Department *androidDepart = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Department class])
                                                          inManagedObjectContext:_context];
    androidDepart.name = @"Android";
    androidDepart.departNo = @"002";
    androidDepart.createDate = [NSDate date];

    Employee *emp = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Employee class])
                                                  inManagedObjectContext:_context];

    emp.name = @"张三";
    emp.birthday = [NSDate date];
    emp.height = 1.76;
    emp.depart = iOSDepart;
    
    Employee *emp1 = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Employee class])
                                                  inManagedObjectContext:_context];
    
    emp1.name = @"李四";
    emp1.birthday = [NSDate date];
    emp1.height = 1.90;
    emp1.depart = androidDepart;
    
    Employee *emp2 = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Employee class])
                                                  inManagedObjectContext:_context];
    
    emp2.name = @"王五";
    emp2.birthday = [NSDate date];
    emp2.height = 1.70;
    emp2.depart = androidDepart;
    
    NSError *error = nil;
    [_context save:&error];
    
    if (error) {
        NSLog(@"%@", error);
    }
}

#pragma mark - 读取员工
- (IBAction)readEmployee {
    
    // 1.获取抓取请求对象
    NSFetchRequest *employeeRequest = [Employee fetchRequest];
    
    // 2.设置过滤条件
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", @"张三"];
//    employeeRequest.predicate = predicate;
//
//     3.设置排序
//    NSSortDescriptor *heightSort = [NSSortDescriptor sortDescriptorWithKey:@"height" ascending:NO];
//    employeeRequest.sortDescriptors = @[heightSort];
    
    // 4.执行请求
    NSError *error = nil;
    NSArray *emps = [_context executeFetchRequest:employeeRequest error:&error];
    
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    
    // 5.读出数据
    for (Employee *emp in emps) {
        
        Department *depart = emp.depart;
        NSLog(@"姓名 = %@，身高 = %f， 生日 = %@ 部门 = %@ 部门编号 = %@ 部门创建时间 = %@", emp.name, emp.height, emp.birthday, depart.name, depart.departNo, depart.createDate);
        
    }
    
}

#pragma mark - 更新员工
- (IBAction)updateEmployee {
    
    // 1.获取对象抓取请求
    NSFetchRequest *request = [Employee fetchRequest];
    
    // 2.设置过滤条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", @"张三"];
    request.predicate = predicate;
    
    // 3.执行请求
    NSError *error = nil;
    NSArray *emps = [_context executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    
    // 4.更新数据
    for (Employee *emp in emps) {
        emp.height = 1.90;
    }
    
    // 5.保存数据
    [_context save:nil];
}

#pragma mark - 删除员工
- (IBAction)deleteEmployee {
    
    // 1.获取对象抓取请求
    NSFetchRequest *request = [Employee fetchRequest];
    
    // 2.设置过滤条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", @"张三"];
    request.predicate = predicate;
    
    // 3.执行请求
    NSError *error = nil;
    NSArray *emps = [_context executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    
    // 4.删除数据
    for (Employee *emp in emps) {
        [_context deleteObject:emp];
    }
    
    // 5.保存数据
    [_context save:nil];
}

@end
