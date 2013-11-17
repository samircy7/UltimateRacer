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
