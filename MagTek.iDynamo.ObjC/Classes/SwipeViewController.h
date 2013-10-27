//
//  SwipeViewController.h
//  MagTek.iDynamo.ObjC
//
//  Created by agharris73 on 9/18/13.
//  Copyright (c) 2013 Mercury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "EncryptedSwipeData.h"

@interface SwipeViewController : UIViewController

@property (strong, nonatomic) EncryptedSwipeData *encryptedSwipeData;

// uDynamo Button/Switch
@property (strong, nonatomic) IBOutlet UIButton *simSwipeUdynamoButton;
- (IBAction)simSwipeuDynamoButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *simSwipeuDynamoSwitch;
- (IBAction)simSwipeduDynamoSwitchFlipped:(id)sender;

// iDynamo Button/Switch
@property (strong, nonatomic) IBOutlet UIButton *simSwipeiDynamoButton;
- (IBAction)simSwipeiDynamoButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *simSwipeiDynamoSwitch;
- (IBAction)simSwipeiDynamoSwitchFlipped:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *imageCardState;

@end
