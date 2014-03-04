//
//  WECoreDataHandling.m
//  WEShopping
//
//  Created by Unbounded on 2/16/14.
//  Copyright (c) 2014 Unbounded. All rights reserved.
//

#import "WECoreDataHandling.h"
#import "WEAppDelegate.h"
#import "items.h"
#import "WEWebAPIClient.h"
NSString *ccategoryName;
NSString *citemName;
@implementation WECoreDataHandling
WEAppDelegate  *appDelegate;
-(id)initWithAppdelegate
{
    self=[super init];
    if (self)
    {
        
        appDelegate = [UIApplication sharedApplication].delegate;
        self.managedObjectContext = appDelegate.managedObjectContext;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        //    NSSortDescriptor tells defines how to sort the fetched results
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
        //    fetchRequest needs to know what entity to fetch
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    }
    return self;
}


-(void)webServiceData:(BOOL)executed date:(NSString *)dateUpdated webID:(NSNumber*)webID
{

        NSError *error;
        if (![self checkCategoryExits:ccategoryName])
        {
            category * newEntry =(category *) [NSEntityDescription insertNewObjectForEntityForName:@"Category"
                                                                            inManagedObjectContext:self.managedObjectContext];
            newEntry.categoryName=ccategoryName;
            newEntry.dateModified=[NSDate date];
            newEntry.dateCreated=[NSDate date];
            self.category=newEntry;
            if (![self.managedObjectContext save:&error])
            {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
        }
        else
        {
            [self createItemInCategory:citemName webID:webID date:dateUpdated];
            [self.delegate ShoppingListAdded];
            
            return;
        }
        [self createItemInCategory:citemName webID:webID date:dateUpdated];
        [self.delegate ShoppingListAdded];
}
-(void) createItemInCategory:(NSString*)itemName webID:(NSNumber*)webID date:(NSString*)dateUpdated
{
    NSError *error;
    items  * item = [NSEntityDescription insertNewObjectForEntityForName:@"Items"
                                                              inManagedObjectContext:self.managedObjectContext];
    item.itemName=itemName;
    item.dateModified=[NSDate date];
    item.dateCreated=[NSDate date];
    if (dateUpdated!=nil)
    {
        //[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-DD HH:MM:SS"];
        item.webid=webID;
        dateUpdated=[dateUpdated stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        dateUpdated=[dateUpdated stringByReplacingOccurrencesOfString:@"Z" withString:@" "];
        NSDate *dateFromString = [dateFormatter dateFromString:dateUpdated];
        item.webUpdatedTime=dateFromString;
        
    }
    [item setInCategory:self.category];
    if (![self.managedObjectContext save:&error])
    {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}
-(void)createShoppingItem:(NSString*)categoryName Item:(NSString*)itemName
{   ccategoryName=categoryName;
    citemName=itemName;
    if ([categoryName length]!=0 && categoryName !=nil)
    {
        WEWebAPIClient *webService=[[WEWebAPIClient alloc]init];
        webService.delegate=self;
        [webService postRequest:categoryName Item:itemName];
    }
    else
    {
        //alert for missing cateory name
    }
}
-(BOOL)checkCategoryExits:(NSString*)categoryName
{
    NSError *error;
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"categoryName  contains[cd] %@", categoryName];
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    if (![[self fetchedResultsController] performFetch:&error])
    {
        // Handle error
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    if ([self.fetchedResultsController.fetchedObjects count] >= 1)
    {
        NSArray *fetchedObjects =self.fetchedResultsController.fetchedObjects ;
        self.category=[fetchedObjects objectAtIndex:0];
        return YES;
        
    }
    return NO;
}
@end
