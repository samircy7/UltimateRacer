//
//  Sprite.m
//  SpriteGame
//
//  Created by Samir Choudhary on 11/8/13.
//  Copyright (c) 2013 Samir Choudhary. All rights reserved.
//

#define THRESHOLD 10

#import "UltimateRacerRightScene.h"

@implementation UltimateRacerRightScene
{
    SKNode* car2;
    SKShapeNode* track2;
    BOOL accelerate;
    BOOL pressed;
    BOOL setted;
    BOOL turned;
    SKShapeNode* acceleratorNode1;
    SKShapeNode* acceleratorNode2;
    CGPoint corners[4];
    CGVector trial;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.backgroundColor = [SKColor blackColor];
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        
        /* Set up of track */
        track2 = [SKShapeNode node];
        
        CGRect selfSize = self.frame;
        selfSize.origin.x = selfSize.size.width/2 - 300;
        selfSize.origin.y = selfSize.size.height/2 - 112;
        selfSize.size.height -= 700;
        selfSize.size.width -= 200;
        corners[0] = CGPointMake(selfSize.origin.x - 15, selfSize.origin.y - 15);
        corners[1] = CGPointMake(selfSize.origin.x - 15 + selfSize.size.width, selfSize.origin.y - 15);
        corners[2] = CGPointMake(selfSize.origin.x - 15 + selfSize.size.width, selfSize.origin.y - 15 + selfSize.size.height);
        corners[3] = CGPointMake(selfSize.origin.x - 15, selfSize.origin.y - 15 + selfSize.size.height);
        
        track2.path = ([UIBezierPath bezierPathWithRoundedRect:selfSize cornerRadius:10]).CGPath;
        track2.fillColor = [UIColor clearColor];
        track2.strokeColor = [UIColor blueColor];
        track2.glowWidth = 7;
        track2.lineWidth = 23;
        
        /* Set up of cars */
        car2 = [SKNode node];
        SKShapeNode* circle1 = [SKShapeNode node];
        circle1.path = ([UIBezierPath bezierPathWithOvalInRect:CGRectMake(corners[0].x, corners[0].y, 30, 30)]).CGPath;
        UIColor *myColor1 = [UIColor colorWithRed: 176.0/255.0 green: 226.0/255.0 blue:255.0/255.0 alpha: 1.0];
        circle1.fillColor = myColor1;
        [car2 addChild:circle1];
        
        car2.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:15];
        [car2.physicsBody setLinearDamping:0.9];
        
        /* Set up of accelerator nodes */
        
        acceleratorNode1 = [SKShapeNode node];
        acceleratorNode1.name = @"Car 1";
        acceleratorNode1.path = ([UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.frame.size.width/2-50, 100, 100, 100)]).CGPath;
        acceleratorNode1.strokeColor = [UIColor yellowColor];
        
        
        [self addChild:track2];
        [self addChild:car2];
        [self addChild:acceleratorNode1];
        //[self addChild:acceleratorNode2];
        
        accelerate = NO;
        pressed = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceleratorPressed:) name:@"accelerate_car" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(decceleratorPressed:) name:@"deccelerate_car" object:nil];
    }
    return self;
}

- (BOOL)comparePoints:(CGPoint)p1 with:(CGPoint)p2
{
    if(ABS(p1.x - p2.x) < THRESHOLD && ABS(p1.y - p2.y) < THRESHOLD)
        return true;
    else
        return false;
}

- (void)acceleratorPressed:(NSNotification *)note
{
    accelerate = YES;
    pressed = YES;
    NSLog(@"Pressed:%hhd", pressed);
}

- (void)decceleratorPressed:(NSNotification *)note
{
    accelerate = NO;
    pressed = NO;
    NSLog(@"Pressed:%hhd", pressed);
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    CGPoint pos = CGPointMake(car2.position.x + 69, car2.position.y + 385);
    if(turned && pressed)
    {
        turned = false;
        [car2.physicsBody applyForce:trial];
        return;
    }
    if([self comparePoints:pos with:corners[0]])
    {
        turned = true;
        car2.physicsBody.velocity = CGVectorMake(0, 0);
        trial = CGVectorMake(18, 0);
    }
    else if([self comparePoints:pos with:corners[1]])
    {
        turned = true;
        car2.physicsBody.velocity = CGVectorMake(0, 0);
        trial = CGVectorMake(0, 18);
    }
    else if([self comparePoints:pos with:corners[2]])
    {
        turned = true;
        car2.physicsBody.velocity = CGVectorMake(0, 0);
        trial = CGVectorMake(-18, 0);
    }
    else if([self comparePoints:pos with:corners[3]])
    {
        turned = true;
        car2.physicsBody.velocity = CGVectorMake(0, 0);
        trial = CGVectorMake(0, -18);
    }
    if(pressed)
        [car2.physicsBody applyForce:trial];
}




@end
