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
#define INTERVAL 1.5

#import "UltimateRacerRightScene.h"
#import "UltimateRacerWebSockets.h"
#import "UltimateRacerConstants.h"

@implementation UltimateRacerRightScene
{
    SKNode* car1;
    SKNode* car2;
    SKShapeNode* track1;
    BOOL turned1[4];
    BOOL turned2[4];
    CGPoint corners[4];
    BOOL accelerate1;
    BOOL pressed1;
    BOOL accelerate2;
    BOOL pressed2;
    SKShapeNode* acceleratorNode1;
    SKShapeNode* acceleratorNode2;
    NSMutableString *_message;
    CGVector trial1;
    CGVector trial2;
    CGFloat offset;
    CGVector offsetVector;
    BOOL isBlue;
    UltimateRacerWebSockets *_webSockets;
    NSTimer *timer;
    NSInteger trackChangeTimer;
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
        selfSize.origin.x = selfSize.size.width/2 * -1;
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
        
        car2 = [SKNode node];
        SKShapeNode* circle2 = [SKShapeNode node];
        circle2.path = ([UIBezierPath bezierPathWithOvalInRect:CGRectMake(selfSize.origin.x - 15, selfSize.origin.y - 15, 30, 30)]).CGPath;
        UIColor *myColor2 = [UIColor redColor];
        circle2.fillColor = myColor2;
        circle2.strokeColor = myColor2;
        [car2 addChild:circle2];
        
        SKEmitterNode *trail = [SKEmitterNode carNamed:@"carParticle2"];
        trail.position = CGPointMake(selfSize.origin.x, selfSize.origin.y);
        trail.targetNode = self;
        [car1 addChild:trail];
        
        car1.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:15];
        [car1.physicsBody setLinearDamping:0.9];
        car1.physicsBody.collisionBitMask = 0x00000000;
        car1.physicsBody.categoryBitMask = 0x00000000;
        car1.physicsBody.contactTestBitMask = 0x00000000;
        
        car2.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:15];
        [car2.physicsBody setLinearDamping:0.9];
        car2.physicsBody.collisionBitMask = 0x00000000;
        car2.physicsBody.categoryBitMask = 0x00000000;
        car2.physicsBody.contactTestBitMask = 0x00000000;

        
        /* Set up of accelerator nodes */
        
        acceleratorNode1 = [SKShapeNode node];
        acceleratorNode1.path = ([UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.frame.size.width/2-200, 100, 100, 100)]).CGPath;
        acceleratorNode1.strokeColor = [UIColor colorWithRed:0 green:0 blue:0.9 alpha:1];
        
        acceleratorNode2 = [SKShapeNode node];
        acceleratorNode2.path = ([UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.frame.size.width/2+100, 100, 100, 100)]).CGPath;
        acceleratorNode2.strokeColor = [UIColor colorWithRed:0 green:100.0/225.0 blue:0 alpha:1];
        
        [self addChild:track1];
        [self addChild:car1];
        [self addChild:car2];
        [self addChild:acceleratorNode1];
        [self addChild:acceleratorNode2];
        
        accelerate1 = accelerate2 = NO;
        pressed1 = pressed2 = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceleratorPressed1:) name:kACCELERATE1 object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(decceleratorPressed1:) name:kDECCELERATE1 object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLeftCar:) name:kUPDATECAR1 object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeColor:) name:kCOLORCHANGE object:nil];
        
        turned1[0] = turned2[0] = YES;
        turned1[1] = turned1[2] = turned1[3] = turned2[1] = turned2[2] = turned2[3] = NO;
        trial1 = trial2 = CGVectorMake(18, 0);
        isBlue = YES;
        
        timer = [NSTimer scheduledTimerWithTimeInterval:INTERVAL target:self selector:@selector(updateCar) userInfo:nil repeats:YES];
        
        trackChangeTimer = 100 + (arc4random() % 200);
        _webSockets = [UltimateRacerWebSockets sharedInstance];
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
    
    [APlayer stop];
    
    if (accelerate2 && pressed2)
    {
        NSURL * countDownURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Deccelerate.mp3",[[NSBundle mainBundle] resourcePath]]];
        NSError * error;
        
        DPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:countDownURL error:&error];
        DPlayer.numberOfLoops = 0;
        
        [DPlayer prepareToPlay];
        [DPlayer play];
        [_webSockets sendMessage:kDECCELERATE2];
    }
}

- (void)updateLeftCar:(NSNotification *)note
{
    NSDictionary *json = [note object];
    car1.position = CGPointMake([[json objectForKey:@"car1.x"] floatValue], [[json objectForKey:@"car1.y"] floatValue]);
    car1.physicsBody.velocity = CGVectorMake([[json objectForKey:@"velocity1.x"] floatValue], [[json objectForKey:@"velocity1.y"] floatValue]);
}

- (void)updateCar
{
    _message = [NSMutableString stringWithFormat:@"{ \"%@\":\"right\" , ", kUPDATECAR2];
    [_message appendString:[NSString stringWithFormat:@"\"car2.x\":%f, \"car2.y\":%f, \"velocity2.x\":%f, \"velocity2.y\":%f }", car2.position.x, car2.position.y, car2.physicsBody.velocity.dx, car2.physicsBody.velocity.dy]];
    [[UltimateRacerWebSockets sharedInstance] sendMessage:_message];
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
                accelerate2 = YES;
                pressed2 = YES;
            }
            
            if (check5 && check6 && !isBlue)
            {
                acceleratorNode2.fillColor = [UIColor colorWithRed:0 green:100.0/255.0 blue:0 alpha:1];
                acceleratorNode2.glowWidth = 20;
                accelerate2 = YES;
                pressed2 = YES;
            }
        }
        
        if (accelerate2 && pressed2)
        {
            [DPlayer stop];
            NSLog(@"Accelerate");
            NSURL * countDownURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Accelerate.mp3",[[NSBundle mainBundle] resourcePath]]];
            NSError * error;
            
            APlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:countDownURL error:&error];
            APlayer.numberOfLoops = 0;
            
            [APlayer prepareToPlay];
            [APlayer play];
            [_webSockets sendMessage:kACCELERATE2];
        }
    }

}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (accelerate2)
    {
        [APlayer stop];
        
        acceleratorNode1.fillColor = acceleratorNode2.fillColor = [UIColor clearColor];
        acceleratorNode1.glowWidth = acceleratorNode2.glowWidth = 0;
        
        accelerate2 = NO;
        pressed2 = NO;
        
        NSURL * countDownURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Deccelerate.mp3",[[NSBundle mainBundle] resourcePath]]];
        NSError * error;
        
        DPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:countDownURL error:&error];
        DPlayer.numberOfLoops = 0;
        
        [DPlayer prepareToPlay];
        [DPlayer play];
        [_webSockets sendMessage:kDECCELERATE2];
    }
}

- (void)acceleratorPressed1:(NSNotification *)note
{
    accelerate1 = YES;
    pressed1 = YES;
}

- (void)decceleratorPressed1:(NSNotification *)note
{
    accelerate1 = NO;
    pressed1 = NO;
}

//- (void)acceleratorPressed2
//{
//    accelerate2 = YES;
//    pressed2 = YES;
//}
//
//- (void)decceleratorPressed2
//{
//    accelerate2 = NO;
//    pressed2 = NO;
//}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    if (WIDTH - car1.position.x <= 0.000001 && !turned1[1] && !turned1[2]) // right bottom corner
    {
        turned1[0] = NO;
        turned1[1] = YES;
        
        trial1 = CGVectorMake(0, 18);
        [car1.physicsBody setVelocity:CGVectorMake(0, car1.physicsBody.velocity.dx)];
        car1.position = CGPointMake(WIDTH, 0);
    }
    
    if (WIDTH - car1.position.x <= 0.0000001 && HEIGHT - car1.position.y <= 0.0000001 && !turned1[2])
    {
        turned1[1] = NO;
        turned1[2] = YES;
        
        trial1 = CGVectorMake(-18, 0);
        [car1.physicsBody setVelocity:CGVectorMake(-1*car1.physicsBody.velocity.dy, 0)];
        car1.position = CGPointMake(WIDTH, HEIGHT);
    }
    
    if (HEIGHT - car1.position.y <= 0.0000001 && car1.position.x <= 0.0000001 && !turned1[3])
    {
        turned1[2] = NO;
        turned1[3] = YES;
        
        trial1 = CGVectorMake(0, -18);
        [car1.physicsBody setVelocity:CGVectorMake(0, car1.physicsBody.velocity.dx)];
        car1.position = CGPointMake(0, HEIGHT);
    }
    
    if (car1.position.x <= 0.0000001 && car1.position.y <= 0.0000001 && !turned1[0])
    {
        turned1[3] = NO;
        turned1[0] = YES;
        
        trial1 = CGVectorMake(18, 0);
        [car1.physicsBody setVelocity:CGVectorMake(-1*car1.physicsBody.velocity.dy, 0)];
        car1.position = CGPointMake(0, 0);
    }
    
    if (accelerate1 && pressed1)
        [car1.physicsBody applyForce:trial1];
    
    if (WIDTH - car2.position.x <= 0.001 && !turned2[1] && !turned2[2]) // right bottom corner
    {
        turned2[0] = NO;
        turned2[1] = YES;
        
        trial2 = CGVectorMake(0, 18);
        [car2.physicsBody setVelocity:CGVectorMake(0, car2.physicsBody.velocity.dx)];
        car2.position = CGPointMake(WIDTH, 0);
    }
    
    if (WIDTH - car2.position.x <= 0.001 && HEIGHT - car2.position.y <= 0.001 && !turned2[2])
    {
        turned2[1] = NO;
        turned2[2] = YES;
        
        trial2 = CGVectorMake(-18, 0);
        [car2.physicsBody setVelocity:CGVectorMake(-1*car2.physicsBody.velocity.dy, 0)];
        car2.position = CGPointMake(WIDTH, HEIGHT);
    }
    
    if (HEIGHT - car2.position.y <= 0.001 && car2.position.x <= 0.001 && !turned2[3])
    {
        turned2[2] = NO;
        turned2[3] = YES;
        
        trial2 = CGVectorMake(0, -18);
        [car2.physicsBody setVelocity:CGVectorMake(0, car2.physicsBody.velocity.dx)];
        car2.position = CGPointMake(0, HEIGHT);
    }
    
    if (car2.position.x <= 0.001 && car2.position.y <= 0.001 && !turned2[0])
    {
        turned2[3] = NO;
        turned2[0] = YES;
        
        trial2 = CGVectorMake(18, 0);
        [car2.physicsBody setVelocity:CGVectorMake(-1*car2.physicsBody.velocity.dy, 0)];
        car2.position = CGPointMake(0, 0);
    }
    
    if (accelerate2 && pressed2)
        [car2.physicsBody applyForce:trial2];
}

@end

@implementation SKEmitterNode (fromFile)
+ (instancetype)carNamed:(NSString*)name
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:name ofType:@"sks"]];
}
@end


