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
#import "fiveHundredPXAccountUIViewController.h"
#import "FancyTabbarController.h" 
#import "RLWebserviceClient.h"

@implementation AccountsUIViewController
@synthesize closeBtn=_closeBtn; 
@synthesize fancyTabbarController=_fancyTabbarController; 

-(UIBarButtonItem*) closeBtn
{
    
    if (!_closeBtn)
    {
        _closeBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closePage:)]; 
    }
    
    return _closeBtn; 
}


-(void) closePage:(id)sender
{
    if (self.fancyTabbarController)
        [self.fancyTabbarController gotoPreviousPage]; 
}

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
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated]; 
    
    self.navigationItem.title = @"Settings"; 
    self.navigationItem.rightBarButtonItem = self.closeBtn; 
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque; 
}

- (void)viewDidLoad
{
    accountCells = [[NSMutableDictionary alloc] initWithCapacity:5]; 
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [_closeBtn release]; 
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section ) {
        case 0:
            return [AccountManager standardAccountManager].NUMBER_OF_ACCOUNTS; 
            break;
        case 1:         //web service location 
            return 3; 
        default:
            return 0; 
    }
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
    } else if (indexPath.section==1) //this is the web service location 
    {
        UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil]; 
        [cell autorelease]; 
        
        switch (indexPath.row) {
            case RLWEBSERVICE_LAPTOP: 
                cell.textLabel.text = @"Laptop"; 
                break;
                
            case RLWEBSERVICE_MAC: 
                cell.textLabel.text = @"Mac"; 
                break;
                
            case RLWEBSERVICE_AMAZON:
                cell.textLabel.text = @"Amazon"; 
                break; 
                
            default:
                break;
        }
        
        if (indexPath.row == [RLWebserviceClient standardClient].webServiceLocation)
            cell.accessoryType = UITableViewCellAccessoryCheckmark; 
        
        return cell; 
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
    if (indexPath.section ==0)      //the account section 
    {
        AccountTableViewCell* cell = [accountCells objectForKey:[NSString stringWithFormat:@"%d", indexPath.row]]; 
        
        if (!cell) 
            return 60; 
        
        
        if (cell.status == ACCOUNTCELL_ACTIVE_EXPANDED)
            return 130; 
        else
            return 60; 
    }

    
    return 44;      //the default
}

-(void) reevaluateHeights
{
    [tableView beginUpdates];
    [tableView endUpdates];        
}

- (void)tableView:(UITableView *)tableViewLocal didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0)       //it's an account 
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
            
                FlickrAccount* fa = [[AccountManager standardAccountManager] flickrAccount]; 
                fa.apiContext.OAuthToken = nil; 
                fa.apiContext.OAuthTokenSecret = nil; 
            
                ((FlickrAccountUIViewController*)detailViewController).theAccount = [[AccountManager    standardAccountManager] flickrAccount] ; 
            
                break;
        
            case INSTAGRAM_INDEX: 
            
                break; 
            case FIVEHUNDREDPX_INDEX: 
                detailViewController = [[fiveHundredPXAccountUIViewController alloc] initWithNibName:@"fiveHundredPXAccountUIViewController" bundle:[NSBundle mainBundle]];
                
//                FiveHundredPXAccount* fha = [[AccountManager standardAccountManager] fiveHundredPXAccount]; 
//                fha.apiContext.OAuthToken = nil; 
//                fha.apiContext.OAuthTokenSecret = nil; 
                
                ((fiveHundredPXAccountUIViewController*)detailViewController).theAccount = [[AccountManager    standardAccountManager] fiveHundredPXAccount] ; 
           
                break;
            default:
                break;
        }
    
        if (detailViewController) 
        {
            self.navigationItem.rightBarButtonItem = nil; 
            [self.navigationController pushViewController:detailViewController animated:YES];
            [detailViewController release];
        }
        
    }//an account 
    else if (indexPath.section == 1) //service location
    {
        [RLWebserviceClient standardClient].webServiceLocation = indexPath.row; 
        
        [tableView reloadData]; 
    }
    
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Accounts"; 
        case 1:
            return @"Server Location"; 
            
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
