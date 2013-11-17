//
//  SpriteViewController.m
//  SpriteGame
//
//  Created by Samir Choudhary on 10/19/13.
//  Copyright (c) 2013 Samir Choudhary. All rights reserved.
//

#import "UltimateRacerViewController.h"
#import "UltimateRacerLeftScene.h"
#import "UltimateRacerRightScene.h"
#import "StartGameVC.h"
#import "JoinGameVC.h"

NSString * const kInboxString = @"ws://secret-headland-1305.herokuapp.com/receive";
NSString * const kOutboxString = @"ws://secret-headland-1305.herokuapp.com/submit";

@interface UltimateRacerViewController ()
{
    SRWebSocket *_inboxWebSockets;
    SRWebSocket *_outboxWebSockets;
    BOOL registered;
}

@end

@implementation UltimateRacerViewController
{
    NSString * player;
}

@synthesize scene;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        if(!_inboxWebSockets)
        {
            _inboxWebSockets = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:kInboxString]];
            [_inboxWebSockets setDelegate:self];
            [_inboxWebSockets open];
        }
        if(!_outboxWebSockets)
        {
            _outboxWebSockets = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:kOutboxString]];
            [_outboxWebSockets setDelegate:self];
            [_outboxWebSockets open];
        }
        registered = false;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Configure the view.
    
    SKView* skView = (SKView *)self.view;
    
    if ([[self presentingViewController] isKindOfClass:[StartGameVC class]])
    {
    // Create and configure the scene.
        scene = [UltimateRacerLeftScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
        [skView presentScene:scene];
        
        StartGameVC *vc = [self presentingViewController];
        [vc stopMusic];
    }
    
    else {
        // Create and configure the scene.
        scene = [UltimateRacerRightScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
        
        JoinGameVC *vc = [self presentingViewController];
        [vc stopMusic];
    }

}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSLog(@"%@", message);
    if(registered == false)
    {
        [_outboxWebSockets send:[NSString stringWithFormat:@"register_user:aaaaa code:abcde"]];
        registered = true;
    }
    else if([message rangeOfString:@"registered_user:"].location != NSNotFound)
    {
        [_outboxWebSockets send:[NSString stringWithFormat:@"close_game code:abcde"]];
    }
    else
    {
        [_outboxWebSockets send:[NSString stringWithFormat:@"hello"]];
    }
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSLog(@"opened %@", [[webSocket url] absoluteString]);
    if([[[webSocket url] absoluteString] isEqualToString:kOutboxString])
        [_outboxWebSockets send:[NSString stringWithFormat:@"new_game code:abcde"]];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"%@", reason);
}

- (void)viewDidDisappear:(BOOL)animated
{
    [_inboxWebSockets close];
    [_outboxWebSockets close];
    _inboxWebSockets = nil;
    _outboxWebSockets = nil;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
