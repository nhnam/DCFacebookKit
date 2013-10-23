//
//  Macro.h
//  DCFacebookKit
//
//  Created by Nam Nguyen on 10/15/13.
//  Copyright (c) 2013 namnguyen. All rights reserved.
//

#ifndef DCFacebookKit_Macro_h
#define DCFacebookKit_Macro_h

// Facebook Services
#define kFBSessionChangeNotify              @"com.namnguyen.dcfbkit:FBSessionStateChangedNotification";
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define strF(...) [NSString stringWithFormat:__VA_ARGS__]
#define DLog(...) NSLog(@"[%s(line %d)]|-> %@",  __PRETTY_FUNCTION__, __LINE__ , [NSString stringWithFormat:__VA_ARGS__])
#endif
