//
//  WEAppDelegate.h
//  WEShopping
//
//  Created by Unbounded on 2/16/14.
//  Copyright (c) 2014 Unbounded. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Reachability.h"
@interface WEAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;
@property (nonatomic) Reachability *hostReachability;
@property BOOL internetConnnectionStatus;
@property BOOL wifiConnectionStatus;
@property BOOL hostReachabilityStatus;
@end
