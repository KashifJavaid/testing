//
//  WEShoppingListTVC.h
//  WEShopping
//
//  Created by Unbounded on 2/16/14.
//  Copyright (c) 2014 Unbounded. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "WEAddShoppingToList.h"
@interface WEShoppingListTVC : UITableViewController <NSFetchedResultsControllerDelegate,WEADDShoppingDelegate>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) BOOL suspendAutomaticTrackingOfChangesInManagedObjectContext;
@end
