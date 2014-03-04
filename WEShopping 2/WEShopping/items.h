//
//  items.h
//  WEShopping
//
//  Created by Unbounded on 2/17/14.
//  Copyright (c) 2014 Unbounded. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class category;
//Changes done here
//hkdfdkjfdkhf
//hjghjghjg
//kashif new changes

@interface items : NSManagedObject

@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSDate * dateModified;
@property (nonatomic, retain) NSString * itemName;
@property (nonatomic, retain) NSNumber * webid;
@property (nonatomic, retain) NSDate * webUpdatedTime;
@property (nonatomic, retain) category *inCategory;

@end
