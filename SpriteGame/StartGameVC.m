//
//  StartGameVC.m
//  UltimateRacer
//
//  Created by Samir Choudhary on 11/9/13.
//  Copyright (c) 2013 Samir Choudhary. All rights reserved.
//

#import "StartGameVC.h"

@interface StartGameVC ()

@end

@implementation StartGameVC
{
    NSMutableString* uniqueCode1;
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
    
    code[0] = arc4random() % 26 + 65;
    code[1] = arc4random() % 26 + 65;
    code[2] = arc4random() % 26 + 65;
    code[3] = arc4random() % 26 + 65;
    code[4] = arc4random() % 26 + 65;
    
    uniqueCode1 = [[NSMutableString alloc] initWithCapacity:5];
    [uniqueCode1 appendFormat:@"%C%C%C%C%C", code[0], code[1], code[2], code[3], code[4]];
    
    _codeLabel.text = uniqueCode1;
    _codeLabel.font = [UIFont fontWithName:@"SubatomicTsoonami" size:120];
    _codeLabel.textColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
