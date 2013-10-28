//
//  ReceiptViewController.h
//  MagTek.iDynamo.ObjC
//
//  Created by agharris73 on 9/18/13.
//  Copyright (c) 2013 Mercury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ReceiptViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *authCodeValue;

@property (strong, nonatomic) IBOutlet UILabel *statusValue;
@property (strong, nonatomic) IBOutlet UILabel *tranTypeValue;
@property (strong, nonatomic) IBOutlet UILabel *authAmountValue;
@property (strong, nonatomic) IBOutlet UILabel *amountValue;
@property (strong, nonatomic) IBOutlet UILabel *taxAmtValue;
@property (strong, nonatomic) IBOutlet UILabel *acqRefDataValue;
@property (strong, nonatomic) IBOutlet UILabel *cardTypeValue;
@property (strong, nonatomic) IBOutlet UILabel *cvvResultValue;
@property (strong, nonatomic) IBOutlet UILabel *displayMessageValue;
@property (strong, nonatomic) IBOutlet UILabel *expDateValue;
@property (strong, nonatomic) IBOutlet UILabel *invoiceValue;
@property (strong, nonatomic) IBOutlet UILabel *maskedAccountValue;
@property (strong, nonatomic) IBOutlet UILabel *refNoValue;
@property (strong, nonatomic) IBOutlet UILabel *responseCodeValue;
@property (strong, nonatomic) IBOutlet UILabel *statusMessageValue;
@property (strong, nonatomic) IBOutlet UILabel *tokenValue;
@property (strong, nonatomic) IBOutlet UILabel *transPostTimeValue;
@property (weak, nonatomic) IBOutlet UILabel *transctionIDValue;

@end
