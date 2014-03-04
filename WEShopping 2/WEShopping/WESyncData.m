//
//  WESyncData.m
//  WEShopping
//
//  Created by Unbounded on 2/17/14.
//  Copyright (c) 2014 Unbounded. All rights reserved.
//

#import "WESyncData.h"
#import "category.h"
#import "items.h"
#import "WEWebAPIClient.h"
#import "WEAppDelegate.h"
#import "DeletedItems.h"
@implementation WESyncData

//Creates data on the webservices that was created offine on locals system
-(void)createOfflineData
{
    WEAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //    NSSortDescriptor tells defines how to sort the fetched results
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"itemName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    //    fetchRequest needs to know what entity to fetch
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Items" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    
    NSError *error;
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"webid =0"]; 
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    fetchRequest.predicate=predicate;
    if (![[self fetchedResultsController] performFetch:&error])
    {
        // Handle error
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    NSArray *itemsContext=[self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if ([itemsContext count] >= 1)
    {
        NSArray *fetchedObjects =self.fetchedResultsController.fetchedObjects ;
        for (items *createItem in fetchedObjects)
        {
            category *tempCategory=createItem.inCategory;
            NSArray *temp=[self postRequest:createItem.itemName Item:tempCategory.categoryName];
            [createItem setValue:[temp objectAtIndex:1]  forKey:@"webid"];
            [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"YYYY-MM-DD HH:MM:SS ±HHMM"];
            NSDate *dateFromString = [dateFormatter dateFromString:[temp objectAtIndex:0]];
            //item.webUpdatedTime=dateFromString;
            [createItem setValue:dateFromString forKey:@"webUpdatedTime"];
            [self.managedObjectContext save:&error];
            
        }
    }
    [self deleteOfflineData];
}
-(NSArray*) postRequest:(NSString*)CategoryName Item:(NSString*)itemName
{
    NSError *error;
    WEAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    if ((appDelegate.internetConnnectionStatus || appDelegate.wifiConnectionStatus)&&appDelegate.hostReachabilityStatus)
    {
        NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:itemName, @"name", CategoryName, @"category", nil];
        
        //convert object to data
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions error:&error];
        NSURL *url = [NSURL URLWithString: @"https://cmshopper.herokuapp.com/items.json"];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        [theRequest setValue:@"a14ab7992ba34ac038be02954e99e1f5" forHTTPHeaderField:@"X-CM-Authorization"];
        [theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [theRequest setHTTPMethod:@"POST"];
        [theRequest setHTTPBody:jsonData];
        NSURLResponse *urlResponse;
        NSData *data = [ NSURLConnection sendSynchronousRequest:theRequest returningResponse: &urlResponse error:&error ];
        NSDictionary *dicAlbumsData=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray *returData=[[NSArray alloc]initWithObjects:[dicAlbumsData objectForKey:@"updated_at"], [dicAlbumsData objectForKey:@"id"],nil];
        return returData;

    }
    return nil;
}


-(void) deleteOfflineData
{
    WEAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //    NSSortDescriptor tells defines how to sort the fetched results
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"webID" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    //    fetchRequest needs to know what entity to fetch
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DeletedItems" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    
    NSError *error;
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"webID !=0"];
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    fetchRequest.predicate=predicate;
    if (![[self fetchedResultsController] performFetch:&error])
    {
        // Handle error
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    NSArray *itemsContext=[self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if ([itemsContext count] >= 1)
    {
        WEWebAPIClient *client=[[WEWebAPIClient alloc]init];
        NSArray *fetchedObjects =self.fetchedResultsController.fetchedObjects ;
        for (DeletedItems *deleteItem in fetchedObjects)
        {
           if ([client deleteRequest:deleteItem.webID])
           {
               [self.managedObjectContext deleteObject:deleteItem];
               [self.managedObjectContext save:nil];
           }
        }
    }

}
@end
