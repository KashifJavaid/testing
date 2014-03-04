//
//  category.h
//  WEShopping
//
//  Created by Unbounded on 2/17/14.
//  Copyright (c) 2014 Unbounded. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class items;

@interface category : NSManagedObject

@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSDate * dateModified;
@property (nonatomic, retain) NSSet *heldby;
@end

@interface category (CoreDataGeneratedAccessors)

- (void)addHeldbyObject:(items *)value;
- (void)removeHeldbyObject:(items *)value;
- (void)addHeldby:(NSSet *)values;
- (void)removeHeldby:(NSSet *)values;

@end
