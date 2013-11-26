//
//  UltimateRacerLeftScene2.h
//  UltimateRacer
//
//  Created by Sagar Patel on 24/11/13.
//  Copyright (c) 2013 Samir Choudhary. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface UltimateRacerLeftScene2 : SKScene

@end

@interface SKEmitterNode (fromFile)
+ (instancetype)carNamed:(NSString*)name;
@end
