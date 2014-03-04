//
//  WEAddShoppingToList.m
//  WEShopping
//
//  Created by Unbounded on 2/16/14.
//  Copyright (c) 2014 Unbounded. All rights reserved.
//

#import "WEAddShoppingToList.h"
#import "WECoreDataHandling.h"
@interface WEAddShoppingToList ()

@end

@implementation WEAddShoppingToList

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)ShoppingListAdded
{
    [self.delegate shoppingAdded];
    [self dismissViewControllerAnimated:YES completion:nil];
   
}
- (IBAction)addToShopping_TouchUpInside:(UIButton *)sender
{
    WECoreDataHandling *dataHandling=[[WECoreDataHandling alloc]initWithAppdelegate];
    dataHandling.delegate=self;
    [dataHandling createShoppingItem:self.textboxCategoryTile.text Item:self.textboxcategoryItemTitle.text];
    
    
}
@end
