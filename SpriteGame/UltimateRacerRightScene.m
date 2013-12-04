//
//  Sprite.m
//  SpriteGame
//
//  Created by Samir Choudhary on 11/8/13.
//  Copyright (c) 2013 Samir Choudhary. All rights reserved.
//

#define WIDTH 768
#define HEIGHT 324
#define OFFSET 1
#define TRACKOFFSET 0
#define SETORIGIN -1

#import "UltimateRacerRightScene.h"

#import "UltimateRacerConstants.h"

@implementation UltimateRacerRightScene
{
    SKNode* car1;
    SKShapeNode* track1;
    BOOL turned[4];
    CGPoint corners[4];
    BOOL accelerate;
    BOOL pressed;
    SKShapeNode* acceleratorNode1;
    SKShapeNode* acceleratorNode2;
    CGVector trial;
    CGFloat offset;
    CGVector offsetVector;
    BOOL isBlue;
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
        selfSize.origin.x = (selfSize.size.width/2 + TRACKOFFSET)*SETORIGIN;
        selfSize.origin.y = selfSize.size.height/2 - 112;
        selfSize.size.height -= 700;
        
        corners[0] = CGPointMake(selfSize.origin.x - 15, selfSize.origin.y - 15);
        corners[1] = CGPointMake(selfSize.origin.x - 15 + selfSize.size.width, selfSize.origin.y - 15);
        corners[2] = CGPointMake(selfSize.origin.x - 15 + selfSize.size.width, selfSize.origin.y - 15 + selfSize.size.height);
        corners[3] = CGPointMake(selfSize.origin.x - 15, selfSize.origin.y - 15 + selfSize.size.height);
        
        track1.path = ([UIBezierPath bezierPathWithRoundedRect:selfSize cornerRadius:10]).CGPath;
        track1.fillColor = [UIColor clearColor];
        track1.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.8];
        track1.glowWidth = 7;
        track1.lineWidth = 23;
        
        /* Set up of cars */
        car1 = [SKNode node];
        SKShapeNode* circle1 = [SKShapeNode node];
        circle1.path = ([UIBezierPath bezierPathWithOvalInRect:CGRectMake(corners[0].x, corners[0].y, 30, 30)]).CGPath;
        UIColor *myColor1 = [UIColor colorWithRed: 176.0/255.0 green: 226.0/255.0 blue:255.0/255.0 alpha: 1.0];
        circle1.fillColor = myColor1;
        [car1 addChild:circle1];
        
        SKEmitterNode *trail = [SKEmitterNode carNamed:@"carParticle2"];
        trail.position = CGPointMake(selfSize.origin.x, selfSize.origin.y);
        trail.targetNode = self;
        [car1 addChild:trail];
        
        car1.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:15];
        [car1.physicsBody setLinearDamping:0.9];
        
        /* Set up of accelerator nodes */
        acceleratorNode1 = [SKShapeNode node];
        acceleratorNode1.path = ([UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.frame.size.width/2-200, 100, 100, 100)]).CGPath;
        acceleratorNode1.strokeColor = [UIColor colorWithRed:0 green:0 blue:0.9 alpha:1];
        
        acceleratorNode2 = [SKShapeNode node];
        acceleratorNode2.path = ([UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.frame.size.width/2+100, 100, 100, 100)]).CGPath;
        acceleratorNode2.strokeColor = [UIColor colorWithRed:0 green:100.0/225.0 blue:0 alpha:1];
        
        [self addChild:track1];
        [self addChild:car1];
        [self addChild:acceleratorNode1];
        [self addChild:acceleratorNode2];
        
        accelerate = NO;
        pressed = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceleratorPressed:) name:kACCELERATE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(decceleratorPressed:) name:kDECCELERATE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLeftCar:) name:kUPDATECAR object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeColor:) name:kCOLORCHANGE object:nil];
        
        turned[0] = YES;
        turned[1] = turned[2] = turned[3] = NO;
        trial = CGVectorMake(18, 0);
        offset = 0;
        isBlue = YES;
    }
    return self;
}

- (void)changeColor:(NSNotification *)note
{
    BOOL isGreen = ([[note object] rangeOfString:@"green"].location != NSNotFound);
    if(isGreen)
    {
        track1.strokeColor = [UIColor colorWithRed:0 green:100.0/255.0 blue:0 alpha:1];
        acceleratorNode1.fillColor = [UIColor clearColor];
        acceleratorNode1.glowWidth = 0;
        isBlue = NO;
    }
    else
    {
        track1.strokeColor = [UIColor colorWithRed:0 green:0 blue:0.9 alpha:1];
        acceleratorNode2.fillColor = [UIColor clearColor];
        acceleratorNode2.glowWidth = 0;
        isBlue = YES;
    }
}

- (void)updateLeftCar:(NSNotification *)note
{
    NSDictionary *json = [note object];
    car1.position = CGPointMake([[json objectForKey:@"car1.x"] floatValue], [[json objectForKey:@"car1.y"] floatValue]);
    car1.physicsBody.velocity = CGVectorMake([[json objectForKey:@"velocity1.x"] floatValue], [[json objectForKey:@"velocity1.y"] floatValue]);
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch* touch in touches)
    {
        CGPoint temp = [touch locationInView:self.view];
        
        //left node
        BOOL check1 = temp.x > self.frame.size.width/2 - 220;
        BOOL check2 = temp.x < self.frame.size.width/2 - 80;
        
        //right node
        BOOL check5 = temp.x > self.frame.size.width/2 + 80;
        BOOL check6 = temp.x < self.frame.size.width/2 + 220;
        
        //common y-axis check
        BOOL check3 = temp.y > self.frame.size.height - 230;
        BOOL check4 = temp.y < self.frame.size.height - 70;
        
        if (check3 && check4)
        {
            if (check1 && check2 && isBlue)
            {
                acceleratorNode1.fillColor = [UIColor colorWithRed:0 green:0 blue:0.9 alpha:1];
                acceleratorNode1.glowWidth = 20;
                accelerate = YES;
                pressed = YES;
            }
            
            else if (check5 && check6 && isBlue)
            {
                acceleratorNode2.fillColor = [UIColor colorWithRed:0 green:100.0/255.0 blue:0 alpha:1];
                acceleratorNode2.glowWidth = 20;
                accelerate = YES;
                pressed = YES;
            }
        }
        
        if (accelerate && pressed)
        {
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
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (accelerate) {
        
        acceleratorNode1.fillColor = acceleratorNode2.fillColor = [UIColor clearColor];
        acceleratorNode1.glowWidth = acceleratorNode2.glowWidth = 0;
        
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
    
    if (WIDTH - car1.position.x <= 0.001 && !turned[1] && !turned[2]) // right bottom corner
    {
        turned[0] = NO;
        turned[1] = YES;
        
        trial = CGVectorMake(0, 18+offset);
        offsetVector = CGVectorMake(0, offset);
        [car1.physicsBody setVelocity:CGVectorMake(0, car1.physicsBody.velocity.dx)];
        car1.position = CGPointMake(WIDTH, 0);
    }
    
    if (WIDTH - car1.position.x <= 0.001 && HEIGHT - car1.position.y <= 0.001 && !turned[2])
    {
        turned[1] = NO;
        turned[2] = YES;
        
        trial = CGVectorMake(-(18+offset), 0);
        offsetVector = CGVectorMake(-offset, 0);
        [car1.physicsBody setVelocity:CGVectorMake(-1*car1.physicsBody.velocity.dy, 0)];
        car1.position = CGPointMake(WIDTH, HEIGHT);
    }
    
    if (HEIGHT - car1.position.y <= 0.001 && car1.position.x <= 0.001 && !turned[3])
    {
        turned[2] = NO;
        turned[3] = YES;
        
        trial = CGVectorMake(0, -(18+offset));
        offsetVector = CGVectorMake(0, -offset);
        [car1.physicsBody setVelocity:CGVectorMake(0, car1.physicsBody.velocity.dx)];
        car1.position = CGPointMake(0, HEIGHT);
    }
    
    if (car1.position.x <= 0.001 && car1.position.y <= 0.001 && !turned[0])
    {
        turned[3] = NO;
        turned[0] = YES;
        
        trial = CGVectorMake(18+offset, 0);
        offsetVector = CGVectorMake(offset, 0);
        [car1.physicsBody setVelocity:CGVectorMake(-1*car1.physicsBody.velocity.dy, 0)];
        car1.position = CGPointMake(0, 0);
    }
    
    if (accelerate && pressed)
        [car1.physicsBody applyForce:trial];
}

@end

@implementation SKEmitterNode (fromFile)
+ (instancetype)carNamed:(NSString*)name
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:name ofType:@"sks"]];
}
@end


