//
//  UltimateRacerWebSockets.h
//  UltimateRacer
//
//  Created by Sagar Patel on 17/11/13.
//  Copyright (c) 2013 Samir Choudhary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"

extern NSString * const kInboxString;
extern NSString * const kOutboxString;

@interface UltimateRacerWebSockets : NSObject <SRWebSocketDelegate>

+ (UltimateRacerWebSockets *)sharedInstance;

- (BOOL)sendMessage:(NSString *)message;

@end
