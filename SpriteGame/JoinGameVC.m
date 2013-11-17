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
    
    if (index < 4 && textField.text.length == 1)
        [[self.textFields objectAtIndex:index+1] becomeFirstResponder];
    else if (index > 0 && [textField.text isEqual: @""])
        [[self.textFields objectAtIndex:index-1] becomeFirstResponder];

    if ([enteredCode length] == 5)
    {
        _correctImg.hidden = NO;
        _playButton.enabled = YES;
    }
    else
    {
        _correctImg.hidden = YES;
        _playButton.enabled = NO;
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

- (void) stopMusic
{
    UltimateRacerMenuViewController *parent = [self presentingViewController];
    [parent.player stop];
}
@end
