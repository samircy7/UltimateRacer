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
#import "UltimateRacerWebSockets.h"

@interface UltimateRacerViewController ()
{
    NSString * player;
    NSTimer *timer;
    int countDown;
}

@end

@implementation UltimateRacerViewController

@synthesize scene;
@synthesize DingPlayer;
@synthesize first;
@synthesize second;
@synthesize third;
@synthesize CountPlayer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Configure the view.
    countDown = 5;
    SKView* skView = (SKView *)self.view;
    
    if ([[self presentingViewController] isKindOfClass:[StartGameVC class]])
    {
    // Create and configure the scene.
        scene = [UltimateRacerLeftScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
        [skView presentScene:scene];
        
        StartGameVC *vc = (StartGameVC *)[self presentingViewController];
        [vc stopMusic];
        
    }
    
    else {
        // Create and configure the scene.
        scene = [UltimateRacerRightScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
        
        JoinGameVC *vc = (JoinGameVC *)[self presentingViewController];
        [vc stopMusic];
        
        NSURL * DingURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Ding.mp3",[[NSBundle mainBundle] resourcePath]]];
        NSError * error2;
        
        DingPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:DingURL error:&error2];
        DingPlayer.numberOfLoops = 0;
        
        [DingPlayer prepareToPlay];
        [DingPlayer setVolume:1.0];
        [DingPlayer play];
        
    }
    NSLog(@"HERE");
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    [self performSelector:@selector(setUpCountDown) withObject:self afterDelay:1.5];
    UltimateRacerWebSockets *websockets = [UltimateRacerWebSockets sharedInstance];
}

-(void) timerFired
{
    countDown--;
    
    if ( countDown == 3 )
    {
        NSLog(@"Count3");
        first.hidden = NO;
        //[first setImage:[UIImage imageNamed:@"redlight.png"]];
    }
    else if(countDown == 2 )
    {
        NSLog(@"Count2");
        second.hidden = NO;
        //[second setImage:[UIImage imageNamed:@"redlight.png"]];
    }
    else if (countDown == 1 )
    {
        NSLog(@"Count1");
        [first setImage:[UIImage imageNamed:@"greenlight.png"]];
        [second setImage:[UIImage imageNamed:@"greenlight.png"]];
        third.hidden = NO;
        
        
    }
    else if ( countDown == 0 )
    {
        [timer invalidate];
    }
}

- (void) setUpCountDown
{
    NSURL * countDownURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/CountDown.mp3",[[NSBundle mainBundle] resourcePath]]];
    NSError * error;
    
    CountPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:countDownURL error:&error];
    CountPlayer.numberOfLoops = 0;
    
    [CountPlayer prepareToPlay];
    [CountPlayer play];
    
    
    
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
