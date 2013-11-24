//
//  SpriteMyScene.m
//  SpriteGame
//
//  Created by Samir Choudhary on 10/19/13.
//  Copyright (c) 2013 Samir Choudhary. All rights reserved.
//

#import "UltimateRacerLeftScene.h"
#import "UltimateRacerWebSockets.h"

#define WIDTH 568
#define HEIGHT 324

@implementation UltimateRacerLeftScene
{
    SKNode* car1;
    SKShapeNode* track1;
    BOOL accelerate;
    BOOL pressed;
    BOOL turned[4];
    SKShapeNode* acceleratorNode1;
    SKShapeNode* acceleratorNode2;
    CGVector trial;
    UltimateRacerWebSockets *_webSockets;
    NSMutableString *_message;
}

@synthesize APlayer;
@synthesize DPlayer;
@synthesize CountPlayer;
-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.backgroundColor = [SKColor blackColor];
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        
        /* Set up of track */
        track1 = [SKShapeNode node];
        
        CGRect selfSize = self.frame;
        selfSize.origin.x = selfSize.size.width/2 - 300;
        selfSize.origin.y = selfSize.size.height/2 - 112;
        selfSize.size.height -= 700;
        selfSize.size.width -= 200;
        
        track1.path = ([UIBezierPath bezierPathWithRoundedRect:selfSize cornerRadius:10]).CGPath;
        track1.fillColor = [UIColor clearColor];
        track1.strokeColor = [UIColor blueColor];
        track1.glowWidth = 7;
        track1.lineWidth = 23;

        /* Set up of cars */
        car1 = [SKNode node];
        SKShapeNode* circle1 = [SKShapeNode node];
        circle1.path = ([UIBezierPath bezierPathWithOvalInRect:CGRectMake(selfSize.origin.x - 15, selfSize.origin.y - 15, 30, 30)]).CGPath;
        UIColor *myColor1 = [UIColor colorWithRed: 176.0/255.0 green: 226.0/255.0 blue:255.0/255.0 alpha: 1.0];
        circle1.fillColor = myColor1;
        [car1 addChild:circle1];
        
        SKEmitterNode *trail = [SKEmitterNode carNamed:@"carParticle1"];
        trail.position = CGPointMake(selfSize.origin.x, selfSize.origin.y);
        trail.targetNode = self;
        [car1 addChild:trail];
        
        car1.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:15];
        [car1.physicsBody setLinearDamping:0.9];
        
        /* Set up of accelerator nodes */
        
        acceleratorNode1 = [SKShapeNode node];
        acceleratorNode1.name = @"Car 1";
        acceleratorNode1.path = ([UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.frame.size.width/2-50, 100, 100, 100)]).CGPath;
        acceleratorNode1.strokeColor = [UIColor yellowColor];
        
        
        [self addChild:track1];
        [self addChild:car1];
        [self addChild:acceleratorNode1];
        //[self addChild:acceleratorNode2];
        
        accelerate = NO;
        pressed = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceleratorPressed:) name:@"accelerate_car" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(decceleratorPressed:) name:@"deccelerate_car" object:nil];
        _webSockets = [UltimateRacerWebSockets sharedInstance];
        turned[0] = YES;
        turned[1] = turned[2] = turned[3] = NO;
        trial = CGVectorMake(18, 0);
    }
    
    
    
    
    [self performSelector:@selector(setUpCountDown) withObject:self afterDelay:1.0];
    
    
    return self;
}

- (void) setUpCountDown
{
    NSURL * countDownURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/CountDown.mp3",[[NSBundle mainBundle] resourcePath]]];
    NSError * error;
    
    CountPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:countDownURL error:&error];
    CountPlayer.numberOfLoops = 0;
    
    [CountPlayer prepareToPlay];
    [CountPlayer play];
    
    
    
    
    
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch* touch in touches)
    {
        CGPoint temp = [touch locationInView:self.view];
        
        BOOL check1 = temp.x > self.frame.size.width/2 - 70;
        BOOL check2 = temp.x < self.frame.size.width/2 + 70;
        BOOL check3 = temp.y > self.frame.size.height - 230;
        BOOL check4 = temp.y < self.frame.size.height - 70;
        
        if (check1 && check2 && check3 && check4) {
            acceleratorNode1.fillColor = [UIColor yellowColor];
            acceleratorNode1.glowWidth = 20;
            accelerate = YES;
            pressed = YES;
            
            [DPlayer stop];
            //NSLog(@"Accelerate");
            NSURL * countDownURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Accelerate.mp3",[[NSBundle mainBundle] resourcePath]]];
            NSError * error;
            
            APlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:countDownURL error:&error];
            APlayer.numberOfLoops = 0;
            
            [APlayer prepareToPlay];
            [APlayer play];
            NSMutableString *message = [NSMutableString stringWithFormat:@"{ \"accelerate_car\":\"left\" , "];
            [message appendString:[NSString stringWithFormat:@"\"car1.x\":%f, \"car1.y\":%f, \"acc1.x\":%f, \"acc2.x\":%f }", car1.position.x, car1.position.y, trial.dx, trial.dy]];
            [_webSockets sendMessage:message];
        }
    }
}

- (void)acceleratorPressed:(NSNotification *)note
{
    accelerate = YES;
    pressed = YES;
}

- (void)decceleratorPressed:(NSNotification *)note
{
    accelerate = NO;
    pressed = NO;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (pressed) {
        
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
        NSMutableString *message = [NSMutableString stringWithFormat:@"{ \"deccelerate_car\":\"left\" , "];
        [message appendString:[NSString stringWithFormat:@"\"car1.x\":%f, \"car1.y\":%f, \"acc1.x\":%f, \"acc2.x\":%f }", car1.position.x, car1.position.y, trial.dx, trial.dy]];
        [_webSockets sendMessage:message];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if (WIDTH - car1.position.x <= 0.000001 && !turned[1] && !turned[2]) // right bottom corner
    {
        turned[0] = NO;
        turned[1] = YES;
        
        trial = CGVectorMake(0, 18);
        [car1.physicsBody setVelocity:CGVectorMake(0, car1.physicsBody.velocity.dx)];
    }
    
    if (WIDTH - car1.position.x <= 0.0000001 && HEIGHT - car1.position.y <= 0.0000001 && !turned[2])
    {
        turned[1] = NO;
        turned[2] = YES;
        
        trial = CGVectorMake(-18, 0);
        [car1.physicsBody setVelocity:CGVectorMake(-1*car1.physicsBody.velocity.dy, 0)];
    }
    
    if (HEIGHT - car1.position.y <= 0.0000001 && car1.position.x <= 0.0000001 && !turned[3])
    {
        turned[2] = NO;
        turned[3] = YES;
        
        trial = CGVectorMake(0, -18);
        [car1.physicsBody setVelocity:CGVectorMake(0, car1.physicsBody.velocity.dx)];
    }
    
    if (car1.position.x <= 0.0000001 && car1.position.y <= 0.0000001 && !turned[0])
    {
        turned[3] = NO;
        turned[0] = YES;
        
        trial = CGVectorMake(18, 0);
        [car1.physicsBody setVelocity:CGVectorMake(-1*car1.physicsBody.velocity.dy, 0)];
    }
    
    if (accelerate && pressed)
        [car1.physicsBody applyForce:trial];
    _message = [NSMutableString stringWithFormat:@"{ \"update_car\":\"left\" , "];
    [_message appendString:[NSString stringWithFormat:@"\"car1.x\":%f, \"car1.y\":%f, \"acc1.x\":%f, \"acc2.x\":%f }", car1.position.x, car1.position.y, trial.dx, trial.dy]];
    [[UltimateRacerWebSockets sharedInstance] sendMessage:_message];
}

@end

@implementation SKEmitterNode (fromFile)
+ (instancetype)carNamed:(NSString*)name
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:name ofType:@"sks"]];
}
@end
