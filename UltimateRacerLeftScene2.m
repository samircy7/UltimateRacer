//
//  UltimateRacerLeftScene2.m
//  UltimateRacer
//
//  Created by Sagar Patel on 24/11/13.
//  Copyright (c) 2013 Samir Choudhary. All rights reserved.
//

#import "UltimateRacerLeftScene2.h"

#define WIDTH 697
#define HEIGHT 224

@interface UltimateRacerLeftScene2 ()
{
    SKShapeNode *track1;
    CGVector trial;
    SKNode* car1;
    BOOL accelerate;
    BOOL pressed;
    int turnCount;
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
        track1.strokeColor = [UIColor colorWithRed:0 green:0.9 blue:0 alpha:1];
        track1.glowWidth = 7;
        track1.lineWidth = 5;
        
        car1 = [SKNode node];
        SKShapeNode* circle1 = [SKShapeNode node];
        circle1.path = ([UIBezierPath bezierPathWithOvalInRect:CGRectMake(selfSize.origin.x - 15, selfSize.origin.y - 15, 30, 30)]).CGPath;
        UIColor *myColor1 = [UIColor colorWithRed: 238.0/255.0 green: 213.0/255.0 blue:183.0/255.0 alpha: 1.0];
        circle1.fillColor = myColor1;
        circle1.strokeColor = myColor1;
        [car1 addChild:circle1];
        
        SKEmitterNode *trail = [SKEmitterNode carNamed:@"carParticle1"];
        trail.position = CGPointMake(selfSize.origin.x, selfSize.origin.y);
        trail.targetNode = self;
        [car1 addChild:trail];
        
        car1.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:15];
        [car1.physicsBody setLinearDamping:0.9];
        
        [self addChild:track1];
        [self addChild:car1];
        accelerate = pressed = NO;
        
        accelerate = pressed = NO;
        trial = CGVectorMake(18, 0);
        turnCount = 0;
    }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    accelerate = pressed = YES;
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    accelerate = pressed = NO;
}

- (void) update:(NSTimeInterval)currentTime
{
    if (WIDTH/3 - car1.position.x <= 0.0001 && car1.position.y <= 0.0001 && turnCount == 0) // right bottom corner
    {
        turnCount++;
        
        trial = CGVectorMake(18/sqrt(2), 18/sqrt(2));
        [car1.physicsBody setVelocity:CGVectorMake(car1.physicsBody.velocity.dx/sqrt(2), car1.physicsBody.velocity.dx/sqrt(2))];
        car1.position = CGPointMake(WIDTH/3, 0);
    }

    else if (2*WIDTH/3 - car1.position.x <= 0.0001 && HEIGHT - car1.position.y <= 0.0001 && turnCount == 1)
    {
        turnCount++;
        
        trial = CGVectorMake(18, 0);
        [car1.physicsBody setVelocity:CGVectorMake(car1.physicsBody.velocity.dy*sqrt(2), 0)];
        car1.position = CGPointMake(2*WIDTH/3, HEIGHT);
    }

    else if (HEIGHT - car1.position.y <= 0.0001 && WIDTH - car1.position.x <= 0.0001 && turnCount == 2)
    {
        turnCount++;
        
        trial = CGVectorMake(0, -18);
        [car1.physicsBody setVelocity:CGVectorMake(0, car1.physicsBody.velocity.dx*-1)];
        car1.position = CGPointMake(WIDTH, HEIGHT);
    }

    else if (WIDTH - car1.position.x <= 0.0001 && car1.position.y <= 0.0001 && turnCount == 3)
    {
        turnCount++;
        
        trial = CGVectorMake(-18, 0);
        [car1.physicsBody setVelocity:CGVectorMake(car1.physicsBody.velocity.dy, 0)];
        car1.position = CGPointMake(WIDTH, 0);
    }
    
    else if (2*WIDTH/3 - car1.position.x <= 0.0001 && car1.position.y <= 0.0001 && turnCount == 4)
    {
        if (car1.position.x <= 2*WIDTH/3 + 10) {
        
        turnCount++;
        
        trial = CGVectorMake(-18/sqrt(2), 18/sqrt(2));
        [car1.physicsBody setVelocity:CGVectorMake(car1.physicsBody.velocity.dx/sqrt(2), car1.physicsBody.velocity.dx*-1/sqrt(2))];
            car1.position = CGPointMake(2*WIDTH/3, 0); }
    }
    
    else if (WIDTH/3 - car1.position.x <= 0.0001 && HEIGHT - car1.position.y <= 0.0001 && turnCount == 5)
    {
        turnCount++;
        
        trial = CGVectorMake(-18, 0);
        [car1.physicsBody setVelocity:CGVectorMake(car1.physicsBody.velocity.dx*sqrt(2), 0)];
        car1.position = CGPointMake(WIDTH/3, HEIGHT);
    }
    
    else if (car1.position.x <= 0.0001 && HEIGHT - car1.position.y <= 0.0001 && turnCount == 6)
    {
        turnCount++;
        
        trial = CGVectorMake(0, -18);
        [car1.physicsBody setVelocity:CGVectorMake(0, car1.physicsBody.velocity.dx)];
        car1.position = CGPointMake(0, HEIGHT);
    }
    
    else if (car1.position.x <= 0.0001 && car1.position.y <= 0.0001 && turnCount == 7)
    {
        turnCount = 0;
        
        trial = CGVectorMake(18, 0);
        [car1.physicsBody setVelocity:CGVectorMake(car1.physicsBody.velocity.dy*-1, 0)];
        car1.position = CGPointMake(0, 0);
    }

    else if (accelerate && pressed)
        [car1.physicsBody applyForce:trial];
}

@end

@implementation SKEmitterNode (fromFile)
+ (instancetype)carNamed:(NSString*)name
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:name ofType:@"sks"]];
}
@end
