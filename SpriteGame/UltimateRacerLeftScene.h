//
//  SpriteMyScene.h
//  SpriteGame
//

//  Copyright (c) 2013 Samir Choudhary. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@class UltimateRacerViewController;

@interface UltimateRacerLeftScene : SKScene

@property (strong, nonatomic) AVAudioPlayer *APlayer;
@property (strong, nonatomic) AVAudioPlayer *DPlayer;
@property (weak, nonatomic) UltimateRacerViewController *viewController;
@property (weak, nonatomic) UILabel *label;


@end

@interface SKEmitterNode (fromFile)
+ (instancetype)carNamed:(NSString*)name;
@end
