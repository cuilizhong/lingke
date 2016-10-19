//
//  AppDelegate.h
//  lingke
//
//  Created by clz on 16/8/21.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "PersionModel.h"
#import "Attachment.h"



@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;

- (NSURL *)applicationDocumentsDirectory;

- (void)insert:(PersionModel *)persionModel;

- (void)deletePersion:(PersionModel *)persionModel;

- (void)update:(PersionModel *)persionModel;

- (NSMutableArray <PersionModel *>*)selectAll;


- (void)insertFilename:(NSString *)filename filepath:(NSString *)filepath;

- (void)deleteFilename:(NSString *)filename;

- (void)updateFilename:(NSString *)filename filepath:(NSString *)filepath;

- (NSMutableArray <NSDictionary *>*)selectAllAttachments;

@end

