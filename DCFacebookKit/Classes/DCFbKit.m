//
//  DCFbKit.m
//  DCFacebookKit
//
//  Created by Nam Nguyen on 10/15/13.
//  Copyright (c) 2013 namnguyen. All rights reserved.
//

#import "DCFbKit.h"
#import "AppDelegate.h"

#define ERR_USER_CANCELED @"com.facebook.sdk:UserLoginCancelled"
#define ERR_SYSTEM_CANCELED @"com.facebook.sdk:SystemLoginCancelled"
#define ERR_DISALLOWED @"com.facebook.sdk:SystemLoginDisallowedWithoutError"




@implementation DCFbKit

+ (DCFbKit*) sharedKit{
    static DCFbKit * staticInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticInstance = [[self alloc] init];
    });
    return staticInstance;
}

- (void) login:(void(^)(BOOL, NSObject*))handler{
    if (FBSession.activeSession.isOpen)
        handler(YES,FBSession.activeSession);
    else
        [self openSessionWithAllowLoginUI:YES handler:handler];
}

- (void) postText:(NSString*)text callback:(void(^)(BOOL status,NSObject *response))handler
{
    BOOL presented = [FBDialogs presentOSIntegratedShareDialogModallyFrom:[AppDelegate topMostController] initialText:@"InitialText" image:nil url:nil handler:^(FBOSIntegratedShareDialogResult result, NSError *error) {
        if(error) {
            DLog(@"Error: %@", error.description);
            if(handler)
                handler(NO, error);
        } else {
            DLog(@"Success!");
            if(handler)
                handler(YES, nil);
        }
    }];
    DLog(@"presented:%@", presented?@"DONE":@"FAIL");
    if(!presented)
    {
        // using url if you want to share a link
//        NSURL* url = [NSURL URLWithString:@"https://developers.facebook.com/"];
        id appCall = [FBDialogs presentShareDialogWithLink:nil
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              DLog(@"Error: %@", error.description);
                                              if(handler)
                                                  handler(NO, error);
                                          } else {
                                              DLog(@"Success!");
                                              if(handler)
                                                  handler(YES, nil);
                                          }
                                      }];
        DLog(@"appCall: %@", appCall);
        if(!appCall)
        {
            NSMutableDictionary *params =
            [NSMutableDictionary dictionaryWithObjectsAndKeys:
             @"An example parameter", @"description",
             nil];
            [FBWebDialogs presentDialogModallyWithSession:nil dialog:@"feed" parameters:params handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                if(error){
                    [self handleFacebookPublishError:error];
                }else
                    if(result==FBWebDialogResultDialogCompleted){
                        if ([[resultURL absoluteString] rangeOfString:@"post_id"].location != NSNotFound) {
                            DLog(@"Posted to facebook Successfully using fbWebDialoge");
                            [[[UIAlertView alloc] initWithTitle:@"Success!" message:@"Posted to Facebook" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show] ;
                        }else{
                            DLog(@"User Cancelled to post to facebook using fbWebDialoge");
                        }
                    }
            }];
        }
    }
}
-(void)handleFacebookPublishError:(NSError*)er{
    
}
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI handler:(void (^)(BOOL , NSObject *))handler{
    BOOL userHaveIntegrataedFacebookAccountSetup =  NO;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
        BOOL haveIntegratedFacebookAtAll = ([SLComposeViewController class] != nil);
        userHaveIntegrataedFacebookAccountSetup = haveIntegratedFacebookAtAll && ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]);
    }
    else {
        userHaveIntegrataedFacebookAccountSetup =  NO;
    }
    
    if (userHaveIntegrataedFacebookAccountSetup){
        // request readPermission
        return [FBSession openActiveSessionWithReadPermissions:nil
                                                  allowLoginUI:allowLoginUI
                                             completionHandler:^(FBSession *session,
                                                                 FBSessionState state,
                                                                 NSError *error) {
                                                 [self sessionStateChanged:session
                                                                     state:state
                                                                     error:error
                                                                   handler:handler];
                                             }];
    } else {
        return [FBSession openActiveSessionWithPublishPermissions:@[@"publish_stream"]
                                                  defaultAudience:FBSessionDefaultAudienceFriends
                                                     allowLoginUI:allowLoginUI
                                                completionHandler:^(FBSession *session,
                                                                    FBSessionState state,
                                                                    NSError *error) {
                                                    [self sessionStateChanged:session
                                                                        state:state
                                                                        error:error
                                                                      handler:handler];
                                                }];
    }
    return YES;
}

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
                    handler:(void (^)(BOOL, NSObject *))handler
{
    DLog(@"Session changed with error %@", [error localizedDescription]?[error localizedDescription]:@"N/A");
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                if(session){}else{}
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
        {
            if([FBSession activeSession].isOpen)
            {
                [FBSession.activeSession closeAndClearTokenInformation];
                [FBSession setActiveSession:[[FBSession alloc] init]];
            }
            else
            {
                if(error){
                    NSString* errorDesc = [[error userInfo] objectForKey:@"com.facebook.sdk:ErrorLoginFailedReason"];
                 
                    if([errorDesc isEqualToString:ERR_USER_CANCELED])
                        errorDesc = @"You didn't finish connecting to this network. Complete to be connected.";
                    else if([errorDesc isEqualToString:ERR_DISALLOWED])
                        errorDesc = @"Login to facebook fail with reason: Current App Seting is OFF. Go to Setting->Facebook and turn Varsity ON.";
                    else if([errorDesc isEqualToString:ERR_SYSTEM_CANCELED])
                        errorDesc = @"Login to facebook fail with reason: You cancelled application's request info.";
                    
                    if(handler)
                        handler(NO,errorDesc);
                }
                else if(state == FBSessionStateClosedLoginFailed){
                    NSString* value = @"You didn't finish connecting to this network. Complete to be connected.";
                    if(handler)
                        handler(NO,value);
                }
                else if(state == FBSessionStateClosed){
                }
            }
            return;
        }
            break;
        default:
            break;
    }
    
    [self getUserInfo:handler];
    
}

-(void)getUserInfo:(void (^)(BOOL, NSObject *))callback{
    if(FBSession.activeSession.isOpen)
    {
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id<FBGraphUser> user, NSError *error)
        {
            if (!error)
            {
                NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithDictionary:(NSDictionary*)user];
                callback(YES,userInfo);
            }else
            {
                NSString *message = @"Facebook requires authentication. Please Accept Varsity Required Permission to continue.";
                void(^blockAlertCallback)(UIAlertView*,NSInteger) = ^(UIAlertView*alertView,NSInteger index)
                {
                    if(index == [alertView cancelButtonIndex]){
                        callback(NO,[error localizedDescription]);
                    }
                    else{
                        [self openSessionWithAllowLoginUI:YES handler:callback];
                    }
                };
                [UIAlertView alertViewtWithTitle:@"Facebook"
                                         message:message
                                        callback:blockAlertCallback
                               cancelButtonTitle:@"Cancel"
                               otherButtonTitles:@"Accept",nil];
            }
        }];
    }
    else{
        NSString* message = @"Facebook requires reauthenticate. You must Accept Varsity Require Permission to continue.";
        void(^blockAlertCallback)(UIAlertView*,NSInteger) = ^(UIAlertView*alertView,NSInteger index)
        {
            if(index == [alertView cancelButtonIndex]){
                callback(NO,@"User cancelled authentication");
            }
            else{
                [self openSessionWithAllowLoginUI:YES handler:callback];
            }
        };
        [UIAlertView alertViewtWithTitle:@"Login to Facebook"
                                 message:message
                                callback:blockAlertCallback
                       cancelButtonTitle:@"Cancel"
                       otherButtonTitles:@"Accept",nil];
    }
    
}
@end
