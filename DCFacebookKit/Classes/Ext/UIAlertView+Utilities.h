//
//  UIAlertView+Utilities.h
//  FaceFlip
//
//  Created by Liem Vo on 9/29/12.
//  Copyright (c) 2012 Liem Vo Uy. All rights reserved.
//

#import <UIKit/UIKit.h>

/* the first argument is the alert view, the second argument is the clicked button index */
typedef void (^UIAlertViewSimpleHandler)(UIAlertView *, NSInteger);

/* the first argument is the alert view, the second argument is the text inputed, the third is the clicked button index */
typedef void (^UIAlertViewTextInputHandler)(UIAlertView *, NSString *, NSInteger);

/* the first argument is the alert view, the second and thrid arguments are the text inputed, the fourth is the clicked button index */
typedef void (^UIAlertViewTwoTextInputHandler)(UIAlertView *, NSString *, NSString *, NSInteger);

@interface UIAlertView (Utilities)

/*
 * Show UIAlertView with specific message and default title
 * return the view itself
 */
+ (UIAlertView *) showMessage: (NSString *) message;

/*
 * Show UIAlertView with specific message and title
 * return the view itself
 */
+ (UIAlertView *) showMessage: (NSString *) message withTitle: (NSString *) title;

/*
 * Show UIAlertView with specific message and title
 * the callback will be called after user dismiss the alert
 * return the view itself
 */
+ (UIAlertView *) alertViewtWithTitle:(NSString *)title message:(NSString *)message callback: (UIAlertViewSimpleHandler) callback cancelButtonTitle:(NSString *) cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
+ (UIAlertView *) alertViewtWithTitle:(NSString *)title message:(NSString *)message autoShow:(BOOL) autoShow callback: (UIAlertViewSimpleHandler) callback cancelButtonTitle:(NSString *) cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/*
 * Show UIAlertView with 1 text input field
 * the callback will be called after user dismiss the alert
 * return the view itself
 */
+ (UIAlertView *) alertViewtWithTextInputTitle:(NSString *)title text:(NSString *) text placeHolderText: (NSString *) placeHolderText callback: (UIAlertViewTextInputHandler) callback cancelButtonTitle:(NSString *) cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
/*
 * Show UIAlertView with 2 text input fields
 * the callback will be called after user dismiss the alert
 * return the view itself
 */
+ (UIAlertView *) alertViewtWithTextInputTitle:(NSString *)title text1:(NSString *) text1 placeHolderText1: (NSString *) placeHolderText1 text2:(NSString *) text2 placeHolderText2: (NSString *) placeHolderText2 callback: (UIAlertViewTwoTextInputHandler) callback cancelButtonTitle:(NSString *) cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/*
 * Show UIAlertView with 1 multiline input text field
 * the callback will be called after user dismiss the alert
 * return the view itself
 */
+ (UIAlertView *) alertViewtWithTextViewInputTitle:(NSString *)title text:(NSString *) text callback: (UIAlertViewTextInputHandler) callback cancelButtonTitle:(NSString *) cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
@end
