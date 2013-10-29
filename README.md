MagTek.iDynamo.ObjC
===================
XCode iOS application processing transactions to our web services platform.

3 step process to integrate to Mercury Web Services.

##Step 1: Build Request with Key Value Pairs
  
Create a NSMutableDictionary and add all the Key Value Pairs.
  
```
    NSMutableDictionary *dictionaryReq = [NSMutableDictionary new];
    [dictionaryReq setObject:@"118725340908147" forKey:@"MerchantID"];
    [dictionaryReq setObject:@"Credit" forKey:@"TranType"];
    [dictionaryReq setObject:@"Sale" forKey:@"TranCode"];
    [dictionaryReq setObject:@"12345" forKey:@"InvoiceNo"];
    [dictionaryReq setObject:@"12345" forKey:@"RefNo"];
    [dictionaryReq setObject:@"MercuryHelper 1.0.1" forKey:@"Memo"];
    [dictionaryReq setObject:@"Allow" forKey:@"PartialAuth"];
    [dictionaryReq setObject:@"MagneSafe" forKey:@"EncryptedFormat"];
    [dictionaryReq setObject:@"Keyed" forKey:@"AccountSource"];
    [dictionaryReq setObject:@"C756513CF498BBBF462FEDBFBF732DD8434ACB2B28325D0C7323204F639AC68FFD2769B49020E0CD" forKey:@"EncryptedBlock"];
    [dictionaryReq setObject:@"9500030000040C20001C" forKey:@"EncryptedKey"];
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
