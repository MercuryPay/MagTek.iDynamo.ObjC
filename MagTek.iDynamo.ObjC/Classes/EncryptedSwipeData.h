//
//  EncryptedSwipedData.h
//  MagTek.iDynamo.ObjC
//
//  Created by Kevin Oliver on 9/24/13.
//  Copyright (c) 2013 Mercury. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EncryptedSwipeData : NSObject

@property (strong, nonatomic) NSString *track1Masked;
@property (strong, nonatomic) NSString *track2Masked;
@property (strong, nonatomic) NSString *track1Encrypted;
@property (strong, nonatomic) NSString *track2Encrypted;
@property (strong, nonatomic) NSString *ksn;

@end
