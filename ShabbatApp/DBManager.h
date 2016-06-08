//
//  DBManager.h
//  GooglePlusSample
//
//  Created by WebAstral on 11/14/14.
//  Copyright (c) 2014 Google Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface DBManager : NSObject
{
    NSString *databasePath;
    
    NSString *databaseName;
}

+(DBManager*)getSharedInstance;
-(NSMutableArray *) readFromDataBase;
-(void)insertnotfications:(NSDictionary *)aaValues;
-(void)deleteAllChatHistory:(NSDictionary *)dic;
-(void)insertBookmark:(NSDictionary *)aaValues;
-(void)insertReminder :(NSDictionary * )reminderDicValues;
-(void)insertExistNumber:(NSString *)aaValues;
//-(NSMutableArray *) readSportEvent;

- (NSMutableArray*)retrieveChatDataBetweenFrom_ID:(NSString*)from_id andTo_ID:(NSString*)to_id;
- (NSMutableArray*)retrieveUserNumberFromSavedChat;
// bY me
- (NSMutableArray*)retrieveGroupChat:(NSString *)groupId;
-(void)insertGroupChatNotificationIntoGroupChatTable:(NSDictionary *)values;
-(void)deleteGroupChatHistory;
-(void)deleteAllUser;


-(void)deleteReminder:(NSDictionary *)dic ;


-(void)deleteBookmark:(NSDictionary *)dic;
//local notification

- (NSMutableArray*)retrieveBookmarkDataBetweenFrom_ID:(NSString*)from_id;
- (NSMutableArray*)retrieveReminderDataBetweenFrom_ID:(NSString*)from_id;
- (NSMutableArray*)retrieveLastMessageBetweenFrom_ID:(NSString*)from_id andTo_ID:(NSString*)to_id;
- (NSMutableArray*)retrieveUserList;


-(void)profileData:(NSDictionary *)profileValues;
- (NSMutableArray*)retrieveProfile;
-(void)deleteParticularCard:(NSDictionary *)dic;
@end