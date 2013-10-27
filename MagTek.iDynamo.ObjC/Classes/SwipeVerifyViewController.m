//
//  SwipeVerifyViewController.m
//  MagTek.iDynamo.ObjC
//
//  Created by agharris73 on 9/25/13.
//  Copyright (c) 2013 Mercury. All rights reserved.
//

#import "SwipeVerifyViewController.h"
#import "AppDelegate.h"

@interface SwipeVerifyViewController ()

@end

@implementation SwipeVerifyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)swipeStep2:(id)sender {
    AppDelegate *ad = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSMutableDictionary *dictionaryReq = [NSMutableDictionary new];
    [dictionaryReq setObject:@"118725340908147" forKey:@"MerchantID"];
    [dictionaryReq setObject:@"Credit" forKey:@"TranType"];
    [dictionaryReq setObject:@"Sale" forKey:@"TranCode"];
    [dictionaryReq setObject:@"12345" forKey:@"InvoiceNo"];
    [dictionaryReq setObject:@"12345" forKey:@"RefNo"];
    [dictionaryReq setObject:@"MercuryHelper 1.0.1" forKey:@"Memo"];
    [dictionaryReq setObject:@"Allow" forKey:@"PartialAuth"];
    
    [dictionaryReq setObject:@"MagneSafe" forKey:@"EncryptedFormat"];
    [dictionaryReq setObject:@"Swiped" forKey:@"AccountSource"];
    [dictionaryReq setObject:ad.encryptedSwipeData.track2Encrypted forKey:@"EncryptedBlock"];
    [dictionaryReq setObject:ad.encryptedSwipeData.ksn forKey:@"EncryptedKey"];
    
    [dictionaryReq setObject:@"OneTime" forKey:@"Frequency"];
    [dictionaryReq setObject:@"RecordNumberRequested" forKey:@"RecordNo"];
    
    [dictionaryReq setObject:@"1.01" forKey:@"Purchase"];
    
    [dictionaryReq setObject:@"test" forKey:@"Name"];
    
    [dictionaryReq setObject:@"MPS Terminal" forKey:@"TerminalName"];
    [dictionaryReq setObject:@"MPS Shift" forKey:@"ShiftID"];
    [dictionaryReq setObject:@"test" forKey:@"OperatorID"];
    
    [dictionaryReq setObject:@"4 Corporate SQ" forKey:@"Address"];
    [dictionaryReq setObject:@"30329" forKey:@"Zip"];
    
    [dictionaryReq setObject:@"123" forKey:@"CVV"];
    
    
    MercuryHelper *mgh = [MercuryHelper new];
    mgh.delegate = self;
    [mgh transctionFromDictionary:dictionaryReq andPassword:@"xyz"];
    
}

-(void) transactionDidFailWithError:(NSError *)error {
    
}

-(void) transactionDidFinish:(NSDictionary *)result {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if ([result objectForKey:@"CmdStatus"])
    {
        appDelegate.status = [result objectForKey:@"CmdStatus"];
    }
    if ([result objectForKey:@"TranCode"])
    {
        appDelegate.tranType = [result objectForKey:@"TranCode"];
    }
    if ([result objectForKey:@"AuthCode"])
    {
        appDelegate.authCode = [result objectForKey:@"AuthCode"];
    }
    if ([result objectForKey:@"Authorize"])
    {
        appDelegate.authAmount = [result objectForKey:@"Authorize"];
    }
    if ([result objectForKey:@"Purchase"])
    {
        appDelegate.amount = [result objectForKey:@"Purchase"];
    }
    if ([result objectForKey:@"TaxAmount"])
    {
        appDelegate.taxAmt = [result objectForKey:@"TaxAmount"];
    }
    if ([result objectForKey:@"AcqRefData"])
    {
        appDelegate.acqRefData = [result objectForKey:@"AcqRefData"];
    }
    if ([result objectForKey:@"CardType"])
    {
        appDelegate.cardType = [result objectForKey:@"CardType"];
    }
    if ([result objectForKey:@"TextResponse"])
    {
        appDelegate.displayMessage = [result objectForKey:@"TextResponse"];
    }
    if ([result objectForKey:@"ExpDate"])
    {
        appDelegate.expDate = [result objectForKey:@"ExpDate"];
    }
    if ([result objectForKey:@"InvoiceNo"])
    {
        appDelegate.invoice = [result objectForKey:@"InvoiceNo"];
    }
    if ([result objectForKey:@"AcctNo"])
    {
        appDelegate.maskedAccount = [result objectForKey:@"AcctNo"];
    }
    if ([result objectForKey:@"RefNo"])
    {
        appDelegate.refNo = [result objectForKey:@"RefNo"];
    }
    if ([result objectForKey:@"DSIXReturnCode"])
    {
        appDelegate.responseCode = [result objectForKey:@"DSIXReturnCode"];
    }
    if ([result objectForKey:@"CaptureStatus"])
    {
        appDelegate.statusMessage = [result objectForKey:@"CaptureStatus"];
    }
    if ([result objectForKey:@"RecordNo"])
    {
        appDelegate.token = [result objectForKey:@"RecordNo"];
    }
    if ([result objectForKey:@"CVVResult"])
    {
        appDelegate.cvvResult = [result objectForKey:@"CVVResult"];
    }
    
    [self performSegueWithIdentifier:@"processPaymentResult" sender:self];
    
}

@end
