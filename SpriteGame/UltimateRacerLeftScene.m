//
//  SpriteMyScene.m
//  SpriteGame
//
//  Created by Samir Choudhary on 10/19/13.
//  Copyright (c) 2013 Samir Choudhary. All rights reserved.
//

#import "UltimateRacerLeftScene.h"

@implementation UltimateRacerLeftScene
{
    SKNode* car1;
    SKShapeNode* track1;
    BOOL accelerate;
    BOOL pressed;
    BOOL screenSetted;
    BOOL corner1;
    BOOL corner2;
    SKShapeNode* acceleratorNode1;
    SKShapeNode* acceleratorNode2;
}

@synthesize APlayer;
@synthesize DPlayer;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.backgroundColor = [SKColor blackColor];
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        
        /* Set up of track */
        track1 = [SKShapeNode node];
        
        CGRect selfSize = self.frame;
        selfSize.origin.x = selfSize.size.width/2;
        selfSize.origin.y = selfSize.size.height/2 - 112;
        selfSize.size.height -= 700;
        //selfSize.size.width -= 200;
        
        track1.path = ([UIBezierPath bezierPathWithRoundedRect:selfSize cornerRadius:10]).CGPath;
        track1.fillColor = [UIColor clearColor];
        track1.strokeColor = [UIColor blueColor];
        track1.glowWidth = 7;
        track1.lineWidth = 23;

        /* Set up of cars */
        car1 = [SKNode node];
        SKShapeNode* circle1 = [SKShapeNode node];
        circle1.path = ([UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.frame.size.width/2-15, self.frame.size.height/2 - 127, 30, 30)]).CGPath;
        UIColor *myColor1 = [UIColor colorWithRed: 176.0/255.0 green: 226.0/255.0 blue:255.0/255.0 alpha: 1.0];
        circle1.fillColor = myColor1;
        [car1 addChild:circle1];
        
        car1.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:15];
        [car1.physicsBody setLinearDamping:0.9];

        
        car2 = [SKNode node];
        SKShapeNode* circle2 = [SKShapeNode node];
        circle2.path = ([UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.frame.size.width/2-65, self.frame.size.height/2-177, 30, 30)]).CGPath;
        UIColor *myColor2 = [UIColor colorWithRed: 255.0/255.0 green: 193.0/255.0 blue:193.0/255.0 alpha: 1.0];
        circle2.fillColor = myColor2;
        circle2.strokeColor = myColor2;
        [car2 addChild:circle2];
        
        /* Set up of accelerator nodes */
        
        acceleratorNode1 = [SKShapeNode node];
        acceleratorNode1.name = @"Car 1";
        acceleratorNode1.path = ([UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.frame.size.width/2-50, 100, 100, 100)]).CGPath;
        acceleratorNode1.strokeColor = [UIColor yellowColor];
        
        acceleratorNode2 = [SKShapeNode node];
        acceleratorNode2.path = ([UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.frame.size.width/2-50, 100, 70, 70)]).CGPath;
        acceleratorNode2.strokeColor = [UIColor greenColor];
        
        [self addChild:track1];
        [self addChild:car1];
        [self addChild:acceleratorNode1];
        //[self addChild:acceleratorNode2];
        
        accelerate = NO;
        pressed = NO;
        screenSetted = NO;
        corner1 = NO;
        corner2 = NO;
    }
    return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch* touch in touches)
    {
        CGPoint temp = [touch locationInNode:acceleratorNode1];
        if (temp.x > self.frame.size.width/2 - 50 && temp.x < self.frame.size.width/2 + 50 && temp.y < 200  && temp.y > 100) {
            acceleratorNode1.fillColor = [UIColor yellowColor];
            acceleratorNode1.glowWidth = 20;
            accelerate = YES;
            pressed = YES;
            
            [DPlayer stop];
            NSLog(@"Accelerate");
            NSURL * countDownURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Accelerate.mp3",[[NSBundle mainBundle] resourcePath]]];
            NSError * error;
            
            APlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:countDownURL error:&error];
            APlayer.numberOfLoops = 0;
            
            [APlayer prepareToPlay];
            [APlayer play];
            
            
        }
    }
    
    acceleratorNode1.fillColor = [UIColor yellowColor];
    acceleratorNode1.glowWidth = 20;
    
    accelerate = YES;
    pressed = YES;
    
    
    
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    acceleratorNode1.fillColor = [UIColor clearColor];
    acceleratorNode1.glowWidth = 0;
    
    accelerate = NO;
    pressed = NO;
    
    
    [APlayer stop];
    
    NSURL * countDownURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Deccelerate.mp3",[[NSBundle mainBundle] resourcePath]]];
    NSError * error;
    
    DPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:countDownURL error:&error];
    DPlayer.numberOfLoops = 0;
    
    [DPlayer prepareToPlay];
    [DPlayer play];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */

    CGFloat limit = 384;
    CGFloat posx = car1.position.x;
    CGFloat posy = car1.position.y;
    
    if ((posx > 0 && posx - limit > 0.01 && screenSetted == NO) || (corner2 && posx > 0))
    {
        screenSetted = YES;
        corner1 = NO;
        corner2 = NO;
        CGFloat refx = car1.physicsBody.velocity.dx * -1;
        
        [car1 removeFromParent];
        
        car1 = [SKNode node];
        SKShapeNode* circle1 = [SKShapeNode node];
        circle1.path = ([UIBezierPath bezierPathWithOvalInRect:CGRectMake(768, 708, 30, 30)]).CGPath;
        UIColor *myColor1 = [UIColor colorWithRed: 176.0/255.0 green: 226.0/255.0 blue:255.0/255.0 alpha: 1.0];
        circle1.fillColor = myColor1;
        [car1 addChild:circle1];
        
        car1.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:15];
        [car1.physicsBody setFriction:0.9];
        [car1.physicsBody setLinearDamping:0.9];
        [self addChild:car1];
        
        CGVector trial = CGVectorMake(-18, 0);
        [car1.physicsBody setVelocity:CGVectorMake(refx, 0)];
        [car1.physicsBody applyForce:trial];
    }
    
    else if (posx < 0 && limit + 15 + posx < 0.01 && posy + 324 > 0.01)
    {
        if (!corner1) {
        CGFloat refy = car1.physicsBody.velocity.dx;
        [car1.physicsBody setVelocity:CGVectorMake(0, refy)];
        corner1 = YES;
        screenSetted = NO;
        }
        
        if (accelerate && pressed)
            [car1.physicsBody applyForce:CGVectorMake(0, -18)];
    }
    
    else if (posx < 0 && 309 + posy < 0.01 && !screenSetted)
    {
        if (!corner2) {
            CGFloat refy = car1.physicsBody.velocity.dy * -1;
            [car1.physicsBody setVelocity:CGVectorMake(refy, 0)];
            corner2 = YES;
            corner1 = NO;
        }
        
        if (accelerate && pressed)
            [car1.physicsBody applyForce:CGVectorMake(18, 0)];
    }
    
    else if (accelerate && pressed) {
        if ( screenSetted == NO) {
            CGVector trial = CGVectorMake(18, 0);
            [car1.physicsBody applyForce:trial];
        }
        else
        {
            CGVector trial = CGVectorMake(-18, 0);
            [car1.physicsBody applyForce:trial];
        }
    }
    
    else {
        CGVector trial = CGVectorMake(0, 0);
        [car1.physicsBody applyForce:trial];
    }
}

@end
