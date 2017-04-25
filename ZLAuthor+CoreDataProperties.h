//
//  ZLAuthor+CoreDataProperties.h
//  coreDataDemo
//
//  Created by wdwk on 16/9/28.
//  Copyright © 2016年 wksc. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ZLAuthor.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZLAuthor (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *authorDescription;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<ZLBook *> *books;

@end

@interface ZLAuthor (CoreDataGeneratedAccessors)

- (void)addBooksObject:(ZLBook *)value;
- (void)removeBooksObject:(ZLBook *)value;
- (void)addBooks:(NSSet<ZLBook *> *)values;
- (void)removeBooks:(NSSet<ZLBook *> *)values;

@end

NS_ASSUME_NONNULL_END
