//
//  WEAddShoppingToList.h
//  WEShopping
//
//  Created by Unbounded on 2/16/14.
//  Copyright (c) 2014 Unbounded. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "WECoreDataHandling.h"
@protocol WEADDShoppingDelegate
-(void)shoppingAdded;
@end
@interface WEAddShoppingToList : UIViewController<WECoreDataDelegate>
@property (strong) id delegate;
@property (strong, nonatomic) IBOutlet UITextField *textboxCategoryTile;
@property (strong, nonatomic) IBOutlet UITextField *textboxcategoryItemTitle;
- (IBAction)addToShopping_TouchUpInside:(UIButton *)sender;
@end
