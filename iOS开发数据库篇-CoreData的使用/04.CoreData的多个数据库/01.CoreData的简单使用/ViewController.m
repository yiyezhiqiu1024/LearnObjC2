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
 *    关联的时候，如果本地没有数据库文件，Coreadata自己会创建
 */

#import "ViewController.h"

#import "Employee+CoreDataProperties.h"
#import "Status+CoreDataProperties.h"

@interface ViewController () {
    NSManagedObjectContext *_employeeContext;
    NSManagedObjectContext *_statusContext;
}

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    _employeeContext = [self setupContextWithModelName:@"Company"];
    _statusContext = [self setupContextWithModelName:@"Weibo"];
}

#pragma mark - Private methonds
- (NSManagedObjectContext *)setupContextWithModelName:(NSString *)name {
    // 1.初始化上下文
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    // 2.关联数据库
    // 2.1.对象模型文件
    // 使用下面的方法，如果 bundles为nil 会把bundles里面的所有模型文件的表放在一个数据库
    //    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    NSURL *url = [[NSBundle mainBundle] URLForResource:name withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
    
    // 2.2.初始化持久化存储调度器（把数据保存到一个文件，而不是内存）
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    // 告诉CoreDate数据库的名称和路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *sqliteName = [NSString stringWithFormat:@"%@.sqlite", name];
    NSString *sqlitePath = [docPath stringByAppendingPathComponent:sqliteName];
    NSLog(@"%@", sqlitePath);
    
    [store addPersistentStoreWithType:NSSQLiteStoreType
                        configuration:nil
                                  URL:[NSURL fileURLWithPath:sqlitePath]
                              options:nil
                                error:nil];
    
    context.persistentStoreCoordinator = store;
    return context;
}

- (void)readEmployee {
    // 1.获取抓取请求对象
    NSFetchRequest *employeeRequest = [Employee fetchRequest];
    
    // 2.执行请求
    NSError *employeeError = nil;
    NSArray *emps = [_employeeContext executeFetchRequest:employeeRequest error:&employeeError];
    
    if (employeeError) {
        NSLog(@"%@", employeeError);
        return;
    }
    
    // 3.读出数据
    for (Employee *emp in emps) {
        
        NSLog(@"姓名 = %@，身高 = %f， 生日 = %@", emp.name, emp.height, emp.birthday);
        
    }
}

- (void)readStatus {
    
    // 1.获取抓取请求对象
    NSFetchRequest *statusRequest = [Status fetchRequest];
    
    // 2.执行请求
    NSError *statusError = nil;
    NSArray *statuses = [_statusContext executeFetchRequest:statusRequest error:&statusError];
    
    if (statusError) {
        NSLog(@"%@", statusError);
        return;
    }
    
    // 3.读出数据
    for (Status *status in statuses) {
        
        NSLog(@"微博正文 = %@，微博发出时间 = %@", status.text, status.createDate);
        
    }
}

#pragma mark - Actions
#pragma mark - 添加数据
- (IBAction)addData {
    
    Employee *emp = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Employee class])
                                                  inManagedObjectContext:_employeeContext];
    emp.name = @"张三";
    emp.birthday = [NSDate date];
    emp.height = 1.60;
    
    NSError *employeeError = nil;
    [_employeeContext save:&employeeError];
    
    if (employeeError) {
        NSLog(@"%@", employeeError);
    }
    
    Status *status = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Status class]) inManagedObjectContext:_statusContext];
    status.text = @"今儿学习CorData，收获颇多，真高兴";
    status.createDate = [NSDate date];
    
    NSError *statusError = nil;
    [_statusContext save:&statusError];
    
    if (statusError) {
        NSLog(@"%@", statusError);
    }
}

#pragma mark - 读取数据
- (IBAction)readData {
    
    // 1.读出员工数据
    [self readEmployee];
        
    // 2.读取微博数据
    [self readStatus];
    
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
    NSArray *emps = [_employeeContext executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    
    // 4.更新数据
    for (Employee *emp in emps) {
        emp.height = 1.90;
    }
    
    // 5.保存数据
    [_employeeContext save:nil];
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
    NSArray *emps = [_employeeContext executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    
    // 4.删除数据
    for (Employee *emp in emps) {
        [_employeeContext deleteObject:emp];
    }
    
    // 5.保存数据
    [_employeeContext save:nil];
}

@end
