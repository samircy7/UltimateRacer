//
//  SpriteMyScene.m
//  SpriteGame
//
//  Created by Samir Choudhary on 10/19/13.
//  Copyright (c) 2013 Samir Choudhary. All rights reserved.
//

#import "UltimateRacerLeftScene.h"
#import "UltimateRacerWebSockets.h"
#import "UltimateRacerViewController.h"
#import "UltimateRacerConstants.h"
#import "UltimateRacerGameFinishViewController.h"

#define WIDTH 768
#define HEIGHT 324
#define INTERVAL 1.5
#define TRACKOFFSET 0

@implementation UltimateRacerLeftScene
{
    SKNode* car1;
    SKNode* car2;
    SKShapeNode* track1;
    BOOL accelerate1, accelerate2;
    BOOL pressed1, pressed2;
    BOOL turned1[4];
    BOOL turned2[4];
    SKShapeNode* acceleratorNode1;
    SKShapeNode* acceleratorNode2;
    CGVector trial1;
    CGVector trial2;
    UltimateRacerWebSockets *_webSockets;
    NSMutableString *_message;
    NSTimer *timer;
    NSInteger trackChangeTimer;
    BOOL isGreen;
    int lapCount;
}

@synthesize APlayer;
@synthesize DPlayer;


-(id)initWithSize:(CGSize)size {
        
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.backgroundColor = [SKColor blackColor];
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        
        self.backgroundColor = [UIColor colorWithRed:19.0/255.0 green:9.0/255.0 blue:0 alpha:1.0];
        
        /* Set up of track */
        track1 = [SKShapeNode node];
        
        CGRect selfSize = self.frame;
        selfSize.origin.x = selfSize.size.width/2 - TRACKOFFSET;
        selfSize.origin.y = selfSize.size.height/2 - 112;
        selfSize.size.height -= 700;
        
        track1.path = ([UIBezierPath bezierPathWithRoundedRect:selfSize cornerRadius:10]).CGPath;
        track1.fillColor = [UIColor clearColor];
        track1.strokeColor = [UIColor colorWithRed:0 green:0 blue:0.9 alpha:1];
        track1.glowWidth = 7;
        track1.lineWidth = 23;
        
        SKShapeNode* finishLine = [SKShapeNode node];
        UIBezierPath* path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(selfSize.origin.x+30, selfSize.origin.y-30)];
        [path addLineToPoint:CGPointMake(selfSize.origin.x+30, selfSize.origin.y+30)];
        finishLine.path = path.CGPath;
        finishLine.strokeColor = [UIColor whiteColor];
        finishLine.lineWidth = 4;
        finishLine.glowWidth = 4;

        /* Set up of cars */
        car1 = [SKNode node];
        car2 = [SKNode node];
        
        SKEmitterNode *trail = [SKEmitterNode carNamed:@"carParticle1"];
        trail.position = CGPointMake(selfSize.origin.x, selfSize.origin.y);
        trail.targetNode = self;
        [car1 addChild:trail];
        
        SKEmitterNode *trail2 = [SKEmitterNode carNamed:@"carParticle2"];
        trail2.position = CGPointMake(selfSize.origin.x, selfSize.origin.y);
        trail2.targetNode = self;
        [car2 addChild:trail2];
        
        SKShapeNode* circle1 = [SKShapeNode node];
        circle1.path = ([UIBezierPath bezierPathWithOvalInRect:CGRectMake(selfSize.origin.x - 15, selfSize.origin.y - 15, 30, 30)]).CGPath;
        UIColor *myColor1 = [UIColor colorWithRed: 244.0/255.0 green: 164.0/255.0 blue:96.0/255.0 alpha: 1.0];
        circle1.fillColor = myColor1;
        circle1.strokeColor = myColor1;
        [car1 addChild:circle1];
        
        SKShapeNode* circle2 = [SKShapeNode node];
        circle2.path = ([UIBezierPath bezierPathWithOvalInRect:CGRectMake(selfSize.origin.x - 15, selfSize.origin.y - 15, 30, 30)]).CGPath;
        UIColor *myColor2 = [UIColor colorWithRed:171.0/255.0 green:130.0/255.0 blue:1 alpha:1.0];
        circle2.fillColor = myColor2;
        circle2.strokeColor = myColor2;
        [car2 addChild:circle2];
        
        UIColor *color = [UIColor colorWithRed:252.0/255.0 green:34.0/255.0 blue:228.0/255.0 alpha:0.8];
        SKShapeNode* colorIndicator = [SKShapeNode node];
        CGRect temp;
        temp.origin.x = temp.origin.y = 0;
        temp.size.height = kINDICATORHEIGHT;
        temp.size.width = self.frame.size.width;
        colorIndicator.path = ([UIBezierPath bezierPathWithRect:temp]).CGPath;
        colorIndicator.fillColor = color;
        colorIndicator.strokeColor = [UIColor clearColor];
        
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
        
        isGreen = NO;
        
        [self addChild:track1];
        [self addChild:car1];
        [self addChild:car2];
        [self addChild:acceleratorNode1];
        [self addChild:acceleratorNode2];
        [self addChild:finishLine];
        [self addChild:colorIndicator];
        
        accelerate1 = accelerate2 = NO;
        pressed1 = pressed2 = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRightCar:) name:kUPDATECAR2 object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceleratorPressed2:) name:kACCELERATE2 object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(decceleratorPressed2:) name:kDECCELERATE2 object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameFinished) name:kGAMEFINISHED object:nil];
        _webSockets = [UltimateRacerWebSockets sharedInstance];
        turned1[0] = turned2[0] = YES;
        turned1[1] = turned1[2] = turned1[3] = turned2[1] = turned2[2] = turned2[3] = NO;
        trial1 = trial2 = CGVectorMake(18, 0);
        timer = [NSTimer scheduledTimerWithTimeInterval:INTERVAL target:self selector:@selector(updateCar) userInfo:nil repeats:YES];
        
        trackChangeTimer = 100 + (arc4random() % 200);
        lapCount = 0;
    }
    return self;
}

- (void)updateRightCar:(NSNotification *)note
{
    NSDictionary *json = [note object];
    car2.position = CGPointMake([[json objectForKey:@"car2.x"] floatValue], [[json objectForKey:@"car2.y"] floatValue]);
    car2.physicsBody.velocity = CGVectorMake([[json objectForKey:@"velocity2.x"] floatValue], [[json objectForKey:@"velocity2.y"] floatValue]);
    turned2[0] = [[json objectForKey:@"turned_0"] boolValue];
    turned2[1] = [[json objectForKey:@"turned_1"] boolValue];
    turned2[2] = [[json objectForKey:@"turned_2"] boolValue];
    turned2[3] = [[json objectForKey:@"turned_3"] boolValue];
}

- (void)updateCar
{
    _message = [NSMutableString stringWithFormat:@"{ \"%@\":\"left\" , ", kUPDATECAR1];
    [_message appendString:[NSString stringWithFormat:@"\"car1.x\":%f, \"car1.y\":%f, \"velocity1.x\":%f, \"velocity1.y\":%f, \"turned_0\":%d, \"turned_1\":%d, \"turned_2\":%d, \"turned_3\":%d }", car1.position.x, car1.position.y, car1.physicsBody.velocity.dx, car1.physicsBody.velocity.dy, turned1[0], turned1[1], turned1[2], turned1[3]]];
    [[UltimateRacerWebSockets sharedInstance] sendMessage:_message];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UltimateRacerViewController* temp = (UltimateRacerViewController *)self.view.window.rootViewController.presentedViewController.presentedViewController;
    
    if ([temp checkCountDown])
        return;
    
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
            if (check1 && check2 && !isGreen)
            {
                acceleratorNode1.fillColor = [UIColor colorWithRed:0 green:0 blue:0.9 alpha:1];
                acceleratorNode1.glowWidth = 20;
                accelerate1 = YES;
                pressed1 = YES;
            }
                
            if (check5 && check6 && isGreen)
            {
                acceleratorNode2.fillColor = [UIColor colorWithRed:0 green:100.0/255.0 blue:0 alpha:1];
                acceleratorNode2.glowWidth = 20;
                accelerate1 = YES;
                pressed1 = YES;
            }
        }
        
        if (accelerate1 && pressed1)
        {
            [DPlayer stop];
            //NSLog(@"Accelerate");
            NSURL * countDownURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Accelerate.mp3",[[NSBundle mainBundle] resourcePath]]];
            NSError * error;
            
            APlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:countDownURL error:&error];
            APlayer.numberOfLoops = 0;
            
            [APlayer prepareToPlay];
            [APlayer play];
            [_webSockets sendMessage:kACCELERATE1];
        }
    }
}
//
//- (void)acceleratorPressed1
//{
//    accelerate1 = YES;
//    pressed1 = YES;
//}
//
//- (void)decceleratorPressed1
//{
//    accelerate1 = NO;
//    pressed1 = NO;
//}

- (void)acceleratorPressed2:(NSNotification *)note
{
    accelerate2 = YES;
    pressed2 = YES;
}

- (void)decceleratorPressed2:(NSNotification *)note
{
    accelerate2 = NO;
    pressed2 = NO;
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{    
    if (accelerate1)
    {
        [APlayer stop];
        
        acceleratorNode1.fillColor = acceleratorNode2.fillColor = [UIColor clearColor];
        acceleratorNode1.glowWidth = acceleratorNode2.glowWidth = 0;
        
        accelerate1 = NO;
        pressed1 = NO;
        
        NSURL * countDownURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Deccelerate.mp3",[[NSBundle mainBundle] resourcePath]]];
        NSError * error;
        
        DPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:countDownURL error:&error];
        DPlayer.numberOfLoops = 0;
        
        [DPlayer prepareToPlay];
        [DPlayer play];
        [_webSockets sendMessage:kDECCELERATE1];
    }
}

-(void) changeColorBlue
{
    track1.strokeColor = [UIColor colorWithRed:0 green:0 blue:0.9 alpha:1];
    isGreen = NO;
}

-(void) changeColorGreen
{
    track1.strokeColor = [UIColor colorWithRed:0 green:100.0/255.0 blue:0 alpha:1];
    isGreen = YES;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    if (trackChangeTimer == 0)
    {
        if (!isGreen)
        {
            [[UltimateRacerWebSockets sharedInstance] sendMessage:@"color_change:green"];
            [self performSelector:@selector(changeColorGreen) withObject:self afterDelay:0.038];
            acceleratorNode1.fillColor = [UIColor clearColor];
            acceleratorNode1.glowWidth = 0;
            isGreen = YES;
        }
        else if (isGreen)
        {
            [[UltimateRacerWebSockets sharedInstance] sendMessage:@"color_change:blue"];
            [self performSelector:@selector(changeColorBlue) withObject:self afterDelay:0.038];
            acceleratorNode2.fillColor = [UIColor clearColor];
            acceleratorNode2.glowWidth = 0;
            isGreen = NO;
        }
        trackChangeTimer = 100 + (arc4random() % 200);
        
        [APlayer stop];
        
        if (accelerate2 && pressed2)
        {
            NSURL * countDownURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Deccelerate.mp3",[[NSBundle mainBundle] resourcePath]]];
            NSError * error;
            
            DPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:countDownURL error:&error];
            DPlayer.numberOfLoops = 0;
            
            [DPlayer prepareToPlay];
            [DPlayer play];
            [_webSockets sendMessage:kDECCELERATE1];
        }
    }
    else
    {
        trackChangeTimer--;
    }
    
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
        
        UltimateRacerViewController* temp = (UltimateRacerViewController *)self.view.window.rootViewController.presentedViewController.presentedViewController;
        
        [temp hideLight];
        lapCount++;
        [_label setText:[NSString stringWithFormat:@"Lap %d/3", lapCount]];
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
    
    if(lapCount == 3)
    {
        UltimateRacerGameFinishViewController *vc = (UltimateRacerGameFinishViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GameFinishVC"];
        [vc setMessage:@"Winner"];
        [_webSockets sendMessage:kGAMEFINISHED];
        [self.viewController presentViewController:vc animated:YES completion:^{
            [self.viewController dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

- (void)gameFinished
{
    if(lapCount < 3)
    {
        UltimateRacerGameFinishViewController *vc = (UltimateRacerGameFinishViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GameFinishVC"];
        [vc setMessage:@"Try Again"];
        [self.viewController presentViewController:vc animated:YES completion:nil];
    }
}

- (void)dealloc
{
    [timer invalidate];
}

@end

@implementation SKEmitterNode (fromFile)
+ (instancetype)carNamed:(NSString*)name
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:name ofType:@"sks"]];
}
@end
