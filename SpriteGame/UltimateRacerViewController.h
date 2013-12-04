//
//  SpriteViewController.h
//  SpriteGame
//

//  Copyright (c) 2013 Samir Choudhary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>

#define PlayerType @"PlayerType"

@interface UltimateRacerViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *first;
@property (strong, nonatomic) IBOutlet UIImageView *second;
@property (strong, nonatomic) IBOutlet UIImageView *third;
@property (strong, nonatomic) IBOutlet UIImageView *board;
@property (strong, nonatomic) AVAudioPlayer *CountPlayer;
@property (nonatomic, strong) SKScene * scene;
@property (nonatomic, retain) AVAudioPlayer *DingPlayer;
-(void) timerFired;
- (void) setUpCountDown;
- (BOOL) checkCountDown;
- (void) hideLight;
@end
