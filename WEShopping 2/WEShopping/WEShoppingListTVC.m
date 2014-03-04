//
//  WEShoppingListTVC.m
//  WEShopping
//
//  Created by Unbounded on 2/16/14.
//  Copyright (c) 2014 Unbounded. All rights reserved.
//

#import "WEShoppingListTVC.h"
#import "WEAppDelegate.h"
#import "category.h"
#import "WEAddShoppingToList.h"
#import "items.h"
#import "WEWebAPIClient.h"
#import "DeletedItems.h"
@interface WEShoppingListTVC ()

@end
@implementation WEShoppingListTVC
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    WEAppDelegate  *appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem *addButton=[[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(addShopping:)];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem=addButton;
    [self setupFetchedResultsController];
    
}
-(void)addShopping:(UIButton*)sender
{
    
    [self performSegueWithIdentifier:@"segAddShopping" sender:self];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segAddShopping"])
    {
        WEAddShoppingToList *addShoping=[segue destinationViewController];
        addShoping.delegate=self;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)shoppingAdded
{
    [self performFetch];
}
- (void)setupFetchedResultsController
{
	// 1 - Decide what Entity you want
	NSString *entityName = @"Category"; // Put your entity name here
	NSLog(@"Setting up a Fetched Results Controller for the Entity named %@", entityName);
    
	// 2 - Request that Entity
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
	// 3 - Filter it if you want
	//request.predicate = [NSPredicate predicateWithFormat:@"Person.name = Blah"];
    
	// 4 - Sort it if you want
	request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"categoryName"
																					 ascending:YES
																					  selector:@selector(localizedCaseInsensitiveCompare:)]];
	// 5 - Fetch it
	self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
																		managedObjectContext:self.managedObjectContext
																		  sectionNameKeyPath:nil
																				   cacheName:nil];
	[self performFetch];
}
-(void)setFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    NSFetchedResultsController *oldfrc = _fetchedResultsController;
    if (fetchedResultsController != oldfrc) {
        _fetchedResultsController = fetchedResultsController;
        fetchedResultsController.delegate = self;
        if ((!self.title || [self.title isEqualToString:oldfrc.fetchRequest.entity.name]) && (!self.navigationController || !self.navigationItem.title)) {
            self.title = fetchedResultsController.fetchRequest.entity.name;
        }
        if (fetchedResultsController)
        {
            [self performFetch];
        } else
        {
            [self.tableView reloadData];
        }
    }
}
- (void)performFetch
{
    if (self.fetchedResultsController) {
        if (self.fetchedResultsController.fetchRequest.predicate)
        {
            //if (self.debug) NSLog(@"[%@ %@] fetching %@ with predicate: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.fetchedResultsController.fetchRequest.entityName, self.fetchedResultsController.fetchRequest.predicate);
        } else
        {
            //if (self.debug) NSLog(@"[%@ %@] fetching all %@ (i.e., no predicate)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.fetchedResultsController.fetchRequest.entityName);
        }
        NSError *error;
        [self.fetchedResultsController performFetch:&error];
        //if (error) NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error localizedDescription], [error localizedFailureReason]);
    } else {
        //if (self.debug) NSLog(@"[%@ %@] no NSFetchedResultsController (yet?)", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    }
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //NSLog(@"%d",[[self.fetchedResultsController  count]);
    return [self.fetchedResultsController.fetchedObjects count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    category *temCategory=[self.fetchedResultsController.fetchedObjects objectAtIndex:section];
    return [[temCategory.heldby allObjects]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    category *temCategory=[self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.section];
    NSArray *Q =[temCategory.heldby allObjects];
    items *i=[Q objectAtIndex:indexPath.row];
    //WECoreDataHandling *a=[[WECoreDataHandling alloc]initWithAppdelegate];
    cell.textLabel.text=i.itemName;
    
    // Configure the cell...
   // cell
    return cell;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    //category *temCategory=[[[self.fetchedResultsController sections] objectAtIndex:section]name];
    category *temCategory=[self.fetchedResultsController.fetchedObjects objectAtIndex:section];
    return temCategory.categoryName;
}
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{//
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.tableView beginUpdates];
        // Delete the row from the data source
        category *itemToDelete = [self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.section];
        //NSLog(@"Deleting (%@)", itemToDelete.categoryName);
        NSArray *Q =[itemToDelete.heldby allObjects];
        items *i=[Q objectAtIndex:indexPath.row];
        WEWebAPIClient *webClient=[[WEWebAPIClient alloc]init];
        if (![webClient deleteRequest:[NSString stringWithFormat:@"%@", i.webid]])
        {
            [self addTODeleteList:[NSString stringWithFormat:@"%@", i.webid]];
        }
        [self.managedObjectContext deleteObject:i];
        [self.managedObjectContext save:nil];
        
        // Delete the (now empty) row on the table
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self performFetch];
        
        [self.tableView endUpdates];
    }
}
-(void) addTODeleteList:(NSString *)webID
{
    NSError *error;
    DeletedItems * newEntry =(DeletedItems *) [NSEntityDescription insertNewObjectForEntityForName:@"DeletedItems"
                                                                    inManagedObjectContext:self.managedObjectContext];
    newEntry.webID=webID;
    if (![self.managedObjectContext save:&error])
    {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}
/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
