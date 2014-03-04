//
//  WECoreDataHandling.h
//  WEShopping
//
//  Created by Unbounded on 2/16/14.
//  Copyright (c) 2014 Unbounded. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "category.h"
#import "WEWebAPIClient.h"
@protocol WECoreDataDelegate
-(void) ShoppingListAdded;
@end
@interface WECoreDataHandling : NSObject<WebServiceDelegate>
@property (strong) id delegate;
@property (strong) NSManagedObjectContext *managedObjectContext;
@property (strong) NSFetchedResultsController    *fetchedResultsController;
@property (strong) category *category;
-(id)initWithAppdelegate;
-(void)createShoppingItem:(NSString*)categoryName Item:(NSString*)itemName;
@end
