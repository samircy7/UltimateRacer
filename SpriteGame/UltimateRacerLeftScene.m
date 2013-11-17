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
    SKNode* car2;
    SKShapeNode* track1;
    SKShapeNode* track2;
    BOOL accelerate;
    BOOL pressed;
    BOOL setted;
    SKShapeNode* acceleratorNode1;
    SKShapeNode* acceleratorNode2;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.backgroundColor = [SKColor blackColor];
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        
        /* Set up of track */
        track1 = [SKShapeNode node];
        track2 = [SKShapeNode node];
        
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
        
        selfSize.size.height += 100;
        selfSize.size.width -= 100;
        selfSize.origin.x -=50;
        selfSize.origin.y -= 50;
        
        track2.path = ([UIBezierPath bezierPathWithRoundedRect:selfSize cornerRadius:10]).CGPath;
        track2.fillColor = [UIColor clearColor];
        track2.strokeColor = [UIColor redColor];
        track2.glowWidth = 7;
        track2.lineWidth = 23;
        
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
        //[self addChild:track2];
        //[self addChild:car2];
        //[self addChild:acceleratorNode2];
        
        
        accelerate = NO;
        pressed = NO;
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
        }
    }
    
    /*acceleratorNode1.fillColor = [UIColor yellowColor];
    acceleratorNode1.glowWidth = 20;
    
    accelerate = YES;
    pressed = YES;*/
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    acceleratorNode1.fillColor = [UIColor clearColor];
    acceleratorNode1.glowWidth = 0;
    
    accelerate = NO;
    pressed = NO;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */

    CGFloat limit = 384;
    CGFloat posx = car1.position.x;
    CGFloat posy = car1.position.y;
    //NSLog(@"Look%f",posx);
    
    if (posx - limit > 0.01 && setted == NO)
    {
        
        setted = YES;
        CGFloat refx = car1.physicsBody.velocity.dx * -1;
        
        car1 = [SKNode node];
        SKShapeNode* circle1 = [SKShapeNode node];
        circle1.path = ([UIBezierPath bezierPathWithOvalInRect:CGRectMake(768, posx+324, 30, 30)]).CGPath;
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
    
    else if (posx - limit > 0.01 && accelerate && pressed)
    {
        
        CGVector trial = CGVectorMake(0, 18);
        [car1.physicsBody applyForce:trial];
    }
    
    else if (accelerate && pressed) {
        if ( setted == NO) {
            CGVector trial = CGVectorMake(18, 0);
            [car1.physicsBody applyForce:trial];
        }
        else {
            CGVector trial = CGVectorMake(-18, 0);
            [car1.physicsBody applyForce:trial];
        }
    }
    else if ( accelerate && pressed && posy){
        
    }
    
    else {
        CGVector trial = CGVectorMake(0, 0);
        [car1.physicsBody applyForce:trial];
    }
}

@end
