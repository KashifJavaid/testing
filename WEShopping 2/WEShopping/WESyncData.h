//
//  WESyncData.h
//  WEShopping
//
//  Created by Unbounded on 2/17/14.
//  Copyright (c) 2014 Unbounded. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface WESyncData : NSObject
@property (strong) NSManagedObjectContext *managedObjectContext;
@property (strong) NSFetchedResultsController    *fetchedResultsController;
-(void)createOfflineData;
@end
