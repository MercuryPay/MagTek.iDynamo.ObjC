//
//  AppDelegate.h
//  MagTek.iDynamo.ObjC
//
//  Created by agharris73 on 10/14/13.
//  Copyright (c) 2013 Mercury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EncryptedSwipeData.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *pid;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *responseCode;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *tranType;
@property (strong, nonatomic) NSString *authCode;
@property (strong, nonatomic) NSString *authAmount;
@property (strong, nonatomic) NSString *amount;
@property (strong, nonatomic) NSString *taxAmt;
@property (strong, nonatomic) NSString *acqRefData;
@property (strong, nonatomic) NSString *cardType;
@property (strong, nonatomic) NSString *cvvResult;
@property (strong, nonatomic) NSString *displayMessage;
@property (strong, nonatomic) NSString *expDate;
@property (strong, nonatomic) NSString *invoice;
@property (strong, nonatomic) NSString *maskedAccount;
@property (strong, nonatomic) NSString *refNo;
@property (strong, nonatomic) NSString *statusMessage;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *transPostTime;
@property (strong, nonatomic) NSString *tranactionID;
@property (strong, nonatomic) EncryptedSwipeData *encryptedSwipeData;

-(void) reset;

@end
