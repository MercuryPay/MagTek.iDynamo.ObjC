//
//  MercurySOAPHelper.h
//  CallMercuryHostedCheckoutWebService
//
//  Created by Kevin Oliver on 5/16/13.
//  Copyright (c) 2013 Kevin Oliver. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HCMercuryHelper;

@protocol HCMercuryHelperDelegate <NSObject>

-(void) hctransactionDidFailWithError:(NSError *)error;
-(void) hctransactionDidFinish:(NSDictionary *)result;

@end

@interface HCMercuryHelper : NSObject <NSXMLParserDelegate>

@property (weak, nonatomic) id <HCMercuryHelperDelegate> delegate;

-(void) hctransctionFromDictionary:(NSDictionary *)dictionary andPassword:(NSString *)password;
-(void) hcVerifyFromDictionary:(NSDictionary *)dictionary andPassword:(NSString *)password;

@end
