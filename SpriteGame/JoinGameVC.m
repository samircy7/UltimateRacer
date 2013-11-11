//
//  JoinGameVC.m
//  UltimateRacer
//
//  Created by Samir Choudhary on 11/9/13.
//  Copyright (c) 2013 Samir Choudhary. All rights reserved.
//

#import "JoinGameVC.h"
#import "UltimateRacerMenuViewController.h"

@interface JoinGameVC ()

@end

@implementation JoinGameVC
{
    NSMutableString *enteredCode;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    
    [enteredCode appendString:string];
    
    if (textField.text.length == 1)
        [self textFieldShouldEndEditing:textField];
    
    [textField resignFirstResponder];
    
    NSInteger index = [self.textFields indexOfObject:textField];
    if (index < 4)
        [[self.textFields objectAtIndex:index+1] becomeFirstResponder];
    else
    {
        _correctImg.hidden = NO;
        _playButton.enabled = YES;
    }
    
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
@end
