//
//  SpriteViewController.h
//  SpriteGame
//

//  Copyright (c) 2013 Samir Choudhary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "SRWebSocket.h"

extern NSString * const kInboxString;
extern NSString * const kOutboxString;

@interface UltimateRacerViewController : UIViewController <SRWebSocketDelegate>

@property (nonatomic, strong) SKScene * scene;

@end
