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

@property (nonatomic, strong) SKScene * scene;
@property (nonatomic, retain) AVAudioPlayer *DingPlayer;
@end
