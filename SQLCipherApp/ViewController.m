//
//  ViewController.m
//  SQLCipherApp
//
//  Created by 张传奇 on 16/8/15.
//  Copyright © 2016年 张传奇. All rights reserved.
 //https://www.zetetic.net/sqlcipher/    网址
//

#import "ViewController.h"
#import "sqlite3.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnClick:(id)sender {
    NSString *databasePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
                              stringByAppendingPathComponent: @"cipher.db"];
    sqlite3 *db;
    if (sqlite3_open([databasePath UTF8String], &db) == SQLITE_OK) {
        const char* key = [@"abc123" UTF8String];
        sqlite3_key(db, key, strlen(key));
        int result = sqlite3_exec(db, (const char*) "SELECT count(*) FROM sqlite_master;", NULL, NULL, NULL);
        if (result == SQLITE_OK) {
            NSLog(@"password is correct, or, database has been initialized");
            [self initTablePerson:db];
            [self insert:db];
            [self query:db];
        } else {
            NSLog(@"incorrect password! errCode:%d",result);
        }
        
      // int sqlite3_rekey( sqlite3 *db, const void *pKey, int nKey)
      // 修改密钥或者情况密钥  只要之前进行过sqlite3_key操作后即可执行
      // 清空密钥为 sqlite3_rekey( db, NULL, 0);
        const char* key1 = [@"asdfsdfa" UTF8String];
        sqlite3_rekey(db, key1, strlen(key1));
        sqlite3_close(db);
    }
}


- (int)initTablePerson:(sqlite3 *)db
{
    int result = sqlite3_exec(db, (const char*) "CREATE TABLE person(id INT PRIMARY KEY,name TEXT,age INT);", NULL, NULL, NULL);
    
    return result;
}

- (int)insert:(sqlite3 *)db
{
    char *sql = "insert into person(id, name, age) values (1, \"wang33\",23);";
    
    int result = sqlite3_exec(db, sql, NULL, NULL, NULL);
    
    return result;
}

- (int)query:(sqlite3 *)db
{
    char *sql = "select * from person;";
    
    int result = sqlite3_exec(db, sql, callback, NULL, NULL);
    
    return result;
}

static int callback(void *NotUsed, int argc, char **argv, char **azColName){
    int i;
    for(i=0; i < argc; i++){
        printf("%s = %s  ", azColName[i], argv[i] ? argv[i] : "NULL");
    }
    printf("\n");
    return 0;
}

@end
