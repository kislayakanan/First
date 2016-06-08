//
//  DBManager.m
//  GooglePlusSample
//
//  Created by WebAstral on 11/14/14.
//  Copyright (c) 2014 Google Inc. All rights reserved.
//

#import "DBManager.h"
#import <UIKit/UIKit.h>


static DBManager *sharedInstance = nil;
static DBManager *   localNotification = nil;
static sqlite3 *database ;
static int iii = 0;

//static sqlite3_stmt *statement = nil;

@implementation DBManager

+(DBManager*)getSharedInstance
{
    if (!sharedInstance)
    {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance checkAndCreateDatabase];
    }
      return sharedInstance;
}



-(NSMutableArray *) readFromDataBase
{
	// Setup the database object
	sqlite3 *database;
    databasePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"SportzCardz.sqlite"];

	// Init the animals Array
	NSMutableArray *arrData = [[NSMutableArray alloc] init];
    
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = "select * from chattable where from_id ";
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
				// Read the data from the result row
                
              
				NSString *aName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
				NSString *abirthday = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                if([abirthday length]==0 ||[abirthday isEqual:[NSNull null]] )
                {
                    abirthday=@"No birthday";
                }
                
				NSString *aImageUrl = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                
                
                NSString *aLoginFrom=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                NSString *aid=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                
                 NSString *month=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                
                   NSString *event=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
                
                NSString *annver=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];

                NSDictionary *dicSelected=[[NSDictionary alloc]initWithObjectsAndKeys:aName,@"name",abirthday,@"birthday",aImageUrl,@"imageURL",aLoginFrom,@"LoginFrom",aid,@"id",month,@"month",event,@"event",[NSString stringWithFormat:@"%d",sqlite3_column_int(compiledStatement, 0)],@"sno",annver,@"anniversary", nil];
                
                [arrData addObject:dicSelected];
				// Create a new animal object with the data from the database
//				Animal *animal = [[Animal alloc] initWithName:aName description:aDescription url:aImageUrl];
                
				// Add the animal object to the animals Array
//				[animals addObject:animal];
                
//				[animal release];
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
//        if (sqlite3_step(compiledStatement) == SQLITE_DONE)
//        {
//            
//        } else
//        {
//            //NSLog(@"Failed to add contact  %s",sqlite3_errmsg( database ));
//            
//        }
	}
  
	sqlite3_close(database);
    return arrData;
}
#pragma mark  insert Chat
-(void)insertnotfications:(NSDictionary *)aaValues
{
    // NSLog(@"%@",aaValues);
    
    databasePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"SportzCardz.sqlite"];
    
    const char *dbpath = [databasePath UTF8String];
    NSLog(@"%@",databasePath);
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO xmppChat ('message','fromUser','toUser','time','type') VALUES (?,?,?,?,?)"];
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_stmt *compiledStatement;
        if (sqlite3_prepare_v2(database, insert_stmt, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            
            sqlite3_bind_text(compiledStatement, 1, [[aaValues objectForKey:@"message"] UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(compiledStatement, 2, [[[[aaValues objectForKey:@"fromUser"] componentsSeparatedByString:@"@"] firstObject] UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(compiledStatement, 3, [[[[aaValues objectForKey:@"toUser"]componentsSeparatedByString:@"@" ]firstObject ]UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(compiledStatement, 4, [[aaValues objectForKey:@"time"] UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(compiledStatement, 5, [[aaValues objectForKey:@"type"] UTF8String], -1, SQLITE_TRANSIENT);
            
        }
        
        
        if (sqlite3_step(compiledStatement) == SQLITE_DONE)
        {
            NSLog(@"SUCCESS");
        } else
        {
            NSLog(@"Failed to add contact %s",sqlite3_errmsg( database ));
        }
        sqlite3_finalize(compiledStatement);
        sqlite3_close(database);
    }
    
}

#pragma mark  check NewUser
-(void)insertExistNumber:(NSString *)aaValues
{
    // NSLog(@"%@",aaValues);
    
    databasePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"SportzCardz.sqlite"];
    
    const char *dbpath = [databasePath UTF8String];
    NSLog(@"%@",databasePath);
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO User ('PhoneNo') VALUES (?)"];
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_stmt *compiledStatement;
        if (sqlite3_prepare_v2(database, insert_stmt, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            
            sqlite3_bind_text(compiledStatement, 1, [aaValues UTF8String], -1, SQLITE_TRANSIENT);
            

        }
        
        
        if (sqlite3_step(compiledStatement) == SQLITE_DONE)
        {
            NSLog(@"SUCCESS");
        } else
        {
            NSLog(@"Failed to add contact %s",sqlite3_errmsg( database ));
        }
        sqlite3_finalize(compiledStatement);
        sqlite3_close(database);
    }
    
}

- (NSMutableArray*)retrieveUserList
{
    
    databasePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"SportzCardz.sqlite"];
    
    NSMutableArray *objArray=[[NSMutableArray alloc]init];
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM User"] ;
        
        const char *insert_stmt = [query UTF8String];
        
        sqlite3_stmt *statement;
        
        NSLog(@"%@",query);
        
        if (sqlite3_prepare_v2(database,insert_stmt, -1, &statement, nil) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString * phoneNumber =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                [objArray addObject:phoneNumber];
                NSLog(@"%@",objArray);
                
            }
        }
        
        else
        {
            NSLog(@"No Data Found");
        }
        
        sqlite3_close(database);
    }
    
    return objArray;
}

-(void)deleteAllUser
{
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"DELETE FROM User"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Deleted");
                
            }
            else
            {
                NSLog(@"Errroe");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(database);
    }
    
}


#pragma mark  bookmark
-(void)insertBookmark:(NSDictionary *)aaValues
{
  NSLog(@"%@",aaValues);
    
    databasePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"SportzCardz.sqlite"];

    const char *dbpath = [databasePath UTF8String];
    NSLog(@"%@",databasePath);
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO bookmark ('message','fromUser','toUser','time','type','index','section') VALUES (?,?,?,?,?,?,?)"];
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_stmt *compiledStatement;
        if (sqlite3_prepare_v2(database, insert_stmt, -1, &compiledStatement, NULL) == SQLITE_OK)
        {

            sqlite3_bind_text(compiledStatement, 1, [[aaValues objectForKey:@"message"] UTF8String], -1, SQLITE_TRANSIENT);

            sqlite3_bind_text(compiledStatement, 2, [[[[aaValues objectForKey:@"fromUser"] componentsSeparatedByString:@"@"] firstObject] UTF8String], -1, SQLITE_TRANSIENT);

            sqlite3_bind_text(compiledStatement, 3, [[[[aaValues objectForKey:@"toUser"]componentsSeparatedByString:@"@" ]firstObject ]UTF8String], -1, SQLITE_TRANSIENT);
            
             sqlite3_bind_text(compiledStatement, 4, [[aaValues objectForKey:@"time"] UTF8String], -1, SQLITE_TRANSIENT);
            
             sqlite3_bind_text(compiledStatement, 5, [[aaValues objectForKey:@"type"] UTF8String], -1, SQLITE_TRANSIENT);
            
             sqlite3_bind_text(compiledStatement, 6, [[aaValues objectForKey:@"index"] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 7, [[aaValues objectForKey:@"section"] UTF8String], -1, SQLITE_TRANSIENT);

        }
      

        if (sqlite3_step(compiledStatement) == SQLITE_DONE)
        {
           NSLog(@"SUCCESS");
        } else
        {
            NSLog(@"Failed to add contact %s",sqlite3_errmsg( database ));
        }
        sqlite3_finalize(compiledStatement);
        sqlite3_close(database);
    }
   
}

- (NSMutableArray*)retrieveBookmarkDataBetweenFrom_ID:(NSString*)from_id 
{
    
    databasePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"SportzCardz.sqlite"];
    
    NSMutableArray *objArray=[[NSMutableArray alloc]init];
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM bookmark"] ;
      
        const char *insert_stmt = [query UTF8String];
        
        sqlite3_stmt *statement;
        
        NSLog(@"%@",query);
        
        if (sqlite3_prepare_v2(database,insert_stmt, -1, &statement, nil) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *message=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                NSString *to_id=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                NSString *from_id=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                NSString * time=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,4)];
                NSString *type=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                 NSString *index=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,6)];
                NSString *section   =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,7)];
                NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:message,@"message",to_id,@"to_id",from_id,@"from_id",time,@"time",type,@"type",index,@"index",section,@"section", nil];
                
                [objArray addObject:dic];
                
            }
        }
        
        else
        {
            NSLog(@"No Data Found");
        }
        
        sqlite3_close(database);
    }
    
    return objArray;
}



-(void)deleteBookmark:(NSDictionary *)dic {
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"DELETE FROM bookmark where time = %@",[dic objectForKey:@"time"]];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Deleted");
                
            }
            else
            {
                NSLog(@"Errroe");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(database);
    }
    
}





#pragma mark  reminder
-(void)insertReminder:(NSDictionary *)reminderDicValues
{
    NSLog(@"%@",reminderDicValues);
    
    databasePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"SportzCardz.sqlite"];
    
    const char *dbpath = [databasePath UTF8String];
    NSLog(@"%@",databasePath);
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO reminder ('message','fromUser','toUser','time','type','index', 'contactDetail','reminderTime','msgType','reminderTittle','section','uid') VALUES (?,?,?,?,?,?,?,?,?,?,?,?)"];
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_stmt *compiledStatement;
        if (sqlite3_prepare_v2(database, insert_stmt, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            
            sqlite3_bind_text(compiledStatement, 1, [[reminderDicValues objectForKey:@"message"] UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(compiledStatement, 2, [[[[reminderDicValues objectForKey:@"fromUser"] componentsSeparatedByString:@"@"] firstObject] UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(compiledStatement, 3, [[[[reminderDicValues objectForKey:@"toUser"]componentsSeparatedByString:@"@" ]firstObject ]UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(compiledStatement, 4, [[reminderDicValues objectForKey:@"time"] UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(compiledStatement, 5, [[reminderDicValues objectForKey:@"type"] UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(compiledStatement, 6, [[reminderDicValues objectForKey:@"index"] UTF8String], -1, SQLITE_TRANSIENT);
            
             sqlite3_bind_text(compiledStatement, 7, [[reminderDicValues objectForKey:@"contactDetail"] UTF8String], -1, SQLITE_TRANSIENT);
            
             sqlite3_bind_text(compiledStatement, 9, [[reminderDicValues objectForKey:@"msgType"] UTF8String], -1, SQLITE_TRANSIENT);
            
             sqlite3_bind_text(compiledStatement, 8, [[reminderDicValues objectForKey:@"reminderTime"] UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(compiledStatement, 10, [[reminderDicValues objectForKey:@"reminderTittle"] UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(compiledStatement, 11, [[reminderDicValues objectForKey:@"section"] UTF8String], -1, SQLITE_TRANSIENT);
            
             sqlite3_bind_text(compiledStatement, 12, [[reminderDicValues objectForKey:@"uid"] UTF8String], -1, SQLITE_TRANSIENT);
            
        }
        
        
        if (sqlite3_step(compiledStatement) == SQLITE_DONE)
        {
            NSLog(@"SUCCESS");
        } else
        {
            NSLog(@"Failed to add contact %s",sqlite3_errmsg( database ));
        }
        sqlite3_finalize(compiledStatement);
        sqlite3_close(database);
    }
    
}

- (NSMutableArray*)retrieveReminderDataBetweenFrom_ID:(NSString *)from_id
{
    
    databasePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"SportzCardz.sqlite"];
    
    NSMutableArray *objArray=[[NSMutableArray alloc]init];
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM reminder"] ;
        
        const char *insert_stmt = [query UTF8String];
        
        sqlite3_stmt *statement;
        
        NSLog(@"%@",query);
        
        if (sqlite3_prepare_v2(database,insert_stmt, -1, &statement, nil) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *message=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                NSString *to_id=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                NSString *from_id=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                NSString * time=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,4)];
                NSString *type=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                NSString *index=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,6)];
          
                NSString * contact =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                NSString * msgDisplay =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                NSString * reminderTime =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                
                NSString * reminderTittle =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                
                 NSString * section =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                 NSString * uid =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                
                NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:message,@"message",to_id,@"to_id",from_id,@"from_id",time,@"time",type,@"type",index,@"index",msgDisplay,@"msgDisplay",contact,@"contact",reminderTime,@"ReminderTime",reminderTittle,@"reminderTittle",section,@"section",uid, @"uid",nil];
                
                [objArray addObject:dic];
                
            }
        }
        
        else
        {
            NSLog(@"No Data Found");
        }
        
        sqlite3_close(database);
    }
    
    return objArray;
}


-(void)deleteReminder:(NSDictionary *)dic {
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"DELETE FROM reminder where uid =\"%@\"" ,[dic objectForKey:@"uid"]];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Deleted");
                
            }
            else
            {
                 NSLog(@"error =   %s",sqlite3_errmsg(database));
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(database);
    }
    
}




#pragma mark-deleteAllChatHistory-
-(void)deleteAllChatHistory:(NSDictionary *)dic
{
    //NSLog(@"%@",dic);
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"DELETE FROM allNotification where (name=\"%@\" and id=\"%@\" and event=\"%@\")",[dic valueForKey:@"name"],[dic valueForKey:@"id"],[dic valueForKey:@"event"]];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                
                
            }
            else
            {
                
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(database);
    }
    
}


- (NSMutableArray*)retrieveChatDataBetweenFrom_ID:(NSString*)from_id andTo_ID:(NSString*)to_id
{
    
    databasePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"SportzCardz.sqlite"];

    NSMutableArray *objArray=[[NSMutableArray alloc]init];
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
         NSString *query = [NSString stringWithFormat:@"SELECT * FROM xmppChat WHERE ((toUser= '%@' AND fromUser = '%@') OR (toUser= '%@' AND fromUser = '%@'))",to_id, from_id, from_id, to_id];
//        NSString *query = [NSString stringWithFormat:@"SELECT * FROM xmppChat WHERE (fromUser = \"%@\" AND toUser = \"%@\" )",from_id, to_id];
        const char *insert_stmt = [query UTF8String];
        
        sqlite3_stmt *statement;

        NSLog(@"%@",query);
        
        if (sqlite3_prepare_v2(database,insert_stmt, -1, &statement, nil) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *message=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                 NSString *to_id=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                 NSString *from_id=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                 NSString * time=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
              NSString *type=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                
                NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:message,@"message",to_id,@"to_id",from_id,@"from_id",time,@"time",type,@"type", nil];
               
               [objArray addObject:dic];
             
            }
        }
        
        else
        {
            NSLog(@"No Data Found");
        }
        
        sqlite3_close(database);
    }
    
    return objArray;
}


#pragma mark  AllUserFromSavedChat
- (NSMutableArray*)retrieveUserNumberFromSavedChat
{
    
    databasePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"SportzCardz.sqlite"];
    
    NSMutableArray *objArray=[[NSMutableArray alloc]init];
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM xmppChat"];
        //        NSString *query = [NSString stringWithFormat:@"SELECT * FROM xmppChat WHERE (fromUser = \"%@\" AND toUser = \"%@\" )",from_id, to_id];
        const char *insert_stmt = [query UTF8String];
        
        sqlite3_stmt *statement;
        
        NSLog(@"%@",query);
        
        if (sqlite3_prepare_v2(database,insert_stmt, -1, &statement, nil) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
             
              // NSString *to_id=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                NSString *from_id=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];

                
               // NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:from_id,@"from_id", nil];
                
                [objArray addObject:from_id];
                
            }
        }
        
        else
        {
            NSLog(@"No Data Found");
        }
        
        sqlite3_close(database);
    }
    
    return objArray;
}


#pragma mark  retrieve Last Message
- (NSMutableArray*)retrieveLastMessageBetweenFrom_ID:(NSString*)from_id andTo_ID:(NSString*)to_id
{
    
    databasePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"SportzCardz.sqlite"];
    
    NSMutableArray *objArray=[[NSMutableArray alloc]init];
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        //SELECT * FROM table ORDER BY column DESC LIMIT 1;
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM xmppChat WHERE ((toUser= '%@' AND fromUser = '%@') OR (toUser= '%@' AND fromUser = '%@')) ORDER BY rowid DESC LIMIT 1",to_id, from_id, from_id, to_id];
       
        const char *insert_stmt = [query UTF8String];
        
        sqlite3_stmt *statement;
        
        NSLog(@"%@",query);
        
        if (sqlite3_prepare_v2(database,insert_stmt, -1, &statement, nil) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *message=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                NSString *to_id=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                NSString *from_id=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                NSString * time=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                NSString *type=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                
                NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:message,@"message",to_id,@"to_id",from_id,@"from_id",time,@"time",type,@"type", nil];
                
                [objArray addObject:dic];
           
            }
        }
        
        else
        {
            NSLog(@"No Data Found");
        }
        
        sqlite3_close(database);
    }
    
    return objArray;
}








-(void)insertGroupChatNotificationIntoGroupChatTable:(NSDictionary *)values

{
    NSMutableArray *arrallChat=[self retrieveallGroupchat];
    
    NSLog(@"%@",[arrallChat valueForKey:@"msg_id"]);
     NSLog(@"%@",values);
    NSLog(@"INSERTED -> %d",[[arrallChat valueForKey:@"msg_id"] containsObject:[values objectForKey:@"msg_id"]]);
  
    if(![[arrallChat valueForKey:@"msg_id"] containsObject:[values objectForKey:@"msg_id"]])
    {
    
    databasePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"EmojiData.sqlite"];
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat: @"insert into group_chat (msg_id,group_id,user_id,msg_type,messege,caption,time,user_profile_img) VALUES (?,?,?,?,?,?,?,?)"];
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_stmt *compiledStatement;
        if (sqlite3_prepare_v2(database, insert_stmt, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            
            sqlite3_bind_text(compiledStatement, 1, [[NSString stringWithFormat:@"%@",[values valueForKey:@"msg_id"]] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 2,[[NSString stringWithFormat:@"%@",[values valueForKey:@"group_id"] ] UTF8String] , -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 3,[[NSString stringWithFormat:@"%@",[values valueForKey:@"user_id"] ] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 4,[[NSString stringWithFormat:@"%@",[values valueForKey:@"msg_type"] ] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 5,[[NSString stringWithFormat:@"%@",[values valueForKey:@"messege"] ] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 6,[[NSString stringWithFormat:@"%@",[values valueForKey:@"caption"] ] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 7, [[NSString stringWithFormat:@"%@",[values valueForKey:@"time"] ] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 8, [[NSString stringWithFormat:@"%@",[values valueForKey:@"user_profile_img"] ] UTF8String], -1, SQLITE_TRANSIENT);
            
        }
        
        
        if (sqlite3_step(compiledStatement) == SQLITE_DONE)
        {
                    NSLog(@"Failed to add contact  %s",sqlite3_errmsg( database ));
        } else
        {
                      NSLog(@"Failed to add contact  %s",sqlite3_errmsg( database ));
            
        }
        sqlite3_finalize(compiledStatement);
        sqlite3_close(database);
    }
    }
    
}


- (NSMutableArray*)retrieveallGroupchat
{
    
    databasePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"EmojiData.sqlite"];
    
    NSMutableArray *objArray=[[NSMutableArray alloc]init];
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM group_chat"];
        const char *insert_stmt = [query UTF8String];
        
        sqlite3_stmt *statement;
        
        NSLog(@"%@",query);
        
        if (sqlite3_prepare_v2(database,insert_stmt, -1, &statement, nil) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                //sno,msg_id,group_id,user_id,msg_type,messege,caption,time,user_profile_img
                NSString *msg_id=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                NSString *group_id=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                NSString *user_id=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                NSString *msg_type=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                NSString *messege=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                NSString *caption=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                NSString *time=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                NSString *profile_img =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                
                
                NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:msg_id,@"msg_id",group_id,@"group_id",user_id,@"user_id",msg_type,@"msg_type",messege,@"messege",caption,@"caption",time,@"time",profile_img,@"user_profile_img", nil];
                
                [objArray addObject:dic];
            }
        }
        
        else
        {
            NSLog(@"No Data Found");
        }
        
        sqlite3_close(database);
    }
    
    return objArray;
}


- (NSMutableArray*)retrieveGroupChat:(NSString *)groupId
{
    
    databasePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"EmojiData.sqlite"];
    
    NSMutableArray *objArray=[[NSMutableArray alloc]init];
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM group_chat WHERE group_id = '%@'",groupId];
        const char *insert_stmt = [query UTF8String];
        
        sqlite3_stmt *statement;
        
        NSLog(@"%@",query);
        
        if (sqlite3_prepare_v2(database,insert_stmt, -1, &statement, nil) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                //sno,msg_id,group_id,user_id,msg_type,messege,caption,time
                NSString *msg_id=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                NSString *group_id=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                NSString *user_id=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                NSString *msg_type=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                NSString *messege=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                NSString *caption=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                NSString *time=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                NSString *profile_img =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                
                NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:msg_id,@"msg_id",group_id,@"group_id",user_id,@"user_id",msg_type,@"msg_type",messege,@"messege",caption,@"caption",time,@"time",profile_img,@"user_profile_img", nil];
                
                [objArray addObject:dic];
            }
        }
        
        else
        {
            NSLog(@"No Data Found");
        }
        
        sqlite3_close(database);
    }
    
    return objArray;
}

#pragma mark-deleteAllChatHistory-
-(void)deleteGroupChatHistory
{
    //NSLog(@"%@",dic);
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"DELETE * FROM group_chat"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                
                
            }
            else
            {
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(database);
    }
    
}


-(void)deleteEntryAfter:(NSTimer *)timer
{
   
    
    
    
    if (iii == 10)
    {
        NSLog(@"delete particular record form the database");
        [self deleteParticularOneToOneChat:timer.userInfo];
        [timer invalidate];
       
     
    } else
    {
        iii++;
    }
    
}

-(void)deleteParticularOneToOneChat:(NSDictionary *)dic
{
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"DELETE FROM chattable where ( time=%@ )",[dic objectForKey:@"time"]];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Deleted");
                
            }
            else
            {
                NSLog(@"Errroe");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(database);
    }

}

-(void) checkAndCreateDatabase{
    // Check if the SQL database has already been saved to the users phone, if not then copy it over
    BOOL success;
databasePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
                              stringByAppendingPathComponent: @"SportzCardz.sqlite"];
    
    NSLog(@"%@",databasePath);
    // Create a FileManager object, we will use this to check the status
    // of the database and to copy it over if required
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Check if the database has already been created in the users filesystem
    success = [fileManager fileExistsAtPath:databasePath];
    
    // If the database already exists then return without doing anything
    if(success) return;
    
    // If not then proceed to copy the database from the application to the users filesystem
    
    // Get the path to the database in the application package
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"SportzCardz.sqlite"];
    
    // Copy the database from the package to the users filesystem
    [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
    
    //[fileManager release];
}

- (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *) filePathString
{
    NSURL* URL= [NSURL fileURLWithPath: filePathString];
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

#pragma mark  enter profile data
-(void)profileData:(NSDictionary *)profileValues
{
    // NSLog(@"%@",aaValues);
    NSString *Str = @"0";
    
    databasePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Shabbat.sqlite"];
    
    const char *dbpath = [databasePath UTF8String];
    NSLog(@"%@",databasePath);
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO Profile ('Name','Price','Speed','Tackle','Pass','Skill','Shoot','Defence','Attack','Position','Power','Image','Screenshot','Template','Height','Weight','DOB','Age','Coach','Season') VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"];
        
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_stmt *compiledStatement;
        if (sqlite3_prepare_v2(database, insert_stmt, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            
            sqlite3_bind_text(compiledStatement, 1, [[profileValues objectForKey:@"Name"]UTF8String], -1, SQLITE_TRANSIENT);
            
            if ([profileValues objectForKey:@"Price"])
            {
                sqlite3_bind_text(compiledStatement, 2, [[profileValues objectForKey:@"Price"]UTF8String], -1, SQLITE_TRANSIENT);
            }
            else
            {
                sqlite3_bind_text(compiledStatement, 2, [Str UTF8String], -1, SQLITE_TRANSIENT);
            }

            if ([profileValues objectForKey:@"Speed"])
            {
              sqlite3_bind_text(compiledStatement, 3, [[profileValues objectForKey:@"Speed"]UTF8String], -1, SQLITE_TRANSIENT);
            }
            else
            {
              sqlite3_bind_text(compiledStatement, 3, [Str UTF8String], -1, SQLITE_TRANSIENT);
            }
            

            if ([profileValues objectForKey:@"Tackle"])
            {
             sqlite3_bind_text(compiledStatement, 4, [[profileValues objectForKey:@"Tackle"] UTF8String], -1, SQLITE_TRANSIENT);
            }
            else
            {
              sqlite3_bind_text(compiledStatement, 4, [Str UTF8String], -1, SQLITE_TRANSIENT);
            }

            if ([profileValues objectForKey:@"Pass"])
            {
              sqlite3_bind_text(compiledStatement, 5, [[profileValues objectForKey:@"Pass"] UTF8String], -1, SQLITE_TRANSIENT);
            }
            else
            {
              sqlite3_bind_text(compiledStatement, 5, [Str UTF8String], -1, SQLITE_TRANSIENT);
            }
            
            if ([profileValues objectForKey:@"Skill"])
            {
              sqlite3_bind_text(compiledStatement, 6, [[profileValues objectForKey:@"Skill"] UTF8String], -1, SQLITE_TRANSIENT);
            }

            else
            {
              sqlite3_bind_text(compiledStatement, 6, [Str UTF8String], -1, SQLITE_TRANSIENT);
            }
            
            if ([profileValues objectForKey:@"Shoot"])
            {
              sqlite3_bind_text(compiledStatement, 7, [[profileValues objectForKey:@"Shoot"] UTF8String], -1, SQLITE_TRANSIENT);
            }

            else
            {
              sqlite3_bind_text(compiledStatement, 7, [Str UTF8String], -1, SQLITE_TRANSIENT);
            }
            
            if ([profileValues objectForKey:@"Defence"])
            {
              sqlite3_bind_text(compiledStatement, 8, [[profileValues objectForKey:@"Defence"] UTF8String], -1, SQLITE_TRANSIENT);
            }
            else
            {
              sqlite3_bind_text(compiledStatement, 8, [Str UTF8String], -1, SQLITE_TRANSIENT);
            }
            
            if ([profileValues objectForKey:@"Attack"])
            {
              sqlite3_bind_text(compiledStatement, 9, [[profileValues objectForKey:@"Attack"] UTF8String], -1, SQLITE_TRANSIENT);
            }
            else
            {
              sqlite3_bind_text(compiledStatement, 9, [Str UTF8String], -1, SQLITE_TRANSIENT);
            }
           
            
            if ([profileValues objectForKey:@"Position"])
            {
               sqlite3_bind_text(compiledStatement, 10, [[profileValues objectForKey:@"Position"] UTF8String], -1, SQLITE_TRANSIENT);
            }
            else
            {
             sqlite3_bind_text(compiledStatement, 10, [Str UTF8String], -1, SQLITE_TRANSIENT);
            }
            
            if ([profileValues objectForKey:@"Power"])
            {
               sqlite3_bind_text(compiledStatement, 11, [[profileValues objectForKey:@"Power"] UTF8String], -1, SQLITE_TRANSIENT);
            }
            else
            {
              sqlite3_bind_text(compiledStatement, 11, [Str UTF8String], -1, SQLITE_TRANSIENT);
            }
            


            sqlite3_bind_text(compiledStatement, 12, [[profileValues objectForKey:@"Image"] UTF8String], -1, SQLITE_TRANSIENT);
            

            sqlite3_bind_text(compiledStatement, 13, [[profileValues objectForKey:@"Screenshot"] UTF8String], -1, SQLITE_TRANSIENT);
            

            sqlite3_bind_text(compiledStatement, 14, [[profileValues objectForKey:@"Template"] UTF8String], -1, SQLITE_TRANSIENT);

            if ([profileValues objectForKey:@"Height"])
            {
                sqlite3_bind_text(compiledStatement, 15, [[profileValues objectForKey:@"Height"] UTF8String], -1, SQLITE_TRANSIENT);
            }
            else
            {
                   sqlite3_bind_text(compiledStatement, 15, [Str UTF8String], -1, SQLITE_TRANSIENT);
            }
            if ([profileValues objectForKey:@"Weight"])
            {
                  sqlite3_bind_text(compiledStatement, 16, [[profileValues objectForKey:@"Weight"] UTF8String], -1, SQLITE_TRANSIENT);
            }
            else
            {
                sqlite3_bind_text(compiledStatement, 16, [Str UTF8String], -1, SQLITE_TRANSIENT);
            }
            if ([profileValues objectForKey:@"DOB"])
            {
                 sqlite3_bind_text(compiledStatement, 17, [[profileValues objectForKey:@"DOB"] UTF8String], -1, SQLITE_TRANSIENT);
            }
            else
            {
                sqlite3_bind_text(compiledStatement, 17, [Str UTF8String], -1, SQLITE_TRANSIENT);
            }
            if ([profileValues objectForKey:@"Age"])
            {
                 sqlite3_bind_text(compiledStatement, 18, [[profileValues objectForKey:@"Age"] UTF8String], -1, SQLITE_TRANSIENT);
            }
            else
            {
                sqlite3_bind_text(compiledStatement, 18, [Str UTF8String], -1, SQLITE_TRANSIENT);
            }

            if ([profileValues objectForKey:@"Coach"])
            {
                sqlite3_bind_text(compiledStatement, 19, [[profileValues objectForKey:@"Coach"] UTF8String], -1, SQLITE_TRANSIENT);
            }
            else
            {
                sqlite3_bind_text(compiledStatement, 19, [Str UTF8String], -1, SQLITE_TRANSIENT);
            }
            
            if ([profileValues objectForKey:@"Season"])
            {
                sqlite3_bind_text(compiledStatement, 20, [[profileValues objectForKey:@"Season"] UTF8String], -1, SQLITE_TRANSIENT);
            }
            else
            {
                sqlite3_bind_text(compiledStatement, 20, [Str UTF8String], -1, SQLITE_TRANSIENT);
            }

           
        }
        
        
        if (sqlite3_step(compiledStatement) == SQLITE_DONE)
        {
            NSLog(@"SUCCESS");
        } else
        {
            NSLog(@"Failed to add contact %s",sqlite3_errmsg( database ));
        }
        sqlite3_finalize(compiledStatement);
        sqlite3_close(database);
    }
    
}
#pragma mark  profile data
- (NSMutableArray*)retrieveProfile
{
    
    databasePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"SportzCardz.sqlite"];
    
    NSMutableArray *objArray=[[NSMutableArray alloc]init];
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM Profile"] ;
        
        const char *insert_stmt = [query UTF8String];
        
        sqlite3_stmt *statement;
        
        NSLog(@"%@",query);
        
        if (sqlite3_prepare_v2(database,insert_stmt, -1, &statement, nil) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
//                NSString * phoneNumber =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//                [objArray addObject:phoneNumber];
                
                
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                [dict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)] forKey:@"Name"];
                [dict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)] forKey:@"Price"];
                [dict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)] forKey:@"Speed"];
                [dict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)] forKey:@"Tackle"];
                [dict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)] forKey:@"Pass"];
                [dict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)] forKey:@"Skill"];
                [dict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)] forKey:@"Shoot"];
                [dict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)] forKey:@"Defence"];
                [dict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)] forKey:@"Attack"];
                [dict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)] forKey:@"Position"];
                [dict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)] forKey:@"Power"];
                [dict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)] forKey:@"Image"];
                [dict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)] forKey:@"Screenshot"];
                
                [dict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)] forKey:@"Template"];
                
                [dict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)] forKey:@"Height"];
                
                [dict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)] forKey:@"Weight"];
                
                [dict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)] forKey:@"DOB"];
                
                [dict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)] forKey:@"Age"];
                
                [dict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 19)] forKey:@"Coach"];
                [dict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 20)] forKey:@"Season"];
                
                [objArray addObject:dict];
              
                
                
                
            }
        }
        
        else
        {
            NSLog(@"No Data Found");
        }
        
        sqlite3_close(database);
    }
    
    return objArray;
}
-(void)deleteParticularCard:(NSDictionary *)dic
{
    databasePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"SportzCardz.sqlite"];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat: @"DELETE FROM Profile where Image =\"%@\"" ,[dic objectForKey:@"Image"]];

        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Deleted");
                
            }
            else
            {
                NSLog(@"Errroe");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(database);
    }
    
}

@end
