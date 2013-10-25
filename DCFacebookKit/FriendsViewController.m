//
//  FriendsViewController.m
//  DCFacebookKit
//
//  Created by namnguyen on 10/24/13.
//  Copyright (c) 2013 namnguyen. All rights reserved.
//

#import "FriendsViewController.h"
#import "DCFbKit.h"
@interface FriendsViewController ()
@property (strong, nonatomic) NSMutableArray* filteredTableData;
@end

@implementation FriendsViewController
@synthesize tbFriends, filteredTableData;

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
    [tbFriends setDelegate:self];
    [tbFriends setDataSource:self];
    [tbFriends reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableview datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[DCFbKit sharedKit] listFriends] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIndentifier = @"CellID";
    UITableViewCell* cell =  [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    }
    NSDictionary* objectIndex = [[[DCFbKit sharedKit] listFriends] objectAtIndex:indexPath.row];
    [cell.textLabel setText:strF(@"%@",[objectIndex objectForKey:@"name"])];
    [cell.detailTextLabel setText:strF(@"ID: %@",[objectIndex objectForKey:@"id"])];
    return  cell;
}

@end
