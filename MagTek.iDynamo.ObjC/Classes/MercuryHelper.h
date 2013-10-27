//
//  MercurySOAPHelper.h
//  CallMercuryWebService
//
//  Created by Kevin Oliver on 5/16/13.
//  Copyright (c) 2013 Kevin Oliver. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MercuryHelper;

@protocol MercuryHelperDelegate <NSObject>

-(void) transactionDidFailWithError:(NSError *)error;
-(void) transactionDidFinish:(NSDictionary *)result;

@end

@interface MercuryHelper : NSObject <NSXMLParserDelegate>

@property (weak, nonatomic) id <MercuryHelperDelegate> delegate;

-(void) transctionFromDictionary:(NSDictionary *)dictionary andPassword:(NSString *)password;

@end
