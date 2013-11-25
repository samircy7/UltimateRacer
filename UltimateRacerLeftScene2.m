//
//  UltimateRacerLeftScene2.m
//  UltimateRacer
//
//  Created by Sagar Patel on 24/11/13.
//  Copyright (c) 2013 Samir Choudhary. All rights reserved.
//

#import "UltimateRacerLeftScene2.h"

@interface UltimateRacerLeftScene2 ()
{
    SKShapeNode *track1;
}

@end

@implementation UltimateRacerLeftScene2

- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if(self)
    {
        self.backgroundColor = [SKColor blackColor];
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        
        CGRect selfSize = self.frame;
        selfSize.origin.x = selfSize.size.width/2 - 350;
        selfSize.origin.y = selfSize.size.height/2 - 112;
        selfSize.size.height -= 800;
        selfSize.size.width -= 75;
        
        track1 = [SKShapeNode node];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:selfSize.origin];
        [path addLineToPoint:CGPointMake(selfSize.origin.x + selfSize.size.width/3, selfSize.origin.y)];
        [path addLineToPoint:CGPointMake(selfSize.origin.x + 2 * selfSize.size.width/3, selfSize.origin.y + selfSize.size.height)];
        [path addLineToPoint:CGPointMake(selfSize.origin.x + selfSize.size.width, selfSize.origin.y + selfSize.size.height)];
        [path addLineToPoint:CGPointMake(selfSize.origin.x + selfSize.size.width, selfSize.origin.y)];
        [path addLineToPoint:CGPointMake(selfSize.origin.x + 2 * selfSize.size.width/3, selfSize.origin.y)];
        [path addLineToPoint:CGPointMake(selfSize.origin.x + selfSize.size.width/3, selfSize.origin.y + selfSize.size.height)];
        [path addLineToPoint:CGPointMake(selfSize.origin.x, selfSize.origin.y + selfSize.size.height)];
        [path addLineToPoint:CGPointMake(selfSize.origin.x, selfSize.origin.y)];
        path.lineCapStyle = kCGLineCapRound;
        path.lineJoinStyle = kCGLineJoinRound;
        track1.path = [path CGPath];
        
        track1.fillColor = [UIColor clearColor];
        track1.strokeColor = [UIColor colorWithRed:0 green:0 blue:0.9 alpha:1];
        track1.glowWidth = 7;
        track1.lineWidth = 5;
        
        [self addChild:track1];
    }
    return self;
}

@end
