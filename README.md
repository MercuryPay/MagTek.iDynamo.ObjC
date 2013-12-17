[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/c9964cae9f5c3bf8f8488cd04b1a1183 "githalytics.com")](http://githalytics.com/MercuryPay/MagTek.iDynamo.ObjC)
MagTek.iDynamo.ObjC
===================
XCode iOS application capturing encrypted credit card swipe from MagTek peripheral and processing transactions to our web services platform.

> In order to Build and Run you **must** connect an iOS device to dubug. Build will fail with iOS Simulator 

#Steps to capture secure card data from MagTek encrypted mobile swipers

##Step 1: Add MagTek library
Add MTSCRA.h and libMTSCRA.a to your project

##Step 2: Modify plist file
Add key "Supported external accessory protocols"
Under above key add new item value of "com.magtek.idynamo"

##Step 3: Initilize a new MTSCRA instance

```
self.magTek = [[MTSCRA alloc] init];
[self.magTek listenForEvents:(TRANS_EVENT_OK|TRANS_EVENT_START|TRANS_EVENT_ERROR)];
[self.magTek setDeviceProtocolString:(@"com.magtek.idynamo")];
```

##Step 4: Register to MagTek notification center events

```
NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
[nc addObserver:self selector:@selector(trackDataReady:) name:@"trackDataReadyNotification" object:nil];
[nc addObserver:self selector:@selector(devConnStatusChange) name:@"devConnectionNotification" object:nil];
```

##Step 5: On trackDataReadyNotification event store the Track2 and KSN

```
- (void)trackDataReady:(NSNotification *)notification
{
    NSNumber *status = [[notification userInfo] valueForKey:@"status"];
    
    [self performSelectorOnMainThread:@selector(onDataEvent:)
                           withObject:status
                        waitUntilDone:NO];
}

- (void)onDataEvent:(id)status
{
    switch ([status intValue]) {
        case TRANS_STATUS_OK:
            NSLog(@"TRANS_STATUS_OK");
            self.encryptedSwipeData = [[EncryptedSwipeData alloc] init];
            self.encryptedSwipeData.track1Masked = self.magTek.getTrack1Masked;
            self.encryptedSwipeData.track2Masked = self.magTek.getTrack2Masked;
            self.encryptedSwipeData.track1Encrypted = self.magTek.getTrack1;
            self.encryptedSwipeData.track2Encrypted = self.magTek.getTrack2;
            self.encryptedSwipeData.ksn = self.magTek.getKSN;
            
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            appDelegate.encryptedSwipeData = self.encryptedSwipeData;
            
            break;
        case TRANS_STATUS_ERROR:
            NSLog(@"TRANS_STATUS_ERROR");
            break;
        default:
            break;
    }
}

```

#3 step process to integrate to Mercury Web Services.

##Step 1: Build Request with Key Value Pairs
  
Create a NSMutableDictionary and add all the Key Value Pairs.
  
```
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
```
  
##Step 2: Process the Transaction

Create MercuryHelper object and call the transctionFromDictionary method with the NSMutalbeDictionary and merchant's password.

```
    MercuryHelper *mgh = [MercuryHelper new];
    mgh.delegate = self;
    [mgh transctionFromDictionary:dictionaryReq andPassword:@"xyz"];
```

##Step 3: Parse the Response

Parse the Response using in the transactionDidFinish delegate.

Approved transactions will have a CmdStatus equal to "Approved".

```
-(void) transactionDidFinish:(NSDictionary *)result {
    
    if ([result objectForKey:@"CmdStatus"]
      && [[result objectForKey:@"CmdStatus"] isEqualToString:@"Approved"]) {
      
      // Approved logic here
      
    } else {
      
      // Declined logic here
      
    }
    
}
```

###©2013 Mercury Payment Systems, LLC - all rights reserved.

Disclaimer:
This software and all specifications and documentation contained herein or provided to you hereunder (the "Software") are provided free of charge strictly on an "AS IS" basis. No representations or warranties are expressed or implied, including, but not limited to, warranties of suitability, quality, merchantability, or fitness for a particular purpose (irrespective of any course of dealing, custom or usage of trade), and all such warranties are expressly and specifically disclaimed. Mercury Payment Systems shall have no liability or responsibility to you nor any other person or entity with respect to any liability, loss, or damage, including lost profits whether foreseeable or not, or other obligation for any cause whatsoever, caused or alleged to be caused directly or indirectly by the Software. Use of the Software signifies agreement with this disclaimer notice.
