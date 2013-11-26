//
//  StartGameVC.m
//  UltimateRacer
//
//  Created by Samir Choudhary on 11/9/13.
//  Copyright (c) 2013 Samir Choudhary. All rights reserved.
//

#import "StartGameVC.h"
#import "UltimateRacerMenuViewController.h"
#import "UltimateRacerWebSockets.h"
#import "UltimateRacerViewController.h"

@interface StartGameVC ()

@end

@implementation StartGameVC
{
    NSMutableString* uniqueCode1;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [UltimateRacerWebSockets sharedInstance];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registeredUser:) name:@"registered_user" object:nil];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    unichar code[5];
    
    code[0] = arc4random() % 26 + 97;
    code[1] = arc4random() % 26 + 97;
    code[2] = arc4random() % 26 + 97;
    code[3] = arc4random() % 26 + 97;
    code[4] = arc4random() % 26 + 97;
    
    uniqueCode1 = [[NSMutableString alloc] initWithCapacity:5];
    [uniqueCode1 appendFormat:@"%C%C%C%C%C", code[0], code[1], code[2], code[3], code[4]];
    [[UltimateRacerWebSockets sharedInstance] sendMessage:[NSString stringWithFormat:@"new_game code:%@",[uniqueCode1 copy]]];
    _codeLabel.text = uniqueCode1;
    _codeLabel.font = [UIFont fontWithName:@"SubatomicTsoonami" size:120];
    _codeLabel.textColor = [UIColor colorWithWhite:1 alpha:0.7];
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
    
    [self performSelector:@selector(displayVC) withObject:self afterDelay:1.5];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) stopMusic
{
    UltimateRacerMenuViewController *parent = (UltimateRacerMenuViewController *)[self presentingViewController];
    [parent.player stop];
}

@end
