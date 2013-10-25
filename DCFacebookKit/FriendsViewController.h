//
//  FriendsViewController.h
//  DCFacebookKit
//
//  Created by namnguyen on 10/24/13.
//  Copyright (c) 2013 namnguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbFriends;

@end
