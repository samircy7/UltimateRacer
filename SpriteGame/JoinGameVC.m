//
//  JoinGameVC.m
//  UltimateRacer
//
//  Created by Samir Choudhary on 11/9/13.
//  Copyright (c) 2013 Samir Choudhary. All rights reserved.
//

#import "JoinGameVC.h"
#import "UltimateRacerMenuViewController.h"
#import "UltimateRacerWebSockets.h"
#import "UltimateRacerViewController.h"

@interface JoinGameVC ()

@end

@implementation JoinGameVC
{
    NSMutableString *enteredCode;
}
@synthesize effectPlayer;


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registeredUser:) name:@"registered_user" object:nil];
        [UltimateRacerWebSockets sharedInstance];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) displayVC
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UltimateRacerViewController* vc = (UltimateRacerViewController *)[storyboard instantiateViewControllerWithIdentifier:@"mainvc"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)registeredUser:(NSNotification *)note
{
    NSLog(@"%@", [note object]);
    
    _correctImg.hidden = NO;
    
    [self performSelector:@selector(displayVC) withObject:self afterDelay:1.73];
}

- (id) initWithSoundFile:(AVAudioPlayer *)player
{
    self = [super init];
    if (self)
    {
        _player = player;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    for (UITextField *temp in self.textFields) {
        temp.font = [UIFont fontWithName:@"SubatomicTsoonami" size:70];
        temp.delegate = self;
    }
    enteredCode = [[NSMutableString alloc] initWithCapacity:5];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    textField.text = string;
    
    if ([string isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];
        return YES;
    }
    
    if (textField.text.length == 1)
        [enteredCode appendString:string];

    else
    {
        NSRange range;
        range.length = 1;
        range.location = [self.textFields indexOfObject:textField];
        [enteredCode deleteCharactersInRange:range];
    }
    
    if (textField.text.length == 1 || [textField.text isEqual: @""])
        [self textFieldShouldEndEditing:textField];
    
    [textField resignFirstResponder];
    
    NSInteger index = [self.textFields indexOfObject:textField];
    
    
    NSURL * SelectURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Select.mp3",[[NSBundle mainBundle] resourcePath]]];
    NSError * error;
    
    effectPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:SelectURL error:&error];
    effectPlayer.numberOfLoops = 0;
    
    [effectPlayer prepareToPlay];
    [effectPlayer setVolume:1.0];
    
    
    
    
    if (index < 4 && textField.text.length == 1){
        [[self.textFields objectAtIndex:index+1] becomeFirstResponder];
        [effectPlayer play];
    }
    else if (index > 0 && [textField.text isEqual: @""]){
        [[self.textFields objectAtIndex:index-1] becomeFirstResponder];
        [effectPlayer play];
    }

    if ([enteredCode length] == 5)
        [[UltimateRacerWebSockets sharedInstance] sendMessage:[NSString stringWithFormat:@"register_user:hello code:%@", enteredCode]];
        
    return NO;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void) stopMusic
{
    UltimateRacerMenuViewController *parent = (UltimateRacerMenuViewController *)[self presentingViewController];
    [parent.player stop];
}
@end
