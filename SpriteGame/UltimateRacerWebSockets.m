//
//  UltimateRacerWebSockets.m
//  UltimateRacer
//
//  Created by Sagar Patel on 17/11/13.
//  Copyright (c) 2013 Samir Choudhary. All rights reserved.
//

#import "UltimateRacerWebSockets.h"

#import "UltimateRacerConstants.h"

NSString * const kInboxString = @"ws://secret-headland-1305.herokuapp.com/receive";
NSString * const kOutboxString = @"ws://secret-headland-1305.herokuapp.com/submit";

@interface UltimateRacerWebSockets ()
{
    SRWebSocket *_inboxWebSockets;
    SRWebSocket *_outboxWebSockets;
    BOOL outboxWebSocketOpened;
    NSMutableArray *messageQueue;
}

@end

@implementation UltimateRacerWebSockets

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

+ (UltimateRacerWebSockets *)sharedInstance
{
    static UltimateRacerWebSockets *sharedObject = nil;
    if(sharedObject == nil)
    {
        sharedObject = [[super allocWithZone:NULL] init];
    }
    return sharedObject;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        if(!_outboxWebSockets)
        {
            _outboxWebSockets = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:kOutboxString]];
            [_outboxWebSockets setDelegate:self];
            [_outboxWebSockets open];
        }
        if(!_inboxWebSockets)
        {
            _inboxWebSockets = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:kInboxString]];
            [_inboxWebSockets setDelegate:self];
            [_inboxWebSockets open];
        }
        outboxWebSocketOpened = false;
        messageQueue = [NSMutableArray array];
    }
    return self;
}

- (BOOL)sendMessage:(NSString *)message
{
    if(outboxWebSocketOpened)
    {
        [_outboxWebSockets send:message];
        return true;
    }
    else
    {
        [messageQueue addObject:message];
        return false;
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    if([message rangeOfString:kUPDATECAR1].location != NSNotFound)
    {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUPDATECAR1 object:json];
        //return;
    }
    else if([message rangeOfString:kUPDATECAR2].location != NSNotFound)
    {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUPDATECAR2 object:json];
        //return;
    }
    else if([message rangeOfString:kACCELERATE1].location != NSNotFound)
    {
        NSDictionary *json = nil;//[NSJSONSerialization JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kACCELERATE1 object:json];
    }
    else if([message rangeOfString:kDECCELERATE1].location != NSNotFound)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDECCELERATE1 object:nil];
    }
    else if([message rangeOfString:kACCELERATE2].location != NSNotFound)
    {
        NSDictionary *json = nil;//[NSJSONSerialization JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kACCELERATE2 object:json];
    }
    else if([message rangeOfString:kDECCELERATE2].location != NSNotFound)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDECCELERATE2 object:nil];
    }
    else if([message rangeOfString:kREGISTERED].location != NSNotFound)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kREGISTERED object:message];
        [_outboxWebSockets send:[NSString stringWithFormat:@"close_game code:abcde"]];
    }
    else if ([message rangeOfString:kCOLORCHANGE].location != NSNotFound)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kCOLORCHANGE object:message];
    }
    else if([message rangeOfString:kCLOSEGAME].location != NSNotFound)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kCLOSEGAME object:nil];
    }
    else if([message rangeOfString:kGAMEFINISHED].location != NSNotFound)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGAMEFINISHED object:message];
    }
    else if([message rangeOfString:kNEWGAME].location != NSNotFound)
    {
        NSLog(@"new game created %@", message);
    }
    else
    {
        //[_outboxWebSockets send:[NSString stringWithFormat:@"hello"]];
    }
    //NSLog(@"%@", message);
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSLog(@"opened %@", [[webSocket url] absoluteString]);
    if([[[webSocket url] absoluteString] isEqualToString:kOutboxString])
    {
        outboxWebSocketOpened = true;
        for(int i = 0; i < [messageQueue count]; i++)
        {
            NSString *message = [messageQueue objectAtIndex:i];
            [self sendMessage:message];
        }
        [messageQueue removeAllObjects];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"%@", reason);
}

- (void)dealloc
{
    [_inboxWebSockets close];
    [_outboxWebSockets close];
    _inboxWebSockets = nil;
    _outboxWebSockets = nil;
}

@end
