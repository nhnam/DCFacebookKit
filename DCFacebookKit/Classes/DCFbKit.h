//
//  DCFbKit.h
//  DCFacebookKit
//
//  Created by Nam Nguyen on 10/15/13.
//  Copyright (c) 2013 namnguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifdef __IPHONE_6_0
#import <Social/Social.h>
#endif
#import "UIAlertView+Utilities.h"

@interface DCFbKit : NSObject
@property (strong, nonatomic) NSMutableArray *listFriends;
+ (DCFbKit*) sharedKit;
- (void) login:(void(^)(BOOL status,NSObject *response))handler;
- (void) postText:(NSString*)text callback:(void(^)(BOOL status,NSObject *response))handler;
- (void) getFriendsListWithHandler:(void(^)(BOOL status,NSObject *response))handler;
@end
