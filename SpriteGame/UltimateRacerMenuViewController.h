//
//  UltimateRacerMenuViewController.h
//  UltimateRacer
//
//  Created by Samir Choudhary on 11/8/13.
//  Copyright (c) 2013 Samir Choudhary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#define PlayerType @"PlayerType"

@interface UltimateRacerMenuViewController : UIViewController <AVAudioPlayerDelegate>


@property (strong, nonatomic) AVAudioPlayer *player;
@end
