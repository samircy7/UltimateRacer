//
//  UltimateRacerMenuViewController.h
//  UltimateRacer
//
//  Created by Samir Choudhary on 11/8/13.
//  Copyright (c) 2013 Samir Choudhary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#define PlayerType @"PlayerType"

@interface UltimateRacerMenuViewController : UIViewController

@property (nonatomic, strong, retain) AVAudioPlayer *player;
@end
