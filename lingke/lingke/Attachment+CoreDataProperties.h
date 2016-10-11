//
//  Attachment+CoreDataProperties.h
//  lingke
//
//  Created by clz on 16/10/10.
//  Copyright © 2016年 CLZ. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Attachment.h"

NS_ASSUME_NONNULL_BEGIN

@interface Attachment (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *filename;
@property (nullable, nonatomic, retain) NSString *filepath;

@end

NS_ASSUME_NONNULL_END
