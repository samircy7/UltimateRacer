//
//  UltimateRacerMenuViewController.m
//  UltimateRacer
//
//  Created by Samir Choudhary on 11/8/13.
//  Copyright (c) 2013 Samir Choudhary. All rights reserved.
//

#import "UltimateRacerMenuViewController.h"
#import "StartGameVC.h"
#import "JoinGameVC.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface UltimateRacerMenuViewController ()

@end

@implementation UltimateRacerMenuViewController
@synthesize player;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//        //NSData *soundFile = [[NSData alloc] initWithContentsOfFile:@"/Users/ranner_76/UltimateRacer/SpriteGame-2/SpriteGame/MenuFinal.m4a"];
//        NSURL * soundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"MenuFinal" ofType:@"m4a"]];
//        NSData *soundFile = [[NSData alloc] initWithContentsOfURL:soundURL];
//        _player = [[AVAudioPlayer alloc] initWithData:soundFile error:nil];
//        
//        self.player.numberOfLoops = -1;
//        
//        [self.player prepareToPlay];
//        [self.player setDelegate:self];
//        [self.player play]; }
    NSURL * countDownURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/MenuFinal.m4a",[[NSBundle mainBundle] resourcePath]]];
    NSError * error;
    
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:countDownURL error:&error];
    player.numberOfLoops = 0;
    [player play];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
