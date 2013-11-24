//
//  SpriteMyScene.h
//  SpriteGame
//

//  Copyright (c) 2013 Samir Choudhary. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>

@interface UltimateRacerRightScene : SKScene

@property (strong, nonatomic) AVAudioPlayer *APlayer;
@property (strong, nonatomic) AVAudioPlayer *DPlayer;

@end

@interface SKEmitterNode (fromFile)
+ (instancetype)carNamed:(NSString*)name;
@end
