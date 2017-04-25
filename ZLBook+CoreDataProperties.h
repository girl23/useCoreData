//
//  ZLBook+CoreDataProperties.h
//  coreDataDemo
//
//  Created by wdwk on 16/9/28.
//  Copyright © 2016年 wksc. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ZLBook.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZLBook (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *publishHouse;
@property (nullable, nonatomic, retain) NSString *bookid;
@property (nullable, nonatomic, retain) ZLAuthor *author;

@end

NS_ASSUME_NONNULL_END
