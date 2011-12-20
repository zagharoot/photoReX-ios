//
//  AccountsUIViewController.m
//  photoReX
//
//  Created by Ali Nouri on 11/12/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "AccountsUIViewController.h"
#import "AccountManager.h"
#import "AccountTableViewCell.h"
#import "FlickrAccountUIViewController.h"

@implementation AccountsUIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    accountCells = [[NSMutableDictionary alloc] initWithCapacity:5]; 
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    
    [tableView release];
    tableView = nil;
    [super viewDidUnload];
    
    [accountCells release]; 
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma -mark TableView delegate functions 

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [AccountManager standardAccountManager].NUMBER_OF_ACCOUNTS; 
}

- (UITableViewCell *)tableView:(UITableView *)tableViewLocal cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)   //this is the account section 
    {
        static NSString *CellIdentifier = @"Cell";
        Account* account = [[AccountManager standardAccountManager] getAccountAtIndex:indexPath.row]; 
        CGRect frame = CGRectMake(0, 0, 320, 60); 
    
        AccountTableViewCell *cell = (AccountTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[AccountTableViewCell alloc] initWithFrame:frame andAccount:account andTableController:self] autorelease]; 
        }
    
        // Configure the cell...
        cell.theAccount = account; 
        [cell updateActiveImage]; 
   
        // add the cell to the account cell dictionary 
        [accountCells setValue:cell forKey:[NSString stringWithFormat:@"%d", indexPath.row]]; 
        
        return cell;
    } else if (indexPath.section==1) //this is the configs section
    {
        return nil; 
        
    }
    
    
    return nil; 
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

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

#pragma mark - Table view delegate


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AccountTableViewCell* cell = [accountCells objectForKey:[NSString stringWithFormat:@"%d", indexPath.row]]; 
    
    if (!cell) 
        return 60; 
    
    
    if (cell.status == ACCOUNTCELL_ACTIVE_EXPANDED)
        return 130; 
    else
        return 60; 
}

-(void) reevaluateHeights
{
    [tableView beginUpdates];
    [tableView endUpdates];        
}

- (void)tableView:(UITableView *)tableViewLocal didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //don't do anything if the account is already active
    if ([[AccountManager standardAccountManager] getAccountAtIndex:indexPath.row].isActive)
    {
        [self reevaluateHeights]; 
        return; 
    }
    
    
    // Navigation logic may go here. Create and push another view controller.
    
    UIViewController* detailViewController=nil; 
    
    //WEBSITE: 
    switch (indexPath.row) {
        case FLICKR_INDEX:
            detailViewController = [[FlickrAccountUIViewController alloc] initWithNibName:@"FlickrAccountUIViewController" bundle:[NSBundle mainBundle]];
            
            ((FlickrAccountUIViewController*)detailViewController).theAccount = [[AccountManager standardAccountManager] flickrAccount] ; 
            
            break;
        
        case INSTAGRAM_INDEX: 
            
            break; 
        case FIVEHUNDREDPX_INDEX: 
           
            
            break;
        default:
            break;
    }
    
    if (detailViewController) 
    {
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
    }
    
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Accounts"; 
            break;
            
        default:
            break;
    }

    return @""; 
}



- (void)dealloc {
    [tableView release];
    [super dealloc];
}
@end
