//
//  UltimateRacerWebSockets.m
//  UltimateRacer
//
//  Created by Sagar Patel on 17/11/13.
//  Copyright (c) 2013 Samir Choudhary. All rights reserved.
//

#import "UltimateRacerWebSockets.h"

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
    if([message rangeOfString:@"update_car"].location != NSNotFound)
    {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"update_car" object:json];
        return;
    }
    else if([message rangeOfString:@"accelerate_car"].location != NSNotFound)
    {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"accelerate_car" object:json];
    }
    else if([message rangeOfString:@"deccelerate_car"].location != NSNotFound)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deccelerate_car" object:nil];
    }
    else if([message rangeOfString:@"registered_user"].location != NSNotFound)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"registered_user" object:message];
        [_outboxWebSockets send:[NSString stringWithFormat:@"close_game code:abcde"]];
    }
    else if ([message rangeOfString:@"color_change"].location != NSNotFound)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"color_change" object:message];
    }
    else if([message rangeOfString:@"closed_game"].location != NSNotFound)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"closed_game" object:nil];
    }
    else if([message rangeOfString:@"new_game"].location != NSNotFound)
    {
        NSLog(@"new game created %@", message);
    }
    else
    {
        //[_outboxWebSockets send:[NSString stringWithFormat:@"hello"]];
    }
    NSLog(@"%@", message);
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
